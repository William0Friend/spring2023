<html>
<head>
<meta name="author" content="Kay Vogelgesang">
<link href="xampp.css" rel="stylesheet" type="text/css">
</head>

<body>
&nbsp;<p>
<table width=500 cellpadding=0 cellspacing=0 border=0>
<tr><td align=center>
<h1>JpGraph - Diagrams with PHP</h1>
The listing of all example diagrams is here: <a href="http://127.0.0.1/jpgraph/examples/" target="_top">http://127.0.0.1/jpgraph/examples/</a>.<br> <br>The Homepage of JpGraph: <a href="http://www.aditus.nu/jpgraph/" target="_top">http://www.aditus.nu/jpgraph/</a><p>   
<h2>First &#34;example pie&#34; with JpGraph</h2>
<?

echo "<FORM METHOD=POST ACTION=\"$php_self\">
Value 1: <INPUT TYPE=\"text\" NAME=\"a1\" size=\"2\" value=\"$a1\">&nbsp;&nbsp;Value 2: <INPUT TYPE=\"text\" NAME=\"a2\" size=\"2\" value=\"$a2\">
Value 3: <INPUT TYPE=\"text\" NAME=\"a3\" size=\"2\" value=\"$a3\">&nbsp;&nbsp;Value 4: <INPUT TYPE=\"text\" NAME=\"a4\" size=\"2\" value=\"$a4\">

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