mod user;

use crate::database::migrate_and_config_db;
use crate::middleware;
use actix_cors::Cors;
use actix_web::{guard, web, web::ServiceConfig};
use jsonrpc_v2::{Data, Server};

pub fn add_rpc(cfg: &mut ServiceConfig) {
    let pool = migrate_and_config_db();

    let rpc = Server::new()
        .with_data(Data::new(pool.clone()))
        .with_method("user.signup", user::signup)
        .with_method("user.signin", user::signin)
        .finish();

    let cors = Cors::default()
        .allow_any_origin()
        .allow_any_method()
        .allow_any_header()
        .max_age(3600);

    cfg.service(
        web::scope("/jsonrpc")
            .wrap(cors)
            .wrap(middleware::rpc_auth::Authentication)
            .service(
                web::service("/v2")
                    .guard(guard::Post())
                    .finish(rpc.into_web_service()),
            ),
    );
}
