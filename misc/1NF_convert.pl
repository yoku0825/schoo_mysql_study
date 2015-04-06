#!/usr/bin/perl

use strict;
use warnings;
use DBI;

my $conn= DBI->connect("dbi:mysql:mydb;mysql_socket=/usr/mysql/5.7.6/data/mysql.sock",
                       "root", "");
$conn->do("CREATE TABLE IF NOT EXISTS 1NF_bbs (" .
            "thread_title VARCHAR(255) NOT NULL, " .
            "thread_owner VARCHAR(255) NOT NULL, " .
            "thread_owner_email VARCHAR(255) NOT NULL, " .
            "thread_created DATETIME NOT NULL, " .
            "comment_number INT UNSIGNED NOT NULL, " .
            "comment_owner VARCHAR(255) NOT NULL, " .
            "comment_owner_email VARCHAR(255) NOT NULL, " .
            "comment_created DATETIME NOT NULL, " .
            "comment_body LONGTEXT NOT NULL, " .
            "PRIMARY KEY (thread_title, thread_owner, comment_number))");


foreach my $row (@{$conn->selectall_arrayref("SELECT * FROM 0NF_bbs", {Slice => {}})})
{
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
    $conn->do($sql, undef, $row->{thread_title}, $row->{thread_owner},
                           $row->{thread_owner_email}, $row->{thread_created},
                           $+{comment_number}, $+{comment_owner},
                           $+{comment_created}, $+{comment_body});
  }
}



exit 0;

