#!/bin/bash

ID_RSA=~/.ssh/id_rsa

if [ ! -f ${ID_RSA} ]; then
  echo "Missing default ssh keys at ${ID_RSA}!"
  echo "Creating pair..."
  ssh-keygen -t rsa -b 4096 -C "leandro@ostera.io"
  echo "Done:"
else
  echo "Using existing ssh keys found at ${ID_RSA}:"
fi;

cat ${ID_RSA}
