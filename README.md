# SimpleSSL Tool

## Overview:
SimpleSSL Tool is a versatile script designed for managing various SSL certificate tasks. It provides an array of functions for generating, converting, and managing SSL certificates in different formats.

### Notice:
This is beta code, so if it does not work as expected please let me know and provide as much feedback I will endeavour to fix up as much as possible.

### Version:
2.0-TESTING

### Author:
Jayson Barnden

### Contact:
[GitHub - justanotherkiwi](https://github.com/justanotherkiwi)

## Features:
SimpleSSL Tool includes functionalities such as:
- Simplified GUI
- Generating Certificate Signing Requests (CSRs) and private keys.
- Converting certificates between PEM, P7B, and PFX formats.
- Decrypting and extracting unencrypted private keys from encrypted RSA private keys.
- Extracting PEM certificates, CSRs, and private keys from PFX files.
- Signing self-signed certificates with internal CAs using various file formats.

## Prerequisites:
- Note this was built ontop of Debian 12
- Whiptail
- OpenSSL v3

## Tested on:
- Debian 12
- Debian WSL

## Usage:

If you download the binary file simple place into /bin/ and run simplessl
If you download the shell script run the following commands:

```bash
chmod +x ./simplessl.sh
sudo mv simplessl.sh /bin/simplessl
simplessl
```
![image](https://github.com/justanotherkiwi/SimpleSSL/assets/76455604/c0d0a8de-be7a-4f59-a2b6-0b2b03411d16)

## Changelog

3/01/2024:
- Added screenshot.
- Updating README.MD
- Removed Binary file.
- Confimred Binary file is damaged.
- General public release.
