
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
      url: e.target.value.trim()
    });
  },
  render: function() {
    return (
      <form onSubmit={this.handleSubmit}>
        <div className="form-group">
          <input type="url" onChange={this.handleChange} className="form-control" value={this.state.url} placeholder="ほしいものリストのURL" />
        </div>
      </form>
    )
  },
});

var List = React.createClass({
  render: function() {
    return (
      <table className="table table-striped">
        <thead>
          <tr>
            <th>タイトル</th>
            <th>名前</th>
            <th>説明</th>
            <th>誕生日</th>
          </tr>
        </thead>
        <tbody>
          {this.props.wishlists.map(function(list) {
            return (
              <tr>
                <td><a href={list.url} target="_blank">{list.title}</a></td>
                <td>{list.name}</td>
                <td>{list.desc}</td>
                <td>{list.birth}</td>
              </tr>
            );
          })}
        </tbody>
      </table>
    );
  },
});

var Error = React.createClass({
  render: function() {
    var error = "";
    if (this.props.error != "") {
      error = (
        <div className="error">
          <p className="bg-danger">{this.props.error}</p>
        </div>
      );
    }
    return (
      <div>
        {error}
      </div>
    )
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
        <Error error={this.state.error} />
        <Form />
        <List wishlists={this.state.wishlists} />
      </div>
    );
  },
});

module.exports = App;
