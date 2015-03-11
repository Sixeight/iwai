
superagent = require("superagent");

var Store = {
  callbacks: {
    adding: [],
    change: [],
    fetch:  [],
    error:  [],
    removing: [],
    remove: [],
  },
  fetchAll: function() {
    var store = this;
    superagent
      .get("/list.json")
      .end(function(err, res) {
        if (res.ok) {
          store.dispatch("fetch", res.body);
        } else {
          store.dispatch("error", "ほしいものリストの取得に失敗しました");
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
          store.dispatch("error", "ほしいものリストの追加に失敗しました: " + url);
        }
      });
  },
  remove: function(id) {
    var store = this;
    store.dispatch("removing", id);
    superagent
      .post("/remove")
      .type("form")
      .send({id: id})
      .end(function(err, res) {
        if (res.ok) {
          store.dispatch("remove", id);
        } else {
          store.dispatch("chane");
          store.dispatch("error", "削除に失敗しました");
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
