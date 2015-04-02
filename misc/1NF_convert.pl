#!/usr/bin/perl

use strict;
use warnings;
use DBI;

my $conn= DBI->connect("dbi:mysql:mydb;mysql_socket=/usr/mysql/5.7.6/data/mysql.sock",
                       "root", "");

foreach my $row (@{$conn->selectall_arrayref("SELECT * FROM 0NF_bbs", {Slice => {}})})
{
  my $thread_title      = $row->{thread_title};
  my $thread_owner      = $row->{thread_owner};
  my $thread_owner_email= $row->{thread_owner_email};
  my $thread_created    = $row->{thread_created};

  foreach my $one_comment (split(/\n\n/, $row->{comments}))
  {
    $one_comment =~ m/^(?<comment_number>\d+)
                       :\s
                       (?<comment_owner>.+)
                       \s
                       (?<comment_created>\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2})
                       \n
                       (?<comment_body>.+)$/x;
    my $sql= "INSERT INTO 1NF_bbs VALUES (?, ?, ?, ?, ?, ?, 'sage', ?, ?)";
    $conn->do($sql, undef, $thread_title, $thread_owner, $thread_owner_email,
                           $thread_created, $+{comment_number}, $+{comment_owner},
                           $+{comment_created}, $+{comment_body});
  }
}



exit 0;

