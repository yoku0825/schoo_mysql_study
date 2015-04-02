package Schoo_study::Web;

use strict;
use warnings;
use utf8;
use Schoo_study::Lib;
use Kossy;
use Data::Dumper;


get '/0NF' => sub
{
  my ($self, $c)  = @_;
  my $thread_list_sql= "SELECT thread_title, thread_owner, thread_created, comments " .
                       "FROM 0NF_bbs " .
                       "ORDER BY thread_created DESC";
  $c->render('0NF_bbs.tx', {thread_list => thread_list($thread_list_sql)});
};

return 1;

