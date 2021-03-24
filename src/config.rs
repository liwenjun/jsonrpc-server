//! 从 dotenv 和 env 获取环境变量，使用 Config 结构。
//!
//! 使用 lazy_static 仅开机加载一次。

use dotenv::dotenv;
use serde::Deserialize;

#[derive(Clone, Deserialize, Debug)]
pub struct Config {
    pub database_url: String,
    pub jwt_expiration: i64,
    pub jwt_key: String,
    pub rust_backtrace: u8,
    pub rust_log: String,
    pub server: String,
}

// 延迟加载配置文件，只运行一次
lazy_static! {
    pub static ref CONFIG: Config = get_config();
}

/// Use envy to inject dotenv and env vars into the Config struct
fn get_config() -> Config {
    dotenv().ok();

    match envy::from_env::<Config>() {
        Ok(config) => config,
        Err(error) => panic!("Configuration Error: {:#?}", error),
    }
}
