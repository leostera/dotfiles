#!/usr/bin/env bash
set -euo pipefail

case "$(uname -s)" in
  Darwin)
    exec ./bootstrap.macos.sh
    ;;
  Linux)
    exec ./bootstrap.linux.sh
    ;;
  *)
    echo "Unsupported OS: $(uname -s)"
    exit 1
    ;;
esac
