//! 用户模型

use crate::database::Connection;
use bcrypt::{hash, verify, DEFAULT_COST};
use diesel::prelude::*;
use crate::schema::users;

#[derive(Identifiable, Insertable, Queryable, Serialize, Deserialize)]
pub struct User {
    pub id: i32,
    pub username: String,
    pub password: String,
}

#[derive(Insertable, Serialize, Deserialize)]
#[table_name = "users"]
pub struct NewUser {
    pub username: String,
    pub password: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct LoginDTO {
    pub username: String,
    pub password: String,
}

impl User {
    /// 注册用户，返回Ok(0)表示已注册
    pub fn signup(user: NewUser, conn: &Connection) -> QueryResult<usize> {
        use crate::schema::users::dsl::users;
        let u = NewUser {
            username: user.username,
            password: encrypt(&user.password),
        };
        match Self::find_user_by_username(&u.username, conn) {
            Ok(_) => Ok(0),
            Err(_) => diesel::insert_into(users).values(u).execute(conn),
        }
    }

    /// 按 id 查询用户，用于登录后获取用户信息
    pub fn find(user_id: i32, conn: &Connection) -> QueryResult<User> {
        use crate::schema::users::dsl::{id, users};
        users.filter(id.eq(user_id)).first(conn)
    }

    /// 用户登录
    pub fn login(login: LoginDTO, conn: &Connection) -> QueryResult<User> {
        use crate::schema::users::dsl::{username, users};
        let user_to_verify = users
            .filter(username.eq(&login.username))
            .first::<User>(conn)?;

        // TODO 这个逻辑可以优化
        if !user_to_verify.password.is_empty() {
            if let Ok(b) = verify(&login.password, &user_to_verify.password) {
                if b {
                    return Ok(user_to_verify);
                }
            }
        };
        Err(diesel::result::Error::NotFound)
    }

    /// 按username 查询用户
    pub fn find_user_by_username(un: &str, conn: &Connection) -> QueryResult<User> {
        use crate::schema::users::dsl::{username, users};
        users.filter(username.eq(un)).get_result::<User>(conn)
    }

    /// 列表所有用户
    pub fn find_all(conn: &Connection) -> QueryResult<Vec<User>> {
        use crate::schema::users::dsl::{id, users};
        users.order(id.asc()).load::<User>(conn)
    }
}

fn encrypt(psw: &str) -> String {
    match hash(psw, DEFAULT_COST) {
        Ok(p) => p,
        Err(_) => "".to_owned(),
    }
}
