-- Your SQL goes here
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR NOT NULL,
  password VARCHAR NOT NULL,
  CONSTRAINT username_unique UNIQUE(username)
);

-- admin / password
INSERT INTO users VALUES (1, 'admin', '$2b$12$3t3GsoJtfDa1QsWHGOE4yuk1bvlitGiq40dex3L5CQzAfFmrOYh6u');
SELECT setval('users_id_seq', 1, true);
