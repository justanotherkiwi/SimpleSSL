#!/bin/bash

# Jayson's SimpleSSL Tool
# Version: 1.0
# Author: Jayson Barnden
# Contact: JaysonBarnden@outlook.com
# Description: This script provides various SSL certificate management options, please contact me if there are severe issues.

   echo ""
# Function to display the main menu
show_menu() {
    # Display the main menu options with descriptions
    echo -e "\e[1;2m╔═════════════════════════════════════════════╗\e[0m"
    echo -e "\e[1;2m║\e[0m                                             \e[1;2m║\e[0m"
    echo -e "\e[1;2m║\e[0m   Jayson's SimpleSSL Tool for debian@WSL    \e[1;2m║\e[0m"
    echo -e "\e[1;2m║\e[0m   version 1.0                               \e[1;2m║\e[0m"
    echo -e "\e[1;2m║\e[0m                                             \e[1;2m║\e[0m"
    echo -e "\e[1;2m╚═════════════════════════════════════════════╝\e[0m"

 echo -e "\e[1;2m╔════════════════════════════════════════════════════════════════════════════════════════════╗\e[0m"
echo -e "\e[1;2m║\e[0m                                                                                            \e[1;2m║\e[0m"
echo -e "\e[1;2m║\e[0m    1.) Convert PEM certificate to P7B                                                      \e[1;2m║\e[0m"
echo -e "\e[1;2m║\e[0m    2.) Convert PFX certificate to P7B                                                      \e[1;2m║\e[0m"
echo -e "\e[1;2m║\e[0m    3.) Convert PEM Certificate and Private Key to PFX Format with Intermediate Bundle      \e[1;2m║\e[0m"
echo -e "\e[1;2m║\e[0m    4.) Convert PEM Certificate and Private Key to PFX Format without Intermediate Bundle   \e[1;2m║\e[0m"
echo -e "\e[1;2m║\e[0m    5.) Decrypt and Extract Unencrypted Private Key from Encrypted RSA Private Key          \e[1;2m║\e[0m"
echo -e "\e[1;2m║\e[0m    6.) Extracting PEM Certificate, CSR, and Private Key from a PFX File                    \e[1;2m║\e[0m"
echo -e "\e[1;2m║\e[0m    7.) Self-Signed Certificate Signing with Internal CA (CA PFX & Self-signed PEM)         \e[1;2m║\e[0m"
echo -e "\e[1;2m║\e[0m    8.) Self-Signed Certificate Signing with Internal CA (CA PFX & Self-signed PFX)         \e[1;2m║\e[0m"
echo -e "\e[1;2m║\e[0m                                                                                            \e[1;2m║\e[0m"
echo -e "\e[1;2m║\e[0m    0.) Exit                                                                                \e[1;2m║\e[0m"
echo -e "\e[1;2m║\e[0m                                                                                            \e[1;2m║\e[0m"
echo -e "\e[1;2m╚════════════════════════════════════════════════════════════════════════════════════════════╝\e[0m"


}

# Function to perform the selected action
perform_action() {
    case $1 in
        1)
# Action 1: Convert PEM certificate to P7B
# This function converts a PEM certificate to P7B format.

# Change the current working directory to the specified path
cd /mnt/c/temp/ssl

# Get the current date in the format "ddmmyyyy"
current_date=$(date +"%d%m%Y")

# Prompt the user to place the PEM certificate they want to convert into P7B at a specific location
echo "Place the PEM certificate you want to convert into P7B: > C:\temp\ssl\certificate.pem"
echo "Note: file path including files must be lower-case."
echo ""

# Prompt the user to enter a client code
echo -n "Enter Client Code: "
read client_name

# Prompt the user to enter a friendly name for the certificate (e.g., yourdomain.com_2023-2024)
echo -n "Enter the friendly name (e.g: yourdomain.com_2023-2024): "
read friendly_name

# Define the output file name using the client code, current date, and friendly name
output_file="${client_name}_${current_date}_${friendly_name}.p7b"

