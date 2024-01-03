#!/bin/bash

# SimpleSSL Tool
# Version: 2.0-TESTING
# Author: Jayson Barnden
# Contact: https://github.com/justanotherkiwi
# Description: Based on version 1.0 of my original SSL BASH script, I wanted a newer take on my original script utilising whiptail to make it look prettier than my original text based script.

# Function to display help message
show_help() {
    echo ""
    echo "Main Menu:"
    echo "   Generate CSR & Private Key: Generates a Certificate Signing Request (CSR) & a private key."
    echo "   Convert PEM Certificate to P7B: Converts a PEM-formatted certificate to P7B format."
    echo "   Convert PFX Certificate to P7B: Converts a PFX-formatted certificate to P7B format."
    echo "   Convert PEM Certificate & Private Key to PFX Format with Intermediate Bundle: Creates a PFX certificate file from a PEM certificate, private key, & intermediate bundle."
    echo "   Convert PEM Certificate & Private Key to PFX Format without Intermediate Bundle: Creates a PFX certificate file from a PEM certificate & private key without an intermediate bundle."
    echo "   Decrypt & Extract Unencrypted Private Key from Encrypted RSA Private Key: Decrypts an encrypted RSA private key."
    echo "   Extracting PEM Certificate, CSR, & Private Key from a PFX File: Extracts the PEM certificate, CSR, & private key from a PFX file."
    echo "   Self-Signed Certificate Signing with Internal CA (CA PFX & Self-signed PEM): Signs a self-signed certificate with an internal CA using CA PFX & self-signed PEM files."
    echo "   Self-Signed Certificate Signing with Internal CA (CA PFX & Self-signed PFX): Signs a self-signed certificate with an internal CA using CA PFX & self-signed PFX files."
    echo ""
    echo "Logs:"
    echo "If you are experiencing issues please refer to the log file located $HOME/.config/ssltools/output.log."
    echo ""
    echo "Author:"
    echo "Created by Jayson Barnden"
    echo "https://github.com/justanotherkiwi"
    echo ""
    echo "Licensing:"
    echo  "GPLv3 - Open Source baby!"
    echo ""
}

# Function to display version information
show_version() {
    echo ""
    echo "SimpleSSL Tool v2.0"
    echo "Created by Jayson Barnden"
    echo "https://github.com/justanotherkiwi"
    echo ""
}

# Parsing command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h|--help) show_help; exit 0 ;;
        -v|--version) show_version; exit 0 ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Define log file path and ensure the log directory exists.
logs="$HOME/.config/ssltools/output.log"
mkdir -p "$(dirname "$logs")"

# Function to append a log entry with a timestamp.
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$logs"
}

# Function to determine and set the SSL directory.
get_SSL_DIR() {
    local config_file="$HOME/.config/ssltools/ssldir.conf"
    # Check for existing SSL directory configuration.
    if [ -f "$config_file" ]; then
        # Use the SSL directory from the configuration file.
        SSL_DIR=$(grep 'SSL_DIR' "$config_file" | cut -d '=' -f2)
        log "Using SSL directory from config: $SSL_DIR"
    else
        # Prompt the user to set a new SSL directory path.
        SSL_DIR=$(whiptail --inputbox "Enter universal SSL output save path:" 10 60 "/mnt/c/temp/ssl" --nocancel 3>&1 1>&2 2>&3)
        # Save the new SSL directory path in the configuration file.
        mkdir -p "$(dirname "$config_file")"
        echo "SSL_DIR=$SSL_DIR" > "$config_file"
        whiptail --msgbox "Config file saved in $config_file" 8 78 --title "Configuration Successfully Saved"
        log "Created new SSL directory config: $SSL_DIR"
    fi
}

# Function to retrieve user input with a prompt.
get_input() {
    local prompt="$1"
    local default_value="$2"
    result=$(whiptail --inputbox "$prompt" 10 60 "$default_value" --nocancel 3>&1 1>&2 2>&3)
    echo "$result"
}

# Function to display a message box.
show_message() {
    local message="$1"
    whiptail --msgbox "$message" 10 60
}

