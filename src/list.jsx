var React = require("react");
var Store = require("./store.js")

var List = React.createClass({
  handleClick: function(e) {
    if (confirm("本当に削除しますか？")) {
      Store.remove(e.target.parentNode.parentNode.dataset.listId);
    }
  },
  handleCheck: function(e) {
    var target = e.target;
    var checked = target.checked ? 1 : 0;
    var id = target.parentNode.parentNode.dataset.listId;
    Store.check(id, checked, function() {
      target.checked = checked == 1 ? false : true;
    });
  },
  render: function() {
    var wishlists = this.props.wishlists;
    var search = this.props.search.toLowerCase();
    if (search.length > 0 && !search.match("^http")) {
      wishlists = wishlists.filter(function(list) {
        return (list.name && list.name.toLowerCase().match(search)) ||
          (list.title && list.title.toLowerCase().match(search))    ||
          (list.desc  && list.desc.toLowerCase().match(search))     ||
          (list.birth && list.birth.match(search));
      });
    }
    return (
      <table className="table table-striped">
        <thead>
          <tr>
            <th><span className="glyphicon glyphicon-ok" aria-hidden="true"></span></th>
            <th>タイトル</th>
            <th>名前</th>
            <th>説明</th>
            <th>誕生日</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          {wishlists.map(function(list) {
            var remain = "";
            if (list.birth_rd < 10) {
              remain = " (" + list.birth_rd +  "日後)";
            }
            return (
              <tr data-list-id={list.id}>
                <td>
                  <input type="checkbox" checked={list.checked} onChange={this.handleCheck} />
                </td>
                <td><a href={list.url} target="_blank">{list.title}</a></td>
                <td>{list.name}</td>
                <td>{list.desc}</td>
                <td>{list.birth}<strong>{remain}</strong></td>
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