# Use OpenSSL to convert the PEM certificate to P7B format and save it to the specified output file
openssl crl2pkcs7 -nocrl -certfile certificate.pem -out "$output_file"

# Display a message indicating that the P7B file has been exported to a specific location
echo ""
echo "Your P7B file has been exported to: C:\temp\ssl\ > $output_file"

# Clean-up process
echo ""
echo "File clean up process taking place:"
echo ""
delete-files

# Prompt the user to press Enter to return to the main menu
echo "Press [Enter] to return to the main menu."
read
            ;;
        2)
# Action 2: Convert PFX certificate to P7B
# This function converts a PFX certificate to P7B format and performs cleanup.

# Change the current working directory to the specified path
cd /mnt/c/temp/ssl

# Get the current date in the format "ddmmyyyy"
current_date=$(date +"%d%m%Y")

# Prompt the user to place the PFX certificate they want to convert into P7B at a specific location
echo "Place the PFX certificate you want to convert into P7B: > C:\temp\ssl\certificate.pem"
echo "Note: file path including files must be lower-case."
echo ""

# Prompt the user to enter a client code
echo -n "Enter Client Code: "
read client_name

# Prompt the user to enter a friendly name for the certificate (e.g., yourdomain.com_2023-2024)
echo -n "Enter the friendly name (e.g: yourdomain.com_2023-2024): "
read friendly_name

# Define the output file name using the client code, current date, and friendly name
output_file="${client_name}_${current_date}_${friendly_name}.p7b"

# Use OpenSSL to convert the PFX certificate to P7B format and save it to the specified output file
openssl pkcs12 -in certificate.pfx -clcerts -nokeys -out "$output_file"

# Display a message indicating that the P7B file has been exported to a specific location
echo ""
echo "Your P7B file has been exported to: C:\temp\ssl\ > $output_file"

# Clean-up process
echo ""
echo "File clean up process taking place:"
echo ""
delete-files

# Prompt the user to press Enter to return to the main menu
echo "Press [Enter] to return to the main menu."
read
            ;;
        3)
# Action 3: Convert PEM Certificate and Private Key to PFX Format with Intermediate Bundle
# This function converts a PEM certificate and private key to PFX format with an intermediate bundle.

# Change the current working directory to the specified path
cd /mnt/c/temp/ssl

# Prompt the user to place the PEM certificate, private key, and intermediate bundles into specific locations
echo "Place the PEM certificate, private key, and intermediate bundles into the following location:"
echo ""
echo "C:\temp\ssl\bundle.pem"
echo "C:\temp\ssl\certificate.pem"
echo "C:\temp\ssl\privatekey.pem"
echo ""
echo "Note that all of these files will need to be lower-case."
echo "Press [Enter] to continue or [CTRL + C] to Cancel..."
echo ""

# Wait for the user to press Enter to continue or cancel with [CTRL + C]
read

# Prompt the user to enter a client code
echo -n "Enter Client Code: "
read client_name

# Prompt the user to enter a friendly name for the certificate (e.g., yourdomain.com_2023-2024)
echo -n "Enter the friendly name (e.g: yourdomain.com_2023-2024): "
read friendly_name

# Get the current date in the format "ddmmyyyy"
current_date=$(date +"%d%m%Y")

# Define the output file name using the client code, current date, and friendly name
output_file="${client_name}_${current_date}_${friendly_name}.pfx"

# Display a message indicating the start of the export process
echo "Exporting PKCS12 Certificate with private key."

# Use OpenSSL to convert the PEM certificate and private key to PFX format with the intermediate bundle
openssl pkcs12 -inkey privatekey.pem -in certificate.pem -certfile bundle.pem -export -out "$output_file" -name "$friendly_name"

# Display a message indicating that the PFX certificate has been exported to a specific location
echo ""
echo "Your PFX certificate has been exported to C:\temp\ssl\ $output_file"

# Clean-up process
echo ""
echo "File clean up process taking place:"
echo ""
delete-files

