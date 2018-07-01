#!/bin/bash

ssh-keygen -t rsa -C "leandro@ostera.io"

cat ~/.ssh/id_rsa.pub
