
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
    Store.on("fetch", function(list) {
      this.setState({
        wishlists: list,
      });
    }.bind(this));
    Store.on("error", function(errorMsg) {
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
    }.bind(this));
    var updateList = function() {
      Store.fetchAll();
    };
    Store.on("change", updateList);
    Store.on("adding", function() {
      var list = this.state.wishlists;
      list.push({url: "#", title: "読み込み中"});
      this.setState({
        wishlists: list,
      });
    }.bind(this));
    Store.on("removing", function(id) {
      var list = this.state.wishlists.filter(function(list) {
        return list.id != id
      });
      this.setState({
        wishlists: list
      });
    }.bind(this));
    updateList();
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
