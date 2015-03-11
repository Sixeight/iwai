var React = require("react");

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

module.exports = Error;
