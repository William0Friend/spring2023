#!\wampp2\perl\bin\perl.exe
print "Content-Type: text/html\n\n";

@monate=qw(january february march april may june july august september october november december);
@tage=qw(sunday monday tuesday wednesday thursday friday saturday);
($sek,$min,$stu,$tag,$mon,$jahr,$wtag)=localtime(time);
$wtag=@tage[$wtag];
$mon=@monate[$mon];
$jahr=$jahr+1900;
if($sek<10)
{$sek="0$sek";}
if($min<10)
{$min="0$min";}
$datum="$wtag, $tag. $mon $jahr, $stu:$min o'clock and $sek seconds.";


print '<html>';
print '<head>';
print '<meta name="author" content="Kay Vogelgesang">';
print '<link href="../xampp/xampp.css" rel="stylesheet" type="text/css">';
print '</head>';

print '<body>';
print '&nbsp;<p><table width=500 cellpadding=0 cellspacing=0 border=0><tr><td align=center>';

print "<h1>Perl with mod_perl works!</h1><p>";
print "<h2>To create documents for Perl with mod_perl use the file extension *.pl<br>";
print "To use Perl as CGI use the file extension *.cgi</h2><p>";
print "Your system time: $datum";
print "<p>&nbsp;<p>";
print "<a href=test.asp>PERL:ASP test here!</a><p>";
print "</td></tr></table></body>";
print "</html>";