# Prompt the user to press Enter to return to the main menu
echo "Press [Enter] to return to the main menu."
read
            ;;
        4)
# Action 4: Convert PEM Certificate and Private Key to PFX Format without Intermediate Bundle
# This function converts a PEM certificate and private key to PFX format without an intermediate bundle.

# Prompt the user to place the PEM certificate and private key into specific locations
echo "Place the PEM certificate and private key into the following location:"
echo ""
echo "C:\temp\ssl\certificate.pem"
echo "C:\temp\ssl\privatekey.pem"
echo ""
echo "Note that all of these files will need to be lower-case."
echo "Press [Enter] to continue or [CTRL + C] to Cancel..."
echo ""
read

# Prompt the user to enter a client code
echo -n "Enter Client Code: "
read client_name

# Prompt the user to enter a friendly name for the certificate (e.g., yourdomain.com_2023-2024)
echo -n "Enter the friendly name (e.g: yourdomain.com_2023-2024): "
read friendly_name

# Get the current date in the format "ddmmyyyy"
current_date=$(date +"%d%m%Y")

# Define the output file name using the client code, current date, and friendly name
output_file="${client_name}_${current_date}_${friendly_name}.pfx"

# Display a message indicating the start of the export process
echo "Exporting PKCS12 Certificate with private key."

# Use OpenSSL to convert the PEM certificate and private key to PFX format without an intermediate bundle
openssl pkcs12 -inkey privatekey.pem -in certificate.pem -export -out "$output_file" -name "$friendly_name"

# Display a message indicating that the PFX certificate has been exported to a specific location
echo ""
echo "Your PFX certificate has been exported to C:\temp\ssl\ $output_file"

# Clean-up process
echo ""
echo "File clean up process taking place:"
echo ""
delete-files

# Prompt the user to press Enter to return to the main menu
echo "Press [Enter] to return to the main menu."
read
            ;;
        5)
# Action 5: Decrypt and Extract Unencrypted Private Key from Encrypted RSA Private Key
# This function decrypts an encrypted RSA private key and extracts the unencrypted private key.

# Get the current date in the format "ddmmyyyy"
current_date=$(date +'%d%m%Y')

# Display instructions to the user
echo ""
echo "Place your encrypted private key into the following folder: > C:\temp\ssl\encrypted-privatekey.pem"
echo ""
echo "Note: Ensure the file path is correct and lowercase."
echo ""
echo "Press [Enter] to continue."
read

# Prompt the user to enter a client code
echo ""
echo -n "Enter Client Code: "
read client_code

# Prompt the user to enter a friendly name for the output file (e.g., yourdomain.com_2023-2024)
echo -n "Enter the friendly name (e.g: yourdomain.com_2023-2024): "
read friendly_name

# Use OpenSSL to decrypt the encrypted private key and save the unencrypted private key with a specific filename
openssl rsa -in encrypted-privatekey.pem -out "${client_code}_$current_date_unencrypted_privatekey_$friendly_name.pem"

# Display a message indicating that private key decryption is completed and the file has been exported
echo ""
echo "Private key decryption is now completed, file exported to > C:\temp\ssl\ ${client_code}_$current_date_unencrypted_privatekey_$friendly_name.pem"

# Clean-up process
echo ""
echo "File clean up process taking place:"
echo ""
delete-files

# Prompt the user to press Enter to return to the main menu
echo "Press [Enter] to return to the main menu."
read
            ;;
        6)
# Action 6: Extracting PEM Certificate, CSR, and Private Key from a PFX File
# This function extracts a PEM certificate, CSR, and private key from a PFX file.

# Change the current directory to the specified path
cd /mnt/c/temp/ssl

# Display instructions to the user
echo "Place the PFX file you want to extract the CSR, PEM certificate, and private key from and name it:"
echo "C:\temp\ssl\certificate.pfx (note this needs to be lower-case)."
echo ""
echo "Press [Enter] to continue or [CTRL + C] to Cancel..."
read

