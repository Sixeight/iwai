
CREATE TABLE IF NOT EXISTS users (
  id         SERIAL PRIMARY KEY,
  name       VARCHAR(32) NOT NULL UNIQUE,
  twitter_id INT NOT NULL UNIQUE,

  joined_at TIMESTAMP NOT NULL
);
/* CREATE INDEX has no IF NOT EXISTS */
CREATE INDEX users_twitter_id_index ON users (twitter_id);

CREATE TABLE IF NOT EXISTS wishlists (
  id      SERIAL PRIMARY KEY,
  url     VARCHAR(64) NOT NULL,
  title   VARCHAR(64) NOT NULL,
  name    VARCHAR(32),
  birth   VARCHAR(12),
  description VARCHAR(255),
  user_id INT NOT NULL,

  created_at TIMESTAMP NOT NULL,
  updated_at  TIMESTAMP NOT NULL
);
/* CREATE INDEX has no IF NOT EXISTS */
CREATE INDEX wishlists_user_id_index ON wishlists (user_id);
