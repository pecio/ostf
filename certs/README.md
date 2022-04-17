# Certificates for SSL terminated Load Balancer (wplbs)
This directory is meant to hold the following files:

* `ca-int.pem`: Intermediate CA x509 Certificate
* `server.pem`: Server x509 Certificate
* `server.key`: Private key for the Server Certificate

These are needed by the Terraform code in `../wplbs`.

## Using your own certificates
Place the above mentioned files with the given names in this directory.
Keep in mind `server.key` must be not encrypted.

## Generating self signed certificates
Running `make` will generate a Root CA, generate and sign the
Intermediate CA and the Server Certificate.
