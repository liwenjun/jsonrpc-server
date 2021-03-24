//! 启动 HTTPServer

use crate::config::CONFIG;
use crate::handler::add_rpc;
use actix_cors::Cors;
use actix_files as fs;
use actix_web::{
    http::header,
    middleware::Logger,
    web::{self, HttpRequest, HttpResponse},
    App, HttpServer,
};

pub async fn server() -> std::io::Result<()> {
    dotenv::dotenv().ok();
    env_logger::init();

    HttpServer::new(move || {
        let cors = Cors::default()
            .allow_any_origin()
            .allow_any_method()
            .allow_any_header()
            .max_age(3600);

        App::new()
            .wrap(cors)
            .wrap(Logger::default())
            .configure(add_rpc) // jsonrpc 服务
            .service(
                fs::Files::new("", "./static")
                    .index_file("index.html")
                    .use_last_modified(true),
            )
            // 解决非`/`页面刷新报错，自动转向`/`
            .default_service(web::resource("").route(web::get().to(|_req: HttpRequest| {
                HttpResponse::Found().header(header::LOCATION, "/").finish()
            })))
    })
    .bind(&CONFIG.server)?
    .run()
    .await
}
