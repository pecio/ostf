all: server.pfx

ca.key:
	openssl genrsa -out ca.key 4096

ca.crt: ca.key
	openssl req -new -x509 -days 3650 -key ca.key -out ca.crt -subj '/CN=Root CA' -extensions v3_ca

ca.pem: ca.crt
	openssl x509 -in ca.crt -out ca.pem

ca.db:
	touch ca.db

ca.srl:
	openssl rand -hex 20 > ca.srl

server.csr:
	openssl req -new -out server.csr -subj '/CN=wordpress.local' -addext 'subjectAltName=DNS:blog.local,DNS:wordpress.local' -newkey rsa:4096 -nodes -keyout server.key

server.key: server.csr

server.pem: server.csr ca.pem ca.key ca.db ca.srl
	openssl ca -config ca.conf -batch -notext -in server.csr -out server.pem

empty.txt:
	echo > empty.txt

server.pfx: server.pem server.key ca.pem empty.txt
	openssl pkcs12 -export -out server.pfx -inkey server.key -in server.pem -certfile ca.pem -name wordpress.local -passout file:empty.txt

.PHONY: all clean

clean:
	rm -f *.crt *.csr *.key *.pem *.srl *.old *.db* *.pfx empty.txt
