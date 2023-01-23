#!\wampp2\perl\bin\perl.exe
print "Content-Type: text/html\n\n";

@monate=qw(Januar Februar März April Mai Juni Juli August September Oktober November Dezember);
@tage=qw(Sonntag Montag Dienstag Mittwoch Donnerstag Freitag Samstag);
($sek,$min,$stu,$tag,$mon,$jahr,$wtag)=localtime(time);
$wtag=@tage[$wtag];
$mon=@monate[$mon];
$jahr=$jahr+1900;
if($sek<10)
{$sek="0$sek";}
if($min<10)
{$min="0$min";}
$datum="$wtag, $tag. $mon $jahr um $stu:$min Uhr und $sek Sekunden.";


print '<html>';
print '<head>';
print '<meta name="author" content="Kay Vogelgesang">';
print '<link href="../xampp/xampp.css" rel="stylesheet" type="text/css">';
print '</head>';

print '<body>';
print '&nbsp;<p><table width=500 cellpadding=0 cellspacing=0 border=0><tr><td align=center>';

print "<h1>Perl mit mod_perl funktioniert!</h1><p>";
print "<h2>Perl mit mod_perl benutze die Endung *.pl<br>";
print "Perl als CGI benutze die Endung *.cgi</h2><p>";
print "Deine Systemzeit: $datum";
print "<p>&nbsp;<p>";
print "<a href=test.asp>PERL:ASP testen!</a><p>";
print "</td></tr></table></body>";
print "</html>";