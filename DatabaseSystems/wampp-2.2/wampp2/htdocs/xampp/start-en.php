<html>
<head>
<meta name="author" content="Kay Vogelgesang">
<link href="xampp.css" rel="stylesheet" type="text/css">
</head>

<body>

<table width=500 cellpadding=0 cellspacing=0 border=0>
<tr><td><br>
<h1>Here is WAMPP!</h1>
<h1>Congratulations:<br>
It is working!</h1>


<dl>
<dt><h2>Version information:</h2>
<dd>

<p>Your System:<br>
<?
$user = getenv("HTTP_USER_AGENT");
echo "<i>$user</i><br>";
?>
<p>The HTTP-Server:<br>
<?
$httpd = getenv("SERVER_SOFTWARE");
echo "<i>$httpd</i><br>";

?>
<p>Perl is responding:<br><i>
<?
$command="\wampp2\perl\bin\perl.exe -v";
passthru($command, $array);
echo "$array<br>";
?></i>
<p>And MySQL announces:<br><i>
<?
$command="\wampp2\mysql\bin\mysqld -v";
passthru($command, $array);
echo "$array";
?></i>
<p>And PHP? As the information is too much to display here,<br>
 =><a href=phpinfo.php>use PHPINFO</a>
<p>If you still have issues, please study the<br> => <a href=wampp_man.txt>WAMPP-reference</a>


<p>What's new?. PHPMyAdmin is a comfortable PHP-Frontend for MySQL. Furthermore Analog is a logfile analysing tool to create WWW statisics yourself. And BLAT is mailer, a pure sender, as a substitute for sendmail.
Sendmail is Free and OpenSource only for Linux, hence I use BLAT.
<p>
HAVE FUN<br>
<a href="mailto:kvo@onlinetech.de">Kay 'Birdsinging' Vogelgesang</a>&nbsp;&nbsp;&nbsp;<IMG SRC="img/WAMPP1.gif" WIDTH="108" HEIGHT="48" BORDER="0" ALT="Thanx, Dhananjay Rokde">
<br><br>
</td>
</tr>
</table>

</body>
</html>