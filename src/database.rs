//! 数据库连接池

use crate::config::CONFIG;
use actix_web::web;
use diesel::{
    pg::PgConnection,
    r2d2::{self, ConnectionManager},
};

pub type Connection = PgConnection;
pub type Pool = r2d2::Pool<ConnectionManager<Connection>>;

embed_migrations!();

pub fn migrate_and_config_db() -> Pool {
    debug!("Migrating and configurating database...");
    let manager = ConnectionManager::<Connection>::new(&CONFIG.database_url);
    let pool = r2d2::Pool::builder()
        .max_size(4)
        .build(manager)
        .expect("Failed to create pool.");
    let _ = embedded_migrations::run(&pool.get().expect("Failed to migrate."));
    pool
}

pub fn add_pool(cfg: &mut web::ServiceConfig) {
    let pool = migrate_and_config_db();
    cfg.data(pool.clone());
}
