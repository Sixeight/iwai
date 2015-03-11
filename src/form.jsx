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

module.exports = Form;
