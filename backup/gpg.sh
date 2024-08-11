#!/usr/bin/env bash

key_destination="~/.gnupg/keypair.asc"
if [ ! -z "$2" ]; then
	key_destination="$2/keypair.asc"
fi
echo "[+] Exporting ID: $1"
echo "[+] Destination: $key_destination"
gpg --export --armor "$1" > $key_destination
gpg --export-secret-keys --armor "$1" >> $key_destination
gpg --symmetric --cipher-algo AES256 --output "$key_destination.gpg" $key_destination
rm $key_destination
