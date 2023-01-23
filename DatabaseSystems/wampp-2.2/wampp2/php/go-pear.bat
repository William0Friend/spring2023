@ECHO OFF
set PHP_BIN=cli\php.exe
%PHP_BIN% -n -d output_buffering=0 -r "echo file_get_contents('http://go-pear.org/');" > go-pear.php
%PHP_BIN% -n -d output_buffering=0 go-pear.php
pause