# Function to select a file from a specified directory.
select_file() {
    local title="$1"
    local directory="$2"
    # Validate the existence of the directory.
    if [ ! -d "$directory" ]; then
        show_message "Directory $directory not found."
        log "Directory not found: $directory"
        return 1
    fi
    # Change to the specified directory.
    cd "$directory" || return 1
    # Create a list of files in the directory.
    local files=()
    for file in *; do
        [ -f "$file" ] && files+=("$file" "")
    done
    # Display a file selection menu to the user.
    selected_file=$(whiptail --title "$title" --menu "Choose a file" 25 78 16 "${files[@]}" 3>&1 1>&2 2>&3)
    echo "$selected_file"
}

# Initialize the SSL directory.
get_SSL_DIR

# Start the main loop to present options to the user and execute selected tasks.
while true; do
    # Display a menu with various SSL management options.
    option=$(whiptail --title "SimpleSSL Tool" --menu "Choose an option" 25 100 10 \
        "F1" "Generate CSR and Private Key" \
        "F2" "Convert PEM certificate to P7B" \
        "F3" "Convert PFX certificate to P7B" \
        "F4" "Convert PEM Certificate and Private Key to PFX Format with Intermediate Bundle" \
        "F5" "Convert PEM Certificate and Private Key to PFX Format without Intermediate Bundle" \
        "F6" "Decrypt and Extract Unencrypted Private Key from Encrypted RSA Private Key" \
        "F7" "Extracting PEM Certificate, CSR, and Private Key from a PFX File" \
        "F8" "Self-Signed Certificate Signing with Internal CA (CA PFX & Self-signed PEM)" \
        "F9" "Self-Signed Certificate Signing with Internal CA (CA PFX & Self-signed PFX)" \
        "Exit" "" --nocancel 3>&1 1>&2 2>&3)

    # Handle the case where the user cancels the operation.
    if [ $? -ne 0 ]; then
        show_message "Operation cancelled by user."
        log "Operation cancelled by user."
        break
    fi

    # Process the selected option and execute the corresponding task.
    case $option in
        F1)
            # Change the current working directory to the SSL directory.
            cd $SSL_DIR || { echo "Directory not found."; exit 1; }

            # Prompt the user for the Job ID and store it in JOB_ID.
            JOB_ID=$(get_input "Enter Job ID (Unique identifier for the filename):")

            # Store the current date in the format ddmmyyyy in CURRENT_DATE.
            CURRENT_DATE=$(date +%d%m%Y)

            # Prompt the user for various certificate details and store them in respective variables.
            COUNTRY=$(get_input "Enter Country Code (example: AU):")
            STATE=$(get_input "Enter State or Province (example: NSW or New South Wales):")
            LOCALITY=$(get_input "Enter City (example: Sydney):")
            ORG=$(get_input "Enter Organization Name (example: Company Ltd):")
            OU=$(get_input "Enter Organizational Unit (example: IT):")
            CN=$(get_input "Enter Common Name (example: company.com):")
            EMAIL=$(get_input "Enter admin email address (example: admin@company.com):")

            # Construct file names for the private key and CSR using the Job ID, Common Name, and current date.
            PRIVATE_KEY="${JOB_ID}_${CN}_${CURRENT_DATE}_privatekey.pem"
            CSR="${JOB_ID}_${CN}_${CURRENT_DATE}_csr.pem"

            # Generate a private key using OpenSSL with RSA algorithm and a key size of 2048 bits.
            # The output is directed to the private key file and appended to the log file.
            openssl genpkey -algorithm RSA -out "$PRIVATE_KEY" -pkeyopt rsa_keygen_bits:2048 2>&1 | tee -a "$logs"

            # Generate a CSR using OpenSSL with the previously generated private key and the subject details provided by the user.
            # The output of this command is captured in a variable for logging.
            openssl_command_output=$(openssl req -new -key "$PRIVATE_KEY" -out "$CSR" \
                -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORG/OU=$OU/CN=$CN/emailAddress=$EMAIL" 2>&1)

            # Log the output of the CSR generation command.
            log "$openssl_command_output"

            # Construct a message indicating the paths to the generated private key and CSR.
            # Display this message to the user.
            message="Generated files:\nPrivate Key: $SSL_DIR/$PRIVATE_KEY\nCSR: $SSL_DIR/$CSR"
            show_message "$message"
            ;;
        F2)
            # Change the current working directory to the SSL directory.
            cd $SSL_DIR || { log "Directory not found: $SSL_DIR"; exit 1; }

            # Store the current date in the format "ddmmyyyy".
            current_date=$(date +"%d%m%Y")

            # Initialize an empty array to hold the list of files.
            file_list=()

            # Loop through all items in the current directory.
            for file in *; do
                # Check if the item is a file.
                if [ -f "$file" ]; then
                    # If it's a file, add it to the file list.
                    file_list+=("$file" "")
                fi
            done

            # Display a menu to the user to select a PEM certificate to convert, using the file list.
            SELECTED_FILE=$(whiptail --title "File Selection" --menu "Choose a PEM certificate to convert" 25 78 16 "${file_list[@]}" 3>&1 1>&2 2>&3)

            # Check if the file selection was cancelled.
            if [ $? -ne 0 ]; then
                log "Operation cancelled."
                exit 1
            fi

            # Prompt the user to enter a Job ID and store it in JOB_ID.
            JOB_ID=$(whiptail --inputbox "Enter Job ID (Unique identifier for the filename):" 8 78 --title "Input" 3>&1 1>&2 2>&3)

            # Check if the Job ID input was cancelled.
            if [ $? -ne 0 ]; then
                log "Operation cancelled."
                exit 1
            fi

            # Prompt the user to enter a friendly name for the certificate.
            friendly_name=$(whiptail --inputbox "Enter the friendly name (e.g: yourdomain.com_2023-2024):" 8 78 --title "Input" 3>&1 1>&2 2>&3)

            # Check if the friendly name input was cancelled.
            if [ $? -ne 0 ]; then
                log "Operation cancelled."
                exit 1
            fi

            # Construct the output file name using the Job ID, current date, and friendly name.
            output_file="$SSL_DIR/${JOB_ID}_${current_date}_${friendly_name}.p7b"

            # Execute OpenSSL command to convert the selected PEM certificate to P7B format.
            # Output is redirected to the output file and appended to the log file.
            openssl crl2pkcs7 -nocrl -certfile "$SELECTED_FILE" -out "$output_file" 2>&1 | tee -a "$logs"

            # Check the exit status of the OpenSSL command.
            if [ ${PIPESTATUS[0]} -ne 0 ]; then
                log "Error occurred during OpenSSL operation."
            else
                # Display a message box notifying the user of the successful export.
                whiptail --msgbox "Your P7B file has been exported to $SSL_DIR/$output_file" 8 78 --title "Notification"
            fi
            ;;

        F3)
            # Change the current working directory to the SSL directory.
            cd $SSL_DIR || { log "Directory not found: $SSL_DIR"; exit 1; }

            # Store the current date in the format "ddmmyyyy".
            current_date=$(date +"%d%m%Y")

            # Initialize an empty array to hold the list of files.
            file_list=()

            # Loop through all items in the current directory.
            for file in *; do
                # Check if the item is a file.
                if [ -f "$file" ]; then
                    # If it's a file, add it to the file list.
                    file_list+=("$file" "")
                fi
            done

            # Display a menu to the user to select a PEM certificate to convert, using the file list.
            SELECTED_FILE=$(whiptail --title "File Selection" --menu "Choose a PEM certificate to convert" 25 78 16 "${file_list[@]}" 3>&1 1>&2 2>&3)

            # Check if the file selection was cancelled.
            if [ $? -ne 0 ]; then
                log "Operation cancelled."
                exit 1
            fi

            # Prompt the user to enter a Job ID and store it in JOB_ID.
            JOB_ID=$(whiptail --inputbox "Enter Job ID (Unique identifier for the filename):" 8 78 --title "Input" 3>&1 1>&2 2>&3)

            # Check if the Job ID input was cancelled.
            if [ $? -ne 0 ]; then
                log "Operation cancelled."
                exit 1
            fi

            # Prompt the user to enter a friendly name for the certificate.
            friendly_name=$(whiptail --inputbox "Enter the friendly name (e.g: yourdomain.com_2023-2024):" 8 78 --title "Input" 3>&1 1>&2 2>&3)

            # Check if the friendly name input was cancelled.
            if [ $? -ne 0 ]; then
                log "Operation cancelled."
                exit 1
            fi

            # Construct the output file name using the Job ID, current date, and friendly name.
            output_file="$SSL_DIR/${JOB_ID}_${current_date}_${friendly_name}.p7b"

            # Execute OpenSSL command to convert the selected PEM certificate to P7B format.
            # Output is redirected to the output file and appended to the log file.
            openssl pkcs12 -in "$SELECTED_FILE" -clcerts -nokeys -out "$output_file" 2>&1 | tee -a "$logs"

            # Check the exit status of the OpenSSL command.
            if [ ${PIPESTATUS[0]} -ne 0 ]; then
                log "Error occurred during OpenSSL operation."
            else
                # Display a message box notifying the user of the successful export.
                whiptail --msgbox "Your P7B file has been exported to $SSL_DIR/$output_file" 8 78 --title "Notification"
            fi
            ;;
        F4)
            # Change the current working directory to the SSL directory.
            cd $SSL_DIR || { log "Directory not found: $SSL_DIR"; exit 1; }

            # Prompt the user for the Job ID and store it in JOB_ID.
            JOB_ID=$(get_input "Enter Job ID (Unique identifier for the filename):")

            # Prompt the user for a friendly name for the certificate.
            friendly_name=$(get_input "Enter the friendly name (e.g: yourdomain.com_2023-2024):")

            # Store the current date in the format "ddmmyyyy".
            current_date=$(date +"%d%m%Y")

            # Construct the output file name using the Job ID, current date, and friendly name.
            output_file="${JOB_ID}_${current_date}_${friendly_name}.pfx"

            # Select a private key file from the SSL directory.
            selected_private_key=$(select_file "Select Private Key File" "$SSL_DIR")
            # Check if the selection is empty and exit if true.
            [ -z "$selected_private_key" ] && { show_message "No private key selected. Exiting."; continue; }

            # Select a certificate file from the SSL directory.
            selected_certificate=$(select_file "Select Certificate File" "$SSL_DIR")
            # Check if the selection is empty and exit if true.
            [ -z "$selected_certificate" ] && { show_message "No certificate selected. Exiting."; continue; }

            # Select an intermediate bundle file from the SSL directory.
            selected_bundle=$(select_file "Select Intermediate Bundle File" "$SSL_DIR")
            # Check if the selection is empty and exit if true.
            [ -z "$selected_bundle" ] && { show_message "No intermediate bundle selected. Exiting."; continue; }

            # Execute OpenSSL command to convert the selected private key, certificate, and bundle into a PFX format.
            # The output of this command is captured for logging.
            openssl_command_output=$(openssl pkcs12 -inkey "$selected_private_key" -in "$selected_certificate" -certfile "$selected_bundle" -export -out "$output_file" -name "$friendly_name" 2>&1)

            # Check if the OpenSSL command executed successfully.
            if [ $? -eq 0 ]; then
                # Display a message indicating successful export.
                show_message "Your PFX certificate has been exported to $SSL_DIR/$output_file"
            else
                # Log any errors encountered during the OpenSSL operation.
                log "$openssl_command_output"
            fi
            ;;
        F5)
            # Change the current working directory to the SSL directory.
            cd $SSL_DIR || { log "Directory not found: $SSL_DIR"; exit 1; }

            # Prompt the user for the Job ID and store it in JOB_ID.
            JOB_ID=$(get_input "Enter Job ID (Unique identifier for the filename):")

            # Prompt the user for a friendly name for the certificate.
            friendly_name=$(get_input "Enter the friendly name (e.g: yourdomain.com_2023-2024):")

            # Store the current date in the format "ddmmyyyy".
            current_date=$(date +"%d%m%Y")

            # Construct the output file name using the Job ID, current date, and friendly name.
            output_file="${JOB_ID}_${current_date}_${friendly_name}.pfx"

            # Select a private key file from the SSL directory.
            selected_private_key=$(select_file "Select Private Key File" "$SSL_DIR")
            # Check if the selection is empty and exit if true.
            [ -z "$selected_private_key" ] && { show_message "No private key selected. Exiting."; continue; }

            # Select a certificate file from the SSL directory.
            selected_certificate=$(select_file "Select Certificate File" "$SSL_DIR")
            # Check if the selection is empty and exit if true.
            [ -z "$selected_certificate" ] && { show_message "No certificate selected. Exiting."; continue; }

            # Execute OpenSSL command to create a PFX certificate file from the selected private key and certificate.
            # The output of this command is captured for logging.
            openssl_command_output=$(openssl pkcs12 -inkey "$selected_private_key" -in "$selected_certificate" -export -out "$output_file" -name "$friendly_name" 2>&1)

            # Check if the OpenSSL command executed successfully.
            if [ $? -eq 0 ]; then
                # Display a message indicating successful export.
                show_message "Your PFX certificate has been exported to $SSL_DIR/$output_file"
            else
                # Log any errors encountered during the OpenSSL operation.
                log "$openssl_command_output"
            fi
            ;;
        F6)
            # Change the current working directory to the SSL directory.
            cd $SSL_DIR || { log "Directory not found: $SSL_DIR"; exit 1; }

            # Store the current date in the format "ddmmyyyy".
            current_date=$(date +"%d%m%Y")

            # Initialize an empty array to hold the list of files.
            file_list=()

            # Loop through all items in the current directory.
            for file in *; do
                # Check if the item is a file.
                if [ -f "$file" ]; then
                    # If it's a file, add it to the file list.
                    file_list+=("$file" "")
                fi
            done

            # Display a menu to the user to select an encrypted RSA private key to decrypt, using the file list.
            SELECTED_FILE=$(whiptail --title "File Selection" --menu "Choose an encrypted RSA private key to decrypt" 25 78 16 "${file_list[@]}" 3>&1 1>&2 2>&3)

            # Check if the file selection was cancelled.
            if [ $? -ne 0 ]; then
                log "Operation cancelled."
                exit 1
            fi

            # Prompt the user to enter a Job ID and store it in JOB_ID.
            JOB_ID=$(get_input "Enter Job ID (Unique identifier for the filename):")

            # Prompt the user to enter a friendly name for the decrypted key.
            friendly_name=$(get_input "Enter the friendly name (e.g: yourdomain.com_2023-2024):")

            # Construct the output file name using the Job ID, current date, and friendly name.
            output_file="${JOB_ID}_${current_date}_${friendly_name}.pem"

            # Execute OpenSSL command to decrypt the selected RSA private key.
            # The output of this command is captured for logging.
            openssl_command_output=$(openssl rsa -in "$SELECTED_FILE" -out "$output_file" 2>&1)

            # Check if the OpenSSL command executed successfully.
            if [ $? -eq 0 ]; then
                # Display a message indicating successful decryption and export.
                show_message "Private key decryption completed, file exported to $SSL_DIR/$output_file"
            else
                # Log any errors encountered during the OpenSSL operation.
                log "$openssl_command_output"
            fi
            ;;
        F7)
            # Change the current working directory to the SSL directory.
            cd $SSL_DIR || { log "Directory not found: $SSL_DIR"; exit 1; }

            # Select a PFX file from the SSL directory.
            selected_pfx_file=$(select_file "Select PFX File" "$SSL_DIR")
            # Check if a file has been selected; if not, show a message and continue to the next iteration.
            if [ -z "$selected_pfx_file" ]; then
                show_message "No file selected. Exiting."
                continue
            fi

            # Prompt the user to enter a Job ID and store it in JOB_ID.
            JOB_ID=$(get_input "Enter Job ID (Unique identifier for the filename):")

            # Prompt the user to enter a friendly name for the certificate.
            friendly_name=$(get_input "Enter the friendly name (e.g: yourdomain.com_2023-2024):")

            # Store the current date in the format "dd-mm-YYYY".
            current_date=$(date +'%d-%m-%Y')

            # Execute OpenSSL command to extract the certificate from the PFX file.
            # The output certificate is stored in a PEM file and the command output is logged.
            openssl_command_output=$(openssl pkcs12 -in "$selected_pfx_file" -clcerts -nokeys -out "${SSL_DIR}/${JOB_ID}_${current_date}_${friendly_name}_certificate.pem" 2>&1)
            log "$openssl_command_output"

            # Execute OpenSSL command to extract the private key from the PFX file.
            # The private key is stored in a PEM file and the command output is logged.
            openssl_command_output=$(openssl pkcs12 -in "$selected_pfx_file" -out "${SSL_DIR}/${JOB_ID}_${current_date}_${friendly_name}_privatekey.pem" -nodes -nocerts 2>&1)
            log "$openssl_command_output"

            # Execute OpenSSL command to generate a CSR using the extracted certificate and private key.
            # The CSR is stored in a PEM file and the command output is logged.
            openssl_command_output=$(openssl x509 -x509toreq -in "${SSL_DIR}/${JOB_ID}_${current_date}_${friendly_name}_certificate.pem" -signkey "${SSL_DIR}/${JOB_ID}_${current_date}_${friendly_name}_privatekey.pem" -out "${SSL_DIR}/${JOB_ID}_${current_date}_${friendly_name}_csr.pem" 2>&1)
            log "$openssl_command_output"

            # Construct a message indicating the paths to the extracted certificate, private key, and CSR.
            # Display this message to the user.
            message="PEM certificate, private key, and CSR extracted:\n${SSL_DIR}/${friendly_name}_certificate.pem\n${SSL_DIR}/${friendly_name}_privatekey.pem\n${SSL_DIR}/${friendly_name}_csr.pem"
            show_message "$message"
            ;;
        F8)
            # Change the current working directory to the SSL directory.
            cd $SSL_DIR || { log "Directory not found: $SSL_DIR"; exit 1; }

            # Prompt the user for the Job ID and store it in JOB_ID.
            JOB_ID=$(get_input "Enter Job ID (Unique identifier for the filename):")

            # Prompt the user for a friendly name for the certificate.
            friendly_name=$(get_input "Enter the friendly name for the certificate (e.g: yourdomain.com_2023-2024):")

            # Check if the OpenSSL configuration file exists in the SSL directory.
            if [ ! -f "$SSL_DIR/openssl.cnf" ]; then
                # If the file does not exist, prompt the user for certificate details and create the configuration file.
                COUNTRY=$(get_input "Enter Country Code (example: AU):")
                STATE=$(get_input "Enter State or Province (example: NSW or New South Wales):")
                LOCALITY=$(get_input "Enter City (example: Sydney):")
                ORG=$(get_input "Enter Organization Name (example: Company Ltd):")
                OU=$(get_input "Enter Organizational Unit (example: IT):")
                CN=$(get_input "Enter Common Name (example: company.com):")

                # Write the configuration details to the OpenSSL configuration file.
                cat <<EOF > "$SSL_DIR/openssl.cnf"
