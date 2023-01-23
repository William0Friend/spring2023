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
                echo "<h1>Success! A MySQL daemon is serving on your host.</h1>";
                echo "It could be an <i>older</i> installation, though ...<br>";
                echo "<a href=mysql-en.php>Refresh to check the MySQL status</a>";
        }
        else
        {
                echo "<h1>MySQL does not work.</h1>";
                echo "<h2>Perhaps you forgot to start MySQL?</h2><p>";
                echo "Please click \wamppxxx\mysql_start.bat to start MySQL<p>";
                echo "Check if the 'my' file (my.cnf) exists at c:\my, if not copy it there.<p>";
                echo "<a href=mysql-en.php>Refresh to check the MySQL status</a>";
        }
?>

</td></tr></table>

</body>
</html>