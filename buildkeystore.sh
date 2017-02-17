#!/bin/bash

OLD_PWD=$PWD
KEYS_DIR=${1:-$PWD}
KEYSTORE=${2:-emulator}
KEYS="media platform shared testkey verity"

mkdir -p /tmp/buildkeystore
cd /tmp/buildkeystore

for k in $KEYS; do
  openssl pkcs8 -inform DER -nocrypt -in "$KEYS_DIR/$k.pk8" | openssl pkcs12 -export -in "$KEYS_DIR/$k.x509.pem" -inkey /dev/stdin -name "$k" -password pass:android -out "$k_decrypted_key.p12"

  keytool -importkeystore -deststorepass android -srckeystore "$k_decrypted_key.p12" -srcstoretype PKCS12 -srcstorepass android -destkeystore "$KEYS_DIR/$KEYSTORE.keystore"
done

echo ""
echo "Created $KEYS_DIR/$KEYSTORE.keystore"

cd $OLD_PWD
rm -fr /tmp/buildkeystore



