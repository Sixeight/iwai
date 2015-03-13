
superagent = require("superagent");

var Store = {
  callbacks: {
    adding: [],
    change: [],
    fetch:  [],
    error:  [],
    removing: [],
    remove: [],
    check: [],
    copy: [],
    copying: [],
  },
  listJsonPath: "/list.json",
  readOnly: false,
  setName: function(name) {
    if (name) {
      this.listJsonPath = "/user/" + name + ".json";
      this.readOnly = true;
    }
  },
  fetchAll: function() {
    var store = this;
    superagent
      .get(this.listJsonPath)
      .end(function(err, res) {
        if (res.ok) {
          store.dispatch("fetch", res.body);
        } else {
          store.dispatch("error", "ほしいものリストの取得に失敗しました");
        }
      });
  },
  create: function(url) {
    if (this.readOnly) { return; }
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
    if (this.readOnly) { return; }
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
          store.dispatch("change");
          store.dispatch("error", "削除に失敗しました");
        }
      });
  },
  check: function(id, checked, errorCallback) {
    if (this.readOnly) { return; }
    var store = this;
    superagent
      .post("/check")
      .type("form")
      .send({id: id, checked: checked})
      .end(function(err, res) {
        if (res.ok) {
          store.dispatch("check", id);
        } else {
          errorCallback();
          store.dispatch("error", "マークをつけられませんでした");
        }
      });
  },
  copy: function(wishlisId) {
    if (!this.readOnly) { return; }
    var store = this;
    store.dispatch("copying", wishlisId);
    superagent
      .post("/copy")
      .type("form")
      .send({wishlist_id: wishlisId})
      .end(function(err, res) {
        if (res.ok) {
          store.dispatch("copy", wishlisId)
        } else {
          store.dispatch("change");
          store.dispatch("error", "追加出来ませんでした");
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
