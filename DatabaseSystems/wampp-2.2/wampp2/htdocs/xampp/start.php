<html>
<head>
<meta name="author" content="Kay Vogelgesang">
<link href="xampp.css" rel="stylesheet" type="text/css">
</head>

<body>

<table width=500 cellpadding=0 cellspacing=0 border=0>

<tr><td><br>
<h1>Das ist ein WAMPP!</h1>
<h1>Herzlichen Gl&uuml;ckwunsch:<br>
Es hat geklappt!</h1>


<dl>
<dt><h2>Doch, was habe ich hier im Einsatz?</h2>
<dd>

<p>Zuerst dein System:<br>
<?
$user = getenv("HTTP_USER_AGENT");
echo "<i>$user</i><br>";
?>
<p>Der Webserver:<br>
<?
$httpd = getenv("SERVER_SOFTWARE");
echo "<i>$httpd</i><br>";

?>
<p>Perl kann auch sprechen:<br><i>
<?
$command="\wampp2\perl\bin\perl.exe -v";
passthru($command, $array);
echo "$array<br>";
?></i>
<p>Und MySQL kommt wie folgt daher:<br><i>
<?
$command="\wampp2\mysql\bin\mysqld -v";
passthru($command, $array);
echo "$array";
?></i>
<p>Und PHP? Die Informationen hierzu sind etwas umfangreicher,<br>
 =><a href=phpinfo.php>deshalb PHPINFO</a>
<p>Wenn alles nicht hilft, dann schauhe bitte noch einmal in die<br> => <a href=wampp_man.txt>WAMPP-Anleitung</a>


<p>Was ist noch neu. PHPMyAdmin kennt ihr vielleicht, ein komfortabeles PHP-Programm das als Frontend für MySQL dient. Analog ist ein Logfile-Analyseprogramm, mit dem eigene WWW-Statistiken erstellen werden. Und BLAT ist ein Mailer, ein reiner Versender, der hier anstatt von sendmail zum Einsatz kommt.
Sendmail gibt es Free und OpenSource nur unter Linux, daher hier nun BLAT.
<p>
Damit viel Spaß<br>
<a href="mailto:kvo@onlinetech.de">Kay 'Birdsinging' Vogelgesang</a>&nbsp;&nbsp;&nbsp;<IMG SRC="img/WAMPP1.gif" WIDTH="108" HEIGHT="48" BORDER="0" ALT="Thanx, Dhananjay Rokde">
<br><br>
</td>
</tr>

</table>
</body>
</html>