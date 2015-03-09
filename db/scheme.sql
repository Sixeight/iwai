
CREATE TABLE users (
  id         SERIAL PRIMARY KEY,
  name       VARCHAR(32) NOT NULL UNIQUE,
  twitter_id INT NOT NULL UNIQUE
);
CREATE INDEX users_twitter_id_index ON users (twitter_id);

CREATE TABLE wishlists (
  id    SERIAL PRIMARY KEY,
  url   VARCHAR(64) NOT NULL UNIQUE,
  title VARCHAR(64) NOT NULL,
  memo  VARCHAR(255)
);
