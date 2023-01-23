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
<h1>If you can see the counter number, PHP4 is working!</h1><p>
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
$zahl = $zahl + 1;
echo "<b>You are the guest number $zahl.";

$fp = fopen($fn, "w");
flock($fp,2);
fputs($fp,$zahl);
flock($fp,3);
fclose($fp);
?>
</td></tr>
<tr><td align=center>&nbsp;<p><a href="counter-en.php">Increase the counter ...</font></a><br>
<a href="minuscounter-en.php">Decrease the counter ...</font></a>
</td></tr>
</table>
<p>&nbsp;<p>
<form method="POST" action="excel.php">
<table width=500 cellpadding=0 cellspacing=0 border=0>
<tr>
  <td colspan="2" width="500" align=center>
<h1>Create an Excel-table with PHP PEAR<br>"on the fly"</h1><p>
<br><p align=center>&nbsp;

  </td>
</tr>
<tr>
  <td align=center width="150">Optional value</td><td align=left width="350">

     <input type="text" name="value" size="40">

    </td>
</tr>
<tr>
    <td align=center width="150">&nbsp;</td><td align=center width="350">&nbsp;</td>
  </tr>
  <tr>
    <td align=center width="150">&nbsp;</td><td align=left width="350"><input type=submit value="Create"> * <input type=reset value="Reset"></form></td>
  </tr>
  </table>

</body>
</HTML>