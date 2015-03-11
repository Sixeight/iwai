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

    connect "/list.json" => {
      controller => "List",
      action     => "json",
    };

    connect "/add" => {
      controller => "List",
      action     => "create",
    }, { method => "POST" };

    connect "/remove" => {
      controller => "List",
      action     => "delete",
    }, { method => "POST" };

    connect "/check" => {
      controller => "List",
      action     => "check",
    }, { method => "POST" };
  };
}

1;
