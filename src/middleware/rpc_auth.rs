use crate::jwt::decode_token;
use actix_http::h1::Payload as H1Payload;
use actix_service::{Service, Transform};
use actix_web::{
    dev::{Payload, ServiceRequest, ServiceResponse},
    web::BytesMut,
    Error, HttpMessage, HttpResponse,
};
use futures::{
    future::{ok, Future, Ready},
    stream::StreamExt,
};
use std::cell::RefCell;
use std::pin::Pin;
use std::rc::Rc;
use std::task::{Context, Poll};
//use serde_json::{value::RawValue, Value};

const AUTHORIZATION: &str = "Authorization";
const IGNORE_METHODS: [&str; 3] = ["api.", "user.signin", "signin"];

pub struct Authentication;

impl<S: 'static, B> Transform<S> for Authentication
where
    S: Service<Request = ServiceRequest, Response = ServiceResponse<B>, Error = Error>,
    S::Future: 'static,
    B: 'static,
{
    type Request = ServiceRequest;
    type Response = ServiceResponse<B>;
    type Error = Error;
    type InitError = ();
    type Transform = AuthenticationMiddleware<S>;
    type Future = Ready<Result<Self::Transform, Self::InitError>>;

    fn new_transform(&self, service: S) -> Self::Future {
        ok(AuthenticationMiddleware {
            service: Rc::new(RefCell::new(service)),
        })
    }
}

pub struct AuthenticationMiddleware<S> {
    // This is special: We need this to avoid lifetime issues.
    service: Rc<RefCell<S>>,
}

impl<S, B> Service for AuthenticationMiddleware<S>
where
    S: Service<Request = ServiceRequest, Response = ServiceResponse<B>, Error = Error> + 'static,
    S::Future: 'static,
    B: 'static,
{
    type Request = ServiceRequest;
    type Response = ServiceResponse<B>;
    type Error = Error;
    type Future = Pin<Box<dyn Future<Output = Result<Self::Response, Self::Error>>>>;

    fn poll_ready(&mut self, cx: &mut Context) -> Poll<Result<(), Self::Error>> {
        self.service.poll_ready(cx)
    }

    fn call(&mut self, mut req: ServiceRequest) -> Self::Future {
        let mut svc = self.service.clone();

        Box::pin(async move {
            let method = get_method(&mut req).await;
            let token = get_token(&req);
            match check(&req, method, token) {
                CheckResult::Ok => {
                    let res = svc.call(req).await?;
                    Ok(res)
                }
                CheckResult::Error(e) => {
                    Ok(req.into_response(HttpResponse::Ok().json(rpc_error(e)).into_body()))
                }
            }
        })
    }
}

/// 验证结果
enum CheckResult {
    Ok,
    Error(&'static str),
}

fn check(_req: &ServiceRequest, method: Option<String>, token: Option<String>) -> CheckResult {
    if method.is_none() {
        return CheckResult::Error("未定义rpc方法");
    };
    let method = method.unwrap();
    if check_passed_method(&method) {
        return CheckResult::Ok;
    };
    if token.is_none() {
        return CheckResult::Error("未提供Token");
    };
    let token = token.unwrap();
    if let Ok(_token_data) = decode_token(&token) {
        /*
        let pool = req.app_data::<Pool>();
        if pool.is_none() {
            return CheckResult::Error("未提供数据库连接");
        };
        let pool = pool.unwrap();
        if let Ok(user) = User::find_user_by_username(&token_data.username, &pool.get().unwrap()) {
            // TODO
            // 验证方法在此
            // ...
            // 如果通过
            // info!("{} Logout...", username);
            // User::logout(user.id, &pool.get().unwrap());
            return CheckResult::Ok;
        } else {
            return CheckResult::Error("无效Token用户");
        }
        */
        return CheckResult::Ok;
    } else {
        return CheckResult::Error("无效Token");
    }
}

async fn get_method(req: &mut ServiceRequest) -> Option<String> {
    #[derive(Debug, Deserialize)]
    struct BytesRequestObject {
        method: Box<str>,
        //params: Option<Box<RawValue>>,
    }
    impl BytesRequestObject {
        pub fn method_ref(&self) -> &str {
            &self.method
        }
    }
    let mut body = BytesMut::new();
    let mut stream = req.take_payload();
    while let Some(chunk) = stream.next().await {
        body.extend_from_slice(&chunk.ok()?);
    }

    let body = body.freeze();
    let ro = serde_json::from_slice::<BytesRequestObject>(&body).ok()?;
    let method = ro.method_ref().to_owned();

    // 回填 payload
    let mut pl = H1Payload::empty();
    pl.unread_data(body);
    req.set_payload(Payload::H1(pl));

    Some(method)
}

fn get_token(req: &ServiceRequest) -> Option<String> {
    let authen_header = req.headers().get(AUTHORIZATION)?;
    let authen_str = authen_header.to_str().ok()?;
    if authen_str.starts_with("bearer") || authen_str.starts_with("Bearer") {
        let token = authen_str[6..authen_str.len()].trim();
        Some(token.to_string())
    } else {
        None
    }
}

/// 检查无需验证的方法，返回true时无需验证。
fn check_passed_method(method: &str) -> bool {
    for ignore_method in IGNORE_METHODS.iter() {
        if method.starts_with(ignore_method) {
            return true;
        }
    }
    false
}

#[derive(Serialize)]
struct ErrorResponse {
    jsonrpc: &'static str,
    error: RpcError,
    id: i8,
}

#[derive(Serialize)]
struct RpcError {
    code: i64,
    message: &'static str,
    data: String,
}

fn rpc_error(e: &str) -> ErrorResponse {
    ErrorResponse {
        jsonrpc: "2.0",
        error: RpcError {
            code: -32099,
            message: "访问未授权",
            data: e.to_string(),
        },
        id: 0,
    }
}
