package Schoo_study::Web;

use strict;
use warnings;
use utf8;
use Kossy;
use Schoo_study::Lib;
use Plack::Request;
use Data::Dumper;


get "/0NF" => sub
{
  my ($self, $c)= @_;
  my $thread_list_sql= "SELECT thread_title, thread_owner, " .
                         "thread_owner_email, thread_created, comments " .
                       "FROM 0NF_bbs " .
                       "ORDER BY thread_created DESC, thread_title DESC";
  $c->stash->{me}= "0NF";
  $c->render("0NF.tx", {thread_list => make_array($thread_list_sql)});
};

get "/1NF" => sub
{
  my ($self, $c)= @_;
  my $thread_list_sql= "SELECT thread_title, thread_owner, " .
                         "thread_owner_email, thread_created, " .
                         "GROUP_CONCAT(CONCAT(comment_number, ': ', " .
                                             "comment_owner, ' <', " .
                                             "comment_owner_email, '> ', " .
                                             "comment_created, '\\n', " .
                                             "comment_body, '\\n') SEPARATOR '\\n') AS comments " .
                       "FROM 1NF_bbs " .
                       "GROUP BY thread_title, thread_owner, " .
                         "thread_owner_email, thread_created " .
                       "ORDER BY thread_created DESC, thread_title DESC";
  $c->stash->{me}= "1NF";
  $c->render("1NF.tx", {thread_list => make_array($thread_list_sql)});
};

get "/1NF_more" => sub
{
  my ($self, $c)= @_;
  my $thread_title_list_sql= "SELECT DISTINCT thread_title, thread_owner, " .
                               "thread_owner_email, thread_created " .
                             "FROM 1NF_bbs " .
                             "ORDER BY thread_created DESC, thread_title DESC";
  my $comment_list_sql     = "SELECT comment_number, comment_owner, " .
                               "comment_owner_email, comment_created, comment_body " .
                             "FROM 1NF_bbs " .
                             "WHERE thread_title= ? AND thread_owner= ? " .
                             "ORDER BY comment_number";

  my $threads = make_array($thread_title_list_sql);

  foreach my $one_thread (@$threads)
  {
    $one_thread->{comments}= make_array($comment_list_sql, $one_thread->{thread_title},
                                        $one_thread->{thread_owner});
  }

  $c->stash->{me}= "1NF_more";
  $c->render("1NF_more.tx", {thread_list => $threads});
};

get "/2NF" => sub
{
  my ($self, $c)= @_;
  my $thread_list_sql= "SELECT main.thread_title, main.thread_owner, " .
                         "user.user_email AS thread_owner_email, meta.thread_created, " .
                         "GROUP_CONCAT(CONCAT(main.comment_number, ': ', " .
                                             "main.comment_owner, ' <', " .
                                             "main.comment_owner_email, '> ', " .
                                             "main.comment_created, '\\n', " .
                                             "main.comment_body, '\\n') SEPARATOR '\\n') AS comments " .
                       "FROM 2NF_bbs_main AS main " .
                         "INNER JOIN 2NF_thread_metadata AS meta USING(thread_title, thread_owner) " .
                         "INNER JOIN 2NF_user_email AS user ON main.thread_owner= user.user_name " .
                       "GROUP BY thread_title, thread_owner, " .
                         "user_email, thread_created " .
                       "ORDER BY thread_created DESC, thread_title DESC";
  $c->stash->{me}= "2NF";
  $c->render("2NF.tx", {thread_list => make_array($thread_list_sql)});
};



return 1;

