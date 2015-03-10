
superagent = require("superagent");

var Store = {
  callbacks: {
    adding: [],
    change: [],
    fetch:  [],
    error:  [],
  },
  fetchAll: function() {
    var store = this;
    superagent
      .get("/list.json")
      .end(function(err, res) {
        if (res.ok) {
          store.dispatch("fetch", res.body);
        } else {
          store.dispatch("error", "Failed to fetch wishlists.");
        }
      });
  },
  create: function(url) {
    var store = this;
    store.dispatch("adding");
    superagent
      .post("/add")
      .type("form")
      .send({url: url})
      .end(function(err, res) {
        if (res.ok) {
          store.dispatch("change");
        } else {
          store.dispatch("error", "Failed to add wishlist: " + url);
        }
      });
  },
  on: function(name, callback) {
    if (!this.callbacks[name]) {
      return;
    }
    this.callbacks[name].push(callback);
  },
  dispatch: function(name, arg) {
    var callbacks = this.callbacks[name];
    if (!callbacks) { return }
    callbacks.forEach(function(callback) {
      callback(arg);
    });
  },
};

module.exports = Store;
