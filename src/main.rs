#[macro_use]
extern crate lazy_static;
#[macro_use]
extern crate log;
#[macro_use]
extern crate diesel;
#[macro_use]
extern crate diesel_migrations;
#[macro_use]
extern crate serde_derive;

use crate::server::server;

mod config;
mod database;
mod handler;
mod jwt;
mod middleware;
pub mod models;
mod schema;
mod server;

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    server().await
}
