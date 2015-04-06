#!/usr/bin/perl

use strict;
use warnings;
use Time::Piece;
use DBI;

my $conn= DBI->connect("dbi:mysql:mydb;mysql_socket=/usr/mysql/5.7.6/data/mysql.sock",
                       "root", "");
$conn->do("CREATE TABLE IF NOT EXISTS 0NF_bbs (" .
            "thread_title VARCHAR(255) NOT NULL, " .
            "thread_owner VARCHAR(255) NOT NULL, " .
            "thread_owner_email VARCHAR(255) NOT NULL, " .
            "thread_created DATETIME NOT NULL, " .
            "comments LONGTEXT NOT NULL, " .
            "PRIMARY KEY (thread_title, thread_owner))");

for (my $n = 1; $n < 10; $n++)
{
  my $thread_title      = rand_virtual_name();
  my $thread_owner      = "yoku0825";
  my $thread_owner_email= "sage";
  my $thread_created    = Time::Piece::localtime->strftime("%Y-%m-%d %H:%M:%S");
  my $comments          = "";

  for (my $m = 1; $m < rand(100); $m++)
  {
    $comments .= sprintf("%d: 名無しさん %s\n%s\n\n",
                         $m, Time::Piece::localtime->strftime("%Y-%m-%d %H:%M:%S"),
                         rand_virtual_name());
  }

  $comments =~ s/\n\n$//;
  $conn->do("INSERT IGNORE INTO 0NF_bbs VALUES (?, ?, ?, ?, ?)", undef,
            $thread_title, $thread_owner, $thread_owner_email, $thread_created, $comments);
}
    
exit 0;


sub rand_virtual_name
{
  my @a= ("コードギアス亡国の", "ジョジョの", "中二病でも", "アイドル", "恋と選挙と", "電波女と", "アウトブレイク", "ささみさん", "人類は", "テラ", "進撃の", "僕は友達が", "とある魔術の", "謎の", "殺人", "インフィニット", "魔法少女", "ガンダム", "13日の", "さんをつけろよ");
  my @b= ("アキト", "奇妙な冒険", "恋がしたい!", "マスター", "チョコレート", "青春男", "カンパニー", "＠がんばらない", "衰退しました", "フォーマーズ", "巨人", "少ない", "禁書目録", "彼女X", "教室", "ストラトス", "まどか☆マギカ", "UC[ユニコーン]", "金曜日", "デコ助野郎!");

  return $a[rand($#a)] . $b[rand($#b)];
}
