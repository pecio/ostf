all: server.pem server.key ca-int.pem

ca.key:
	echo "Root CA Key"
	echo "###########"
	openssl genrsa -out ca.key 4096

ca.crt: ca.key
	echo "Root CA Certificate"
	echo "###################"
	openssl req -new -x509 -days 3650 -key ca.key -out ca.crt -subj '/CN=Root CA'

ca.pem: ca.crt
	echo "Root CA x509 Certificate"
	echo "########################"
	openssl x509 -in ca.crt -out ca.pem

ca-int.key:
	echo "Intermediate CA Key"
	echo "###################"
	openssl genrsa -out ca-int.key 4096

ca-int.csr: ca-int.key ca.crt
	echo "Intermediate CA Certificate Request"
	echo "###################################"
	openssl req -new -key ca-int.key -out ca-int.csr -subj '/CN=Intermediate CA'

ca-int.pem: ca-int.csr ca.crt ca.key
	echo "Intermediate CA x509 Certificate"
	echo "################################"
	openssl x509 -req -days 3650 -in ca-int.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out ca-int.pem

server.key: ca-int.csr
	echo "Server key"
	echo "##########"
	openssl genrsa -out server.key 4096

server.csr: server.key
	echo "Server Certificate Request"
	echo "##########################"
	openssl req -new -key server.key -out server.csr -subj '/CN=wordpress.local'

server.pem: server.csr ca-int.pem ca-int.key
	echo "Server x509 Certificate"
	echo "#######################"
	openssl x509 -req -days 3650 -in server.csr  -CA ca-int.pem -CAkey ca-int.key -set_serial 01 -out server.pem

.PHONY: all clean

clean:
	rm -f *.crt *.csr *.key *.pem
