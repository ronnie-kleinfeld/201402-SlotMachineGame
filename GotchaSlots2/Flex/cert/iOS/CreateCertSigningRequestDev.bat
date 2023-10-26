echo input
set ID=gotchaslots
set EMAIL=mail@gotchaslots.com
set CN=GotchaSlots
set Type=Dev

echo http://help.adobe.com/en_US/as3/iphone/WS144092a96ffef7cc-371badff126abc17b1f-8000.html

echo set path to config file
set OPENSSL_CONF=C:\OpenSSL-Win64\bin\openssl.cfg 

echo create key file
C:\OpenSSL-Win64\bin\openssl genrsa -out %ID%%Type%.key 2048

echo create certSigningRequest file
C:\OpenSSL-Win64\bin\openssl req -new -key %ID%%Type%.key -out %ID%%Type%.certSigningRequest  -subj "/emailAddress=%EMAIL%, CN=%CN%, C=US"

pause