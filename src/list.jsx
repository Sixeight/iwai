var React = require("react");
var Store = require("./store.js")

var List = React.createClass({
  handleClick: function(e) {
    if (confirm("本当に削除しますか？")) {
      Store.remove(e.target.parentNode.parentNode.dataset.listId);
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
              <tr data-list-id={list.id}>
                <td><a href={list.url} target="_blank">{list.title}</a></td>
                <td>{list.name}</td>
                <td>{list.desc}</td>
                <td>{list.birth}</td>
                <td className="action">
                  <a onClick={this.handleClick} className="glyphicon glyphicon-remove" aria-hidden="true"></a>
                </td>
              </tr>
            );
          }.bind(this))}
        </tbody>
      </table>
    );
  },
});

module.exports = List;
