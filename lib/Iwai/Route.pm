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
      action     => "my_json",
    };

    connect "/user/:name.json" => {
      controller => "List",
      action     => "user_json",
    };

    connect "/user/:name" => {
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

    connect "/check" => {
      controller => "List",
      action     => "check",
    }, { method => "POST" };

    connect "/copy" => {
      controller => "List",
      action     => "copy",
    }, { method => "POST" };
  };
}

1;