[req]
default_bits       = 2048
distinguished_name = req_distinguished_name
req_extensions     = req_ext
x509_extensions    = v3_ca

[req_distinguished_name]
countryName            = $COUNTRY
stateOrProvinceName    = $STATE
localityName           = $LOCALITY
organizationName       = $ORG
organizationalUnitName = $OU
commonName             = $CN

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

            # Log confirmation that the OpenSSL configuration file is set up.
            log "OpenSSL Configuration file confirmed."

            # Prompt the user for the certificate password.
            PASSWORD=$(get_input "Enter a password for the certificate:" "")

            # Select a CA PFX file from the SSL directory.
            selected_pfx_file=$(select_file "Select CA PFX File" "$SSL_DIR")
            # Check if a file has been selected; if not, show a message and continue to the next iteration.
            [ -z "$selected_pfx_file" ] && { show_message "No file selected. Exiting."; continue; }

            # Extract the certificate from the PFX file and log the output.
            openssl_command_output=$(openssl pkcs12 -in "$selected_pfx_file" -clcerts -nokeys -out "${SSL_DIR}/ca-certificate.pem" -passin "pass:$PASSWORD" 2>&1)
            log "$openssl_command_output"

            # Extract the private key from the PFX file and log the output.
            openssl_command_output=$(openssl pkcs12 -in "$selected_pfx_file" -out "${SSL_DIR}/ca-privatekey.pem" -nodes -nocerts -passin "pass:$PASSWORD" 2>&1)
            log "$openssl_command_output"

            # Generate a CSR from the extracted certificate and private key, then log the output.
            openssl_command_output=$(openssl x509 -x509toreq -in "${SSL_DIR}/ca-certificate.pem" -signkey "${SSL_DIR}/ca-privatekey.pem" -out "${SSL_DIR}/ca-csr.pem" -passin "pass:$PASSWORD" 2>&1)
            log "$openssl_command_output"

            # Sign the CSR with the CA's private key to create a CA-signed certificate, and log the output.
            openssl_command_output=$(openssl x509 -req -in "${SSL_DIR}/ca-csr.pem" -CA "${SSL_DIR}/ca-certificate.pem" -CAkey "${SSL_DIR}/ca-privatekey.pem" -CAcreateserial -out "${SSL_DIR}/ca-signed-certificate.pem" -days 365 -extfile "${SSL_DIR}/openssl.cnf" -extensions v3_ca -passin "pass:$PASSWORD" 2>&1)
            log "$openssl_command_output"

            # Check if a friendly name is provided.
            if [ -n "$friendly_name" ]; then
                # Export the CA-signed certificate as a PFX file with the provided friendly name, and log the output.
                openssl_command_output=$(openssl pkcs12 -inkey "${SSL_DIR}/ca-privatekey.pem" -in "${SSL_DIR}/ca-signed-certificate.pem" -export -out "${SSL_DIR}/${JOB_ID}_${friendly_name}.pfx" -passout pass:"$PASSWORD" -name "$friendly_name" 2>&1)
                log "$openssl_command_output"
                # Show a message indicating successful export with friendly name.
                show_message "CA-signed certificate has been exported with friendly name: $friendly_name"
            else
                # Show a message indicating successful export without a friendly name.
                show_message "CA-signed certificate has been exported without a friendly name."
            fi
            ;;
        F9)
            # Change the current working directory to the SSL directory.
            cd $SSL_DIR || { log "Directory not found: $SSL_DIR"; exit 1; }

            # Prompt the user for the Job ID and store it in JOB_ID.
            JOB_ID=$(get_input "Enter Job ID (Unique identifier for the filename):")

            # Prompt the user for a friendly name for the certificate.
            friendly_name=$(get_input "Enter the friendly name for the certificate (e.g: yourdomain.com_2023-2024):")

            # Check if the OpenSSL configuration file exists in the SSL directory.
            if [ ! -f "$SSL_DIR/openssl.cnf" ]; then
                # If the file does not exist, prompt the user for certificate details and create the configuration file.
                COUNTRY=$(get_input "Enter Country Code (example: AU):")
                STATE=$(get_input "Enter State or Province (example: NSW or New South Wales):")
                LOCALITY=$(get_input "Enter City (example: Sydney):")
                ORG=$(get_input "Enter Organization Name (example: Company Ltd):")
                OU=$(get_input "Enter Organizational Unit (example: IT):")
                CN=$(get_input "Enter Common Name (example: company.com):")

                # Write the configuration details to the OpenSSL configuration file.
                cat <<EOF > "$SSL_DIR/openssl.cnf"