# Prompt the user to enter a client code (friendly name)
echo -n "Enter Client Code: "
read friendly_name

# Get the current date in the format "dd-mm-yyyy"
current_date=$(date +'%d-%m-%Y')

# Extract the PEM certificate from the PFX file and save it with a specific filename
echo "Exporting PEM certificate from > C:\temp\ssl\certificate.pfx"
openssl pkcs12 -in certificate.pfx -clcerts -nokeys -out "${friendly_name}_certificate.pem"

# Extract the private key from the PFX file and save it with a specific filename
echo ""
echo "Exporting Private Key from > C:\temp\ssl\certificate.pfx"
openssl pkcs12 -in certificate.pfx -out "${friendly_name}_privatekey.pem" -nodes -nocerts

# Generate a CSR (Certificate Signing Request) from the PEM certificate and private key and save it with a specific filename
echo ""
echo "Exporting CSR from > C:\temp\ssl\certificate.pfx"
openssl x509 -x509toreq -in "${friendly_name}_certificate.pem" -signkey "${friendly_name}_privatekey.pem" -out "${friendly_name}_csr.pem"

# Display a message indicating that the CSR, PEM certificate, and private key have been exported
echo ""
echo "The CSR, PEM certificate, and private key have been exported to:"
echo ""
echo "C:\temp\ssl\ ${friendly_name}_certificate.pem"
echo "C:\temp\ssl\ ${friendly_name}_csr.pem"
echo "C:\temp\ssl\ ${friendly_name}_privatekey.pem"
echo ""

# Display instructions to return to the main menu or quit
echo "Press [Enter] to return to the main menu or [CTRL+C] to quit."
read
            ;;
        7)
# Action 7: Self-Signed Certificate Signing with Internal CA (CA PFX & Self-signed PEM)
# This function is responsible for creating a self-signed certificate using an internal CA.

# Change the current directory to the specified path
cd /mnt/c/temp/ssl

# Check if the openssl.cnf file exists; if not, create it with user input
if [ ! -f openssl.cnf ]; then
    # If the openssl.cnf file doesn't exist, prompt the user to provide configuration details
    echo ""
    echo "Unable to locate existing OpenSSL Config File."
    echo "Please provide required information when prompted:"
    echo ""
    # Prompt for various certificate details
    echo -n "Country (e.g: AU): "
    read countryName
    echo -n "State (e.g: NSW): "
    read stateOrProvinceName
    echo -n "City (e.g: Sydney): "
    read localityName
    echo -n "Org Name (e.g: YourCompany Limited): "
    read organizationName
    echo -n "Org Unit (e.g: IT Services): "
    read organizationalUnitName
    echo -n "Common Name (e.g: yourdomain.com): "
    read commonName
    # Create the openssl.cnf file with the provided details
    cat <<EOF > openssl.cnf
[req]
default_bits       = 2048
distinguished_name = req_distinguished_name
req_extensions     = req_ext
x509_extensions    = v3_ca

[req_distinguished_name]
countryName            = $countryName
stateOrProvinceName    = $stateOrProvinceName
localityName           = $localityName
organizationName       = $organizationName
organizationalUnitName = $organizationalUnitName
commonName             = $commonName

[req_ext]
subjectKeyIdentifier   = hash
keyUsage               = digitalSignature, keyEncipherment
extendedKeyUsage       = serverAuth
basicConstraints       = CA:false

[v3_ca]
subjectKeyIdentifier   = hash
authorityKeyIdentifier = keyid:always,issuer:always
basicConstraints       = CA:true
EOF
fi

# Inform the user that the OpenSSL configuration file is confirmed
echo ""
echo "OpenSSL Configuration file confirmed."
echo ""

# Function to input the certificate password
function input_password {
    echo -n "Enter a password for the certificate: "
    read -s password
    echo
}

# Call the input_password function to get the certificate password
input_password

# Function to input the friendly name for the certificate
function input_friendly_name {
    echo -n "Enter a friendly name for the certificate: "
    read friendly_name
}

