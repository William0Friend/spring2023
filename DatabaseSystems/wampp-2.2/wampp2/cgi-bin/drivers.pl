#!\wampp2\perl\bin\perl.exe
##
##  printenv -- demo CGI program which just prints its environment
##

use DBI;
print "Content-type: text/html\n\n";
@drivers = DBI ->available_drivers;
print "<b>Available drivers are:</b><p>";
foreach (@drivers) {
print "$_<br>";
}
