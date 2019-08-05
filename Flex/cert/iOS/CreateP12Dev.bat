echo input
set ID=gotchaslotsDev
set PEM=ios_development

echo http://help.adobe.com/en_US/as3/iphone/WS144092a96ffef7cc-371badff126abc17b1f-7fff.html

echo create pem file
C:\OpenSSL-Win64\bin\openssl x509 -in %PEM%.cer -inform DER -out %ID%_%PEM%.pem -outform PEM

echo create p12 file
C:\OpenSSL-Win64\bin\openssl pkcs12 -export -inkey %ID%.key -in %ID%_%PEM%.pem -out %ID%_%PEM%.p12

pause