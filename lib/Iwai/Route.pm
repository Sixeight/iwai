package Iwai::Route;

use strict;
use warnings;

use Router::Simple::Declare;

sub mk_router {
  router {
    connect "/" => {
      redirect => "/list",
    };

    connect "/list" => {
      controller => "List",
      action     => "index",
    };

    connect "/add" => {
      controller => "List",
      action     => "create",
    }, { method => "POST" };

    connect "/remove" => {
      controller => "List",
      action     => "delete",
    }, { method => "POST" };

    connect "/update" => {
      controller => "List",
      action     => "update",
    }, { method => "POST" };
  };
}

1;
