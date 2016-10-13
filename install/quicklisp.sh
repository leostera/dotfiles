#!/bin/sh

curl -O http://beta.quicklisp.org/quicklisp.lisp
curl -O http://beta.quicklisp.org/quicklisp.lisp.asc
gpg --verify quicklisp.asc
