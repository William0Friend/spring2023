\wampp2\server\%1\security 
\wampp2\apache\bin\openssl.exe req -config \wampp2\apache\bin\openssl.cnf -new -x509 -days %2 -key %1.key -out %1.crt 
