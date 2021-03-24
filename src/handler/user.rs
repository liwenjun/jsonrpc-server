use crate::database::Pool;
use crate::jwt::Claims;
use jsonrpc_v2::{Data, Error, Params};

use crate::models::user::{LoginDTO, NewUser, User};

pub async fn signin(Params(params): Params<LoginDTO>, pool: Data<Pool>) -> Result<String, Error> {
    let user = User::login(params, &pool.get().unwrap()).map_err(|_e| Error::INTERNAL_ERROR)?;
    Claims::generate_token(&user.username).map_err(|_e| Error::INTERNAL_ERROR)
}

pub async fn signup(Params(params): Params<NewUser>, pool: Data<Pool>) -> Result<usize, Error> {
    User::signup(params, &pool.get().unwrap()).map_err(|_e| Error::INTERNAL_ERROR)
}
