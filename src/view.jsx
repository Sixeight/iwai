
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
    var word = e.target.value.trim();
    this.props.onChange(word.toLowerCase());
    this.setState({
      url: word
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
  handleClick: function(e) {
    if (confirm("本当に削除しますか？")) {
      Store.remove(e.target.dataset.listId);
    }
  },
  render: function() {
    var wishlists = this.props.wishlists;
    var search = this.props.search;
    if (search.length > 0 && !search.startsWith("http")) {
      wishlists = wishlists.filter(function(list) {
        return list.name.toLowerCase().match(search) ||
          list.title.toLowerCase().match(search);
      });
    }
    return (
      <table className="table table-striped">
        <thead>
          <tr>
            <th>タイトル</th>
            <th>名前</th>
            <th>説明</th>
            <th>誕生日</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          {wishlists.map(function(list) {
            return (
              <tr>
                <td><a href={list.url} target="_blank">{list.title}</a></td>
                <td>{list.name}</td>
                <td>{list.desc}</td>
                <td>{list.birth}</td>
                <td className="action">
                  <a onClick={this.handleClick} data-list-id={list.id} className="glyphicon glyphicon-remove" aria-hidden="true"></a>
                </td>
              </tr>
            );
          }.bind(this))}
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
