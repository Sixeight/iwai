
CREATE TABLE IF NOT EXISTS users (
  id         SERIAL PRIMARY KEY,
  name       VARCHAR(32) NOT NULL UNIQUE,
  twitter_id INT NOT NULL UNIQUE,

  joined_at TIMESTAMP NOT NULL
);
CREATE INDEX users_twitter_id_index ON users (twitter_id);

CREATE TABLE IF NOT EXISTS users_wishlists (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL,
  wishlist_id INT NOT NULL,

  created_at TIMESTAMP NOT NULL,

  UNIQUE (user_id, wishlist_id)
);
CREATE INDEX user_id_users_wishlists_index ON users_wishlists (user_id);

CREATE TABLE IF NOT EXISTS wishlists (
  id      SERIAL PRIMARY KEY,
  url     VARCHAR(64) NOT NULL,
  title   VARCHAR(64) NOT NULL,
  name    VARCHAR(32),
  birth   DATE,
  description VARCHAR(255),

  created_at TIMESTAMP NOT NULL,
  updated_at  TIMESTAMP NOT NULL
);
