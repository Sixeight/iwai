# Iwai

This is a web service that manages Amazon wishlist for private use.

## Requires

* PostgreSQL
* Node.js
* Perl
* cpanminus

## Setup

```
$ ./script/setup.sh
```

## Run

```
COOKIE_SECRET=[COOKIE_SECRET]                    \
  CONSUMER_KEY=[YOUR_TWITTER_CONSUMER_KEY]       \
  CONSUMER_SECRET=[YOUR_TWITTER_CONSUMER_SECRET] \
  plackup script/app.psgi
```

and open http://localhost:5000/

## Contributing

1. Fork it ( http://github.com/Sixeight/iwai/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
