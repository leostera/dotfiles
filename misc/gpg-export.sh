#!/bin/bash

readonly KEY_NAME=$(
  gpg --list-secret-keys --keyid-format LONG \
    | grep "sec   rsa2048/" \
    | awk '{ print $2 }' \
    | awk -F'/' '{ print $2 }'
)

gpg --armor --export ${KEY_NAME}
