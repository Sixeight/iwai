
var React = require("react");
var Store = require("./store.js");
var Form  = require("./form.jsx");
var List  = require("./list.jsx")
var Error = require("./error.jsx")

var App = React.createClass({
  getInitialState: function() {
    return {
      wishlists: [],
      search: "",
      error: ""
    };
  },
  componentDidMount: function() {
    Store.on("fetch", this.fetchCalback);
    Store.on("error", this.errorCallback);
    Store.on("change", this.changeCallback);
    Store.on("adding", this.addingCallback);
    Store.on("removing", this.removingCallback);
    Store.fetchAll();
  },
  fetchCalback: function(list) {
    this.setState({
      wishlists: list,
    });
  },
  errorCallback: function(errorMsg) {
    var list = this.state.wishlists;
    for (var i = 0; i < list.length; i++) {
      if (list[i].title == "読み込み中") {
        list.splice(i, 1);
        break;
      }
    }
    this.setState({
      wishlists: list,
      error: errorMsg
    });
    setTimeout(function() {
      this.setState({
        error: ""
      });
    }.bind(this), 3000);
  },
  changeCallback: function() {
    Store.fetchAll();
  },
  addingCallback: function() {
    var list = this.state.wishlists;
    list.push({url: "#", title: "読み込み中"});
    this.setState({
      wishlists: list,
    });
  },
  removingCallback: function(id) {
    var list = this.state.wishlists.filter(function(list) {
      return list.id != id
    });
    this.setState({
      wishlists: list
    });
  },
  handleSearch: function(word) {
    this.setState({
      search: word
    });
  },
  render: function() {
    return (
      <div>
        <Error error={this.state.error} />
        <Form onChange={this.handleSearch} />
        <List wishlists={this.state.wishlists} search={this.state.search} />
      </div>
    );
  },
});

module.exports = App;
