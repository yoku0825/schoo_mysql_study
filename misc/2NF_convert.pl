#!/usr/bin/perl

use strict;
use warnings;
use DBI;

my $conn= DBI->connect("dbi:mysql:mydb;mysql_socket=/usr/mysql/5.7.6/data/mysql.sock",
                       "root", "");
$conn->do("CREATE TABLE IF NOT EXISTS 2NF_bbs_main (" .
            "thread_title VARCHAR(255) NOT NULL, " .
            "thread_owner VARCHAR(255) NOT NULL, " .
            "comment_number INT UNSIGNED NOT NULL, " .
            "comment_owner VARCHAR(255) NOT NULL, " .
            "comment_owner_email VARCHAR(255) NOT NULL, " .
            "comment_created DATETIME NOT NULL, " .
            "comment_body LONGTEXT NOT NULL, " .
            "PRIMARY KEY (thread_title, thread_owner, comment_number))");
$conn->do("CREATE TABLE IF NOT EXISTS 2NF_thread_metadata (" .
            "thread_title VARCHAR(255) NOT NULL, " .
            "thread_owner VARCHAR(255) NOT NULL, " .
            "thread_created DATETIME NOT NULL, " .
            "PRIMARY KEY (thread_title, thread_owner))");
$conn->do("CREATE TABLE IF NOT EXISTS 2NF_user_email (" .
            "user_name VARCHAR(255) NOT NULL, " .
            "user_email VARCHAR(255) NOT NULL, " .
            "PRIMARY KEY (user_name))");

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

