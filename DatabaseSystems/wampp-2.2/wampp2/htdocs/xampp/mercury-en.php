<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<HTML>
<HEAD>
<meta name="author" content="Kay Vogelgesang">
<link href="xampp.css" rel="stylesheet" type="text/css">
</HEAD>

<body>
&nbsp;<p>
<table width=500 cellpadding=0 cellspacing=0 border=0>
<tr><td>
<h1>Mercury sending your E-Mail ...</h1><p>
</td></tr>
<tr><td>&nbsp;<p>
<?
$mailtos = "$recipients";
$subject = "$subject";
$message = "$message";


$header.="From: $knownsender\r\n";
$header.=" Cc: $ccaddress";
// $header.="Bcc: $bcaddress";

mail($mailtos, $subject, $message, $header);

echo "<p><center><b>Done!</b>";
?>
</td></tr>
<tr><td>&nbsp;<p>
<a href="javascript:history.back()">Back to Mercury Main</a>
</td></tr>
</table>
</BODY>
</HTML>