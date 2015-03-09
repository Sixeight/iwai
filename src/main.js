var React = require("react");
var view = require("./view.jsx");

React.renderComponent(
  view(),
  document.getElementById("contents")
);
