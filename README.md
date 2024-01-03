# SimpleSSL Tool

## Overview:
SimpleSSL Tool is a versatile script designed for managing various SSL certificate tasks. It provides an array of functions for generating, converting, and managing SSL certificates in different formats.

### Notice:
This is beta code, so if it does not work as expected please let me know and provide as much feedback I will endeavour to fix up as much as possible.

### Versions:
- 1.0-PROD (Not pretty but gets the job done).
- 2.0-TESTING (Might have bugs).

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

All you need to do is grant executable rights to the shell script and place into the /bin or /usr/local/bin folder.

```bash
chmod +x ./simplessl-v2.sh
sudo mv simplessl-v2.sh /bin/simplessl
simplessl
```
![image](https://github.com/justanotherkiwi/SimpleSSL/assets/76455604/c0d0a8de-be7a-4f59-a2b6-0b2b03411d16)
![image](https://github.com/justanotherkiwi/SimpleSSL/assets/76455604/7b4b5d3b-6318-4d74-a275-98f634b426d6)

## Changelog

3/01/2024:
- Added screenshot.
- Updating README.MD
- Removed Binary file.
- Confimred Binary file is damaged.
- General public release.