# Call the input_friendly_name function to get the friendly name
input_friendly_name

# Extract the certificate, private key, and CSR from the CA PFX file
openssl pkcs12 -in ca-certificate.pfx -clcerts -nokeys -out ca-certificate.pem -passin "pass:$password"
openssl pkcs12 -in ca-certificate.pfx -out ca-privatekey.pem -nodes -nocerts -passin "pass:$password"
openssl x509 -x509toreq -in ca-certificate.pem -signkey ca-privatekey.pem -out ca-csr.pem -passin "pass:$password"

# Sign the CSR with the CA's private key to create a CA-signed certificate
openssl x509 -req -in ca-csr.pem -CA ca-certificate.pem -CAkey ca-privatekey.pem -CAcreateserial -out ca-signed-certificate.pem -days 365 -extfile openssl.cnf -extensions v3_ca -passin "pass:$password"

# Export the CA-signed certificate as a PFX file with the provided friendly name
echo ""
if [ -n "$friendly_name" ]; then
    openssl pkcs12 -inkey ca-privatekey.pem -in ca-signed-certificate.pem -export -out "ca-signed-certificate-$friendly_name.pfx" -passout pass:"$password" -passout "pass:$password" -name "$friendly_name"
    echo "CA-signed certificate has been exported with friendly name: $friendly_name"
else
    echo "CA-signed certificate has been exported without a friendly name."
fi

# Clean-up process
echo ""
echo "File clean up process taking place:"
echo ""
delete-files

# Prompt the user to press Enter to return to the main menu
echo "Press [Enter] to return to the main menu."
read
            ;;
        8)
# Action 8: Self-Signed Certificate Signing with Internal CA (CA PFX & Self-signed PFX)
# This function is responsible for creating a self-signed certificate using an internal CA.

# Change the current directory to the specified path
cd /mnt/c/temp/ssl

# Check if the openssl.cnf file exists; if not, create it with user input
if [ ! -f openssl.cnf ]; then
    # If the openssl.cnf file doesn't exist, prompt the user to provide configuration details
    echo ""
    echo "Unable to locate existing OpenSSL Config File."
    echo "Please provide required information when prompted:"
    echo ""
    # Prompt for various certificate details
    echo -n "Country [e.g: AU]: "
    read countryName
    echo -n "State [e.g: NSW]: "
    read stateOrProvinceName
    echo -n "City [e.g: Sydney]: "
    read localityName
    echo -n "Org Name [e.g: YourCompany Limited]: "
    read organizationName
    echo -n "Org Unit [e.g: IT]: "
    read organizationalUnitName
    echo -n "Common Name [e.g: yourdomain.com]: "
    read commonName
    # Create the openssl.cnf file with the provided details
    cat <<EOF > openssl.cnf
[req]
default_bits       = 2048
distinguished_name = req_distinguished_name
req_extensions     = req_ext
x509_extensions    = v3_ca

[req_distinguished_name]
countryName            = $countryName
stateOrProvinceName    = $stateOrProvinceName
localityName           = $localityName
organizationName       = $organizationName
organizationalUnitName = $organizationalUnitName
commonName             = $commonName

[req_ext]
subjectKeyIdentifier   = hash
keyUsage               = digitalSignature, keyEncipherment
extendedKeyUsage       = serverAuth
basicConstraints       = CA:false

[v3_ca]
subjectKeyIdentifier   = hash
authorityKeyIdentifier = keyid:always,issuer:always
basicConstraints       = CA:true
EOF
fi

# Inform the user that the OpenSSL configuration file is confirmed
echo ""
echo "OpenSSL Configuration file confirmed."
echo ""

# Function to input the certificate password
function input_password {
    echo -n "Enter a password for the certificate: "
    read -s password
    echo
}

# Call the input_password function to get the certificate password
input_password

# Function to input the friendly name for the certificate
function input_friendly_name {
    echo -n "Enter a friendly name for the certificate: "
    read friendly_name
}

