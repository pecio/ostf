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

server.key:
	openssl genrsa -out server.key 4096

server.csr: server.key
	openssl req -new -key server.key -out server.csr -subj '/CN=wordpress.local' -addext 'subjectAltName=DNS:blog.local,DNS:wordpress.local'

server.pem: server.csr ca.pem ca.key ca.db ca.srl
	openssl ca -config ca.conf -batch -notext -in server.csr -out server.pem

server.pfx: server.pem server.key ca.pem
	openssl pkcs12 -export -nodes -passout pass:'' -out server.pfx -inkey server.key -in server.pem -certfile ca.pem

.PHONY: all clean

clean:
	rm -f *.crt *.csr *.key *.pem *.srl *.old *.db*
