
var React = require("react");
var Store = require("./store.js");

var Form = React.createClass({
  getInitialState: function() {
    return {
      url: ""
    };

  },
  handleSubmit: function(e) {
    e.preventDefault();
    if (this.state.url == "") {
      return;
    }
    Store.create(this.state.url);
    this.setState({
      url: "",
      error: ""
    });
  },
  handleChange: function(e) {
    this.setState({
      url: e.target.value
    });
  },
  render: function() {
    return (
      <div>
        <form onSubmit={this.handleSubmit}>
          <input onChange={this.handleChange} value={this.state.url} placeholder="Wishlist の URL" />
          <input type="submit" />
        </form>
      </div>
    )
  },
});

var List = React.createClass({
  render: function() {
    return (
      <ul>
        {this.props.wishlists.map(function(list) {
          return <li><a href={list.url} target="_blank">{list.title}</a>: {list.name} {list.desc} {list.birth}</li>
        })}
      </ul>
    );
  },
});

var App = React.createClass({
  getInitialState: function() {
    return {
      wishlists: [],
      error: ""
    };
  },
  componentDidMount: function() {
    Store.on("fetch", function(list) {
      this.setState({
        wishlists: list,
        error: "",
      });
    }.bind(this));
    Store.on("error", function(errorMsg) {
      this.setState({
        error: errorMsg
      });
    }.bind(this));
    var updateList = function() {
      Store.fetchAll();
    };
    Store.on("change", updateList);
    Store.on("adding", function() {
      var list = this.state.wishlists;
      list.unshift({url: "#", title: "読み込み中"});
      this.setState({
        wishlists: list
      });
    }.bind(this));
    updateList();
  },
  render: function() {
    return (
      <div>
        <h1>Iwai</h1>
        <div className="error">
          {this.state.error}
        </div>
        <Form />
        <List wishlists={this.state.wishlists} />
      </div>
    );
  },
});

module.exports = App;
