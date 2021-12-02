#!/bin/bash
dig +tries=1 +time=1 +short +search @8.8.8.8 google.com > /dev/null \
  && echo ✅ \
  || echo "❌ no internet!"
