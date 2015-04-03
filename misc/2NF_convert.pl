#!/usr/bin/perl

use strict;
use warnings;
use DBI;

my $conn= DBI->connect("dbi:mysql:mydb;mysql_socket=/usr/mysql/5.7.6/data/mysql.sock",
                       "root", "");

foreach my $row (@{$conn->selectall_arrayref("SELECT * FROM 1NF_bbs", {Slice => {}})})
{
  $conn->do("INSERT IGNORE INTO 2NF_user_email VALUES (?, ?)", undef,
            $row->{thread_owner}, $row->{thread_owner_email});
  $conn->do("INSERT IGNORE INTO 2NF_thread_metadata VALUES (?, ?, ?)", undef,
            $row->{thread_title}, $row->{thread_owner}, $row->{thread_created});
  $conn->do("INSERT INTO 2NF_bbs_main VALUES (?, ?, ?, ?, ?, ?, ?)", undef, 
            $row->{thread_title}, $row->{thread_owner}, $row->{comment_number},
            $row->{comment_owner}, $row->{comment_owner_email},
            $row->{comment_created}, $row->{comment_body});
}



exit 0;