# Call the input_friendly_name function to get the friendly name
input_friendly_name
echo ""

# Extract the certificate, private key, and CSR from the CA PFX file
openssl pkcs12 -in ca-certificate.pfx -clcerts -nokeys -out ca-certificate.pem -passin "pass:$password"
openssl pkcs12 -in ca-certificate.pfx -out ca-privatekey.pem -nodes -nocerts -passin "pass:$password"
openssl x509 -x509toreq -in ca-certificate.pem -signkey ca-privatekey.pem -out ca-csr.pem -passin "pass:$password"

# Extract the certificate and private key from the self-signed PFX file
openssl pkcs12 -in selfsigned-certificate.pfx -clcerts -nokeys -out selfsigned-certificate.pem -passin "pass:$password"
openssl pkcs12 -in selfsigned-certificate.pfx -out selfsigned-privatekey.pem -nodes -nocerts -passin "pass:$password"
openssl x509 -x509toreq -in selfsigned-certificate.pem -signkey selfsigned-privatekey.pem -out selfsigned-csr.pem -passin "pass:$password"

# Sign the self-signed CSR with the CA's private key to create a CA-signed certificate
openssl x509 -req -in selfsigned-csr.pem -CA ca-certificate.pem -CAkey ca-privatekey.pem -CAcreateserial -out ca-signed-certificate.pem -days 365 -extfile openssl.cnf -extensions v3_ca -passin "pass:$password"
echo ""

if [ -n "$friendly_name" ]; then
    # Export the CA-signed certificate as a PFX file with the provided friendly name
    openssl pkcs12 -inkey selfsigned-privatekey.pem -in ca-signed-certificate.pem -export -out "ca-signed-certificate-$friendly_name.pfx" -passout pass:"$password" -passout "pass:$password" -name "$friendly_name"
    echo "CA-signed certificate has been exported with friendly name: $friendly_name > C:\temp\ssl\ca-signed-certificate-$friendly_name.pfx"
else
    echo "CA-signed certificate has been exported without a friendly name > C:\temp\ssl\ca-signed-certificate-$friendly_name.pfx."
fi

# Clean-up process
echo ""
echo "File clean up process taking place:"
echo ""
delete-files

# Prompt the user to press Enter to return to the main menu
echo "Press [Enter] to return to the main menu."
read
            ;;
        en)
            # Hidden menu option to edit ssltools in Nano
            /usr/bin/nano /usr/bin/ssltools
            ;;
        ev)
            # Hidden menu option to edit ssltools in Vim
            /usr/bin/vim /usr/bin/ssltools
            ;;
        0)
            # Action 0: Exit the script
            echo ""
            echo "If you have any feature requests or feedback please contact JaysonBarnden@outlook.com Cheeeeeers."
            echo "Bye for now! :)"
            echo ""
            #echo "Press [Enter] to exit"
            #read
            exit 0
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
}

# Function to delete existing files for clean-up process.
delete-files() {
    # List of files to be deleted
    files=(
    "bundle.pem"
    "ca-certificate.pem"
    "ca-certificate.pfx"
    "ca-certificate.srl"
    "ca-csr.pem"
    "ca-privatekey.pem"
    "ca-signed-certificate.pem"
    "certificate.pem"
    "encrypted-privatekey.pem"
    "openssl.cnf"
    "privatekey.pem"
    "selfsigned-certificate.pem"
    "selfsigned-certificate.pfx"
    "selfsigned-csr.pem"
    "selfsigned-privatekey.pem"
    )

    # Loop through the list of files and delete them if they exist
    for file in "${files[@]}"; do
        if [ -f "$file" ]; then
            rm "$file"
            echo ""
            echo "Removing C:\temp\ssl\ >  $file"
#        else
#            echo "$file not found"
        fi
    done
}

# Main loop for displaying the menu and handling user input
while true; do
    clear
    show_menu
    echo -n "Select option: "
    read choice
    perform_action "$choice"
done
