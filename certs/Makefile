all: server.pem server.key ca-int.pem

ca.key:
	openssl genrsa -out ca.key 4096

ca.crt: ca.key
	openssl req -new -x509 -days 3650 -key ca.key -out ca.crt -subj '/CN=Root CA' -extensions v3_ca

ca.pem: ca.crt
	openssl x509 -in ca.crt -out ca.pem

ca-int.key:
	openssl genrsa -out ca-int.key 4096

ca-int.csr: ca-int.key ca.crt
	openssl req -new -key ca-int.key -out ca-int.csr -subj '/CN=Intermediate CA' -extensions v3_ca

ca-int.pem: ca-int.csr ca.crt ca.key
	openssl x509 -req -days 3650 -in ca-int.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out ca-int.pem

server.key: ca-int.csr
	openssl genrsa -out server.key 4096

server.csr: server.key
	openssl req -new -key server.key -out server.csr -subj '/CN=wordpress.local'

server.pem: server.csr ca-int.pem ca-int.key
	openssl x509 -req -days 3650 -in server.csr  -CA ca-int.pem -CAkey ca-int.key -CAcreateserial -out server.pem

.PHONY: all clean

clean:
	rm -f *.crt *.csr *.key *.pem *.srl
