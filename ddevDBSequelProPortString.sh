#!/usr/bin/expect

set host [lindex $argv 0];
set username [lindex $argv 1];
set password [lindex $argv 2];


set timeout 20

eval spawn "ssh -t $username@$host \"docker ps | grep 3306\""
expect "assword:"
send "$password\r";
interact


