<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<HTML>
<HEAD>
<TITLE> Counter in PHP  </TITLE>
<meta name="author" content="Kay Vogelgesang">
<link href="xampp.css" rel="stylesheet" type="text/css">
</HEAD>

<BODY>
&nbsp;<p>
<table width=500 cellpadding=0 cellspacing=0 border=0>
<tr><td align=center>
<h1>Wenn ihr eine Besucherzahl seht, funktioniert auch PHP4 mit Mod_PHP!</h1><p>
<?
$fn = "counter.txt";
if (file_exists($fn))
{
$fp = fopen($fn, "r");
$zahl= fgets($fp,10);
fclose($fp);
}
else

$zahl = 0;
$zahl = $zahl - 1;
echo "<b>Du bist der $zahl. Besucher";

$fp = fopen($fn, "w");
flock($fp,2);
fputs($fp,$zahl);
flock($fp,3);
fclose($fp);
?>
</td></tr>
<tr><td align=center>&nbsp;<p><a href="counter.php">Einen Besucher
      mehr ...</font></a><br>
<a href="minuscounter.php">Einen Besucher
      weniger ...</font></a>
</td></tr>
</table></body>
</HTML>