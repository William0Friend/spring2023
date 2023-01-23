ECHO OFF
echo.
echo Diese Eingabeforderung nicht waehrend des Running beenden
echo.
echo Please dont close Window while MySQL is running
echo.
echo MySQL is trying to start
echo Please wait  ...
echo MySQL is starting with \wampp2\mysql\bin\my.cnf (console)
ECHO ON
mysql\bin\mysqld --defaults-file=\wampp2\mysql\bin\my.cnf --standalone