[req]
default_bits       = 2048
distinguished_name = req_distinguished_name
req_extensions     = req_ext
x509_extensions    = v3_ca

[req_distinguished_name]
countryName            = $COUNTRY
stateOrProvinceName    = $STATE
localityName           = $LOCALITY
organizationName       = $ORG
organizationalUnitName = $OU
commonName             = $CN

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

            # Log confirmation that the OpenSSL configuration file is set up.
            log "OpenSSL Configuration file confirmed."

            # Prompt the user for the certificate password.
            PASSWORD=$(get_input "Enter a password for the certificate:" "")

            # Select a CA PFX file from the SSL directory.
            selected_ca_pfx_file=$(select_file "Select CA PFX File" "$SSL_DIR")
            # Check if a file has been selected; if not, show a message and continue to the next iteration.
            [ -z "$selected_ca_pfx_file" ] && { show_message "No CA PFX file selected. Exiting."; continue; }

            # Select a self-signed PFX file from the SSL directory.
            selected_selfsigned_pfx_file=$(select_file "Select Self-Signed PFX File" "$SSL_DIR")
            # Check if a file has been selected; if not, show a message and continue to the next iteration.
            [ -z "$selected_selfsigned_pfx_file" ] && { show_message "No Self-Signed PFX file selected. Exiting."; continue; }

            # Extract the certificate from the CA PFX file and log the output.
            openssl_command_output=$(openssl pkcs12 -in "$selected_ca_pfx_file" -clcerts -nokeys -out "${SSL_DIR}/ca-certificate.pem" -passin "pass:$PASSWORD" 2>&1)
            log "$openssl_command_output"

            # Extract the private key from the CA PFX file and log the output.
            openssl_command_output=$(openssl pkcs12 -in "$selected_ca_pfx_file" -out "${SSL_DIR}/ca-privatekey.pem" -nodes -nocerts -passin "pass:$PASSWORD" 2>&1)
            log "$openssl_command_output"

            # Extract the certificate from the self-signed PFX file and log the output.
            openssl_command_output=$(openssl pkcs12 -in "$selected_selfsigned_pfx_file" -clcerts -nokeys -out "${SSL_DIR}/selfsigned-certificate.pem" -passin "pass:$PASSWORD" 2>&1)
            log "$openssl_command_output"

            # Extract the private key from the self-signed PFX file and log the output.
            openssl_command_output=$(openssl pkcs12 -in "$selected_selfsigned_pfx_file" -out "${SSL_DIR}/selfsigned-privatekey.pem" -nodes -nocerts -passin "pass:$PASSWORD" 2>&1)
            log "$openssl_command_output"

            # Create a CA-signed certificate using the self-signed CSR and the CA's private key, and log the output.
            openssl_command_output=$(openssl x509 -req -in "${SSL_DIR}/selfsigned-csr.pem" -CA "${SSL_DIR}/ca-certificate.pem" -CAkey "${SSL_DIR}/ca-privatekey.pem" -CAcreateserial -out "${SSL_DIR}/ca-signed-certificate.pem" -days 365 -extfile "${SSL_DIR}/openssl.cnf" -extensions v3_ca -passin "pass:$PASSWORD" 2>&1)
            log "$openssl_command_output"

            # Check if a friendly name is provided.
            if [ -n "$friendly_name" ]; then
                # Export the CA-signed certificate as a PFX file with the provided friendly name, and log the output.
                openssl_command_output=$(openssl pkcs12 -inkey "${SSL_DIR}/selfsigned-privatekey.pem" -in "${SSL_DIR}/ca-signed-certificate.pem" -export -out "${SSL_DIR}/${JOB_ID}_${friendly_name}.pfx" -passout pass:"$PASSWORD" -name "$friendly_name" 2>&1)
                log "$openssl_command_output"
                # Show a message indicating successful export with friendly name.
                show_message "CA-signed certificate has been exported with friendly name: $friendly_name"
            else
                # Show a message indicating successful export without a friendly name.
                show_message "CA-signed certificate has been exported without a friendly name."
            fi
            ;;
        "Exit")
            # Exit option: Terminate the script.
            log "Exiting script."
            clear
            break
            ;;
        *)
            # Handle invalid selections.
            log "Invalid option selected: $option"
            ;;
    esac
done