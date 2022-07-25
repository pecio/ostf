all: server.pem server.key ca-int.pem

ca.key:
	openssl genrsa -out ca.key 4096

ca.crt: ca.key
	openssl req -new -x509 -days 3650 -key ca.key -out ca.crt -subj '/CN=Root CA' -extensions v3_ca

ca.pem: ca.crt
	openssl x509 -in ca.crt -out ca.pem

ca-int.key:
	openssl genrsa -out ca-int.key 4096

ca-int.csr: ca-int.key
	openssl req -new -key ca-int.key -out ca-int.csr -subj '/CN=Intermediate CA' -extensions v3_ca

ca.db:
	touch ca.db

ca.srl:
	openssl rand -hex 20 > ca.srl

ca-int.pem: ca-int.csr ca.pem ca.key ca.db ca.srl
	openssl ca -config ca.conf -batch -in ca-int.csr -out ca-int.pem

server.key: ca-int.csr
	openssl genrsa -out server.key 4096

server.csr: server.key
	openssl req -new -key server.key -out server.csr -subj '/CN=wordpress.local'

ca-int.db:
	touch ca-int.db

ca-int.srl:
	openssl rand -hex 20 > ca-int.srl

server.pem: server.csr ca-int.pem ca-int.key ca-int.db ca-int.srl
	openssl ca -config ca.conf -name intermediate_ca -batch -in server.csr -out server.pem

.PHONY: all clean

clean:
	rm -f *.crt *.csr *.key *.pem *.srl *.old *.db*
