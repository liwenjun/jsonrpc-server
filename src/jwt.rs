//! jwt token

use crate::config::CONFIG;
use chrono::{Duration, Local};
use jsonwebtoken::{decode, encode, errors::Result, DecodingKey, EncodingKey, Header, Validation};

#[derive(Debug, Serialize, Deserialize)]
pub struct Claims {
    // issued at
    pub iat: i64,
    // expiration
    pub exp: i64,
    // data
    pub username: String,
}

impl Claims {
    pub fn generate_token(username: &str) -> Result<String> {
        let iat = Local::now();
        let exp = iat + Duration::hours(i64::from(CONFIG.jwt_expiration));

        let payload = Claims {
            iat: iat.timestamp(),
            exp: exp.timestamp(),
            username: username.to_owned(),
        };

        encode(
            &Header::default(),
            &payload,
            &EncodingKey::from_secret(&CONFIG.jwt_key.as_ref()),
        )
    }
}

pub fn decode_token(token: &str) -> Result<Claims> {
    decode::<Claims>(
        token,
        &DecodingKey::from_secret(&CONFIG.jwt_key.as_ref()),
        &Validation::default(),
    )
    .map(|data| data.claims)
}
