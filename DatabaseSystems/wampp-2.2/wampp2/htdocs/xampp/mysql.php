<html>
<head>
<meta name="author" content="Kay Vogelgesang">
<link href="xampp.css" rel="stylesheet" type="text/css">
</head>

<body>
&nbsp;<p>
<table width=500 cellpadding=0 cellspacing=0 border=0>
<tr><td align=center>

<?
        if(@mysql_connect("localhost"))
        {
                echo "<h1>Ein MySQL-Server ist auf deinem Rechner gestartet.</h1>";
                echo "Es kann aber auch einer deiner <i>alten</i> MySQL-Server sein ...<br><p>";
                echo "<a href=mysql.php>Neu Laden, um den MySQL-Status erneut zu überpr&uuml;fen</a>";
        }
        else
        {
                echo "<h1>MySQL funktioniert nicht.</h1>";
                echo "<h2>Vielleicht ist er nicht gestartet?</h2><p>";
                echo "Benutze \wamppxxx\mysql_start.bat um MySQL zu starten!<p>";
                echo "Vorher muß die my (bzw. my.cnf) als c:\my vorliegen!<p>";
                echo "<a href=mysql.php>Neu Laden, um den MySQL-Status erneut zu überpr&uuml;fen</a>";
        }
?>

</td></tr></table>

</body>
</html>