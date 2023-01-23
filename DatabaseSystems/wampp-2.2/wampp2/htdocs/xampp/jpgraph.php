<html>
<head>
<meta name="author" content="Kay Vogelgesang">
<link href="xampp.css" rel="stylesheet" type="text/css">
</head>

<body>
&nbsp;<p>
<table width=500 cellpadding=0 cellspacing=0 border=0>
<tr><td align=center>
<h1>JpGraph - Diagramme mit PHP</h1>
Das Verzeichnis für alle Beispiel-Diagramme lautet im wampp: <a href="http://127.0.0.1/jpgraph/examples/" target="_top">http://127.0.0.1/jpgraph/examples/</a>.<br> <br>Die Homepage von JpGraph: <a href="http://www.aditus.nu/jpgraph/" target="_top">http://www.aditus.nu/jpgraph/</a><p>   
<h2>Ein erster "Beispiel-Kuchen" mit JpGraph</h2>
<?


echo "<FORM METHOD=POST ACTION=\"$php_self\">
Wert 1: <INPUT TYPE=\"text\" NAME=\"a1\" size=\"2\" value=\"$a1\">&nbsp;&nbsp;Wert 2: <INPUT TYPE=\"text\" NAME=\"a2\" size=\"2\" value=\"$a2\">
Wert 3: <INPUT TYPE=\"text\" NAME=\"a3\" size=\"2\" value=\"$a3\">&nbsp;&nbsp;Wert 4: <INPUT TYPE=\"text\" NAME=\"a4\" size=\"2\" value=\"$a4\">

<br><br>
<INPUT TYPE=\"submit\">
</FORM>


<script>

    document.write(\"<img src='http://127.0.0.1/jpgraph/examples/pie3dex3a.php?a1=$a1&a2=$a2&a3=$a3&a4=$a4' >\");
    </script>";

?>
</td></tr></table>

</body>
</html>