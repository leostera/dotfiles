#!/bin/bash

if [[ `which opam` ]]; then
  echo "Found an installation of opam at: `which opam`"
  echo "Proceeding to install common packages..."
  opam install --yes \
    ocp-index \
    ocp-index-top \
    ocp-indent \
    utop \
    user-setup \
    core
  echo "OK"
fi
