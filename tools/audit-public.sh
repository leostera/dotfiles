#!/usr/bin/env bash
set -euo pipefail

mode="${1:---staged}"
secret_pattern='(AKIA[0-9A-Z]{16}|ASIA[0-9A-Z]{16}|gh[pousr]_[A-Za-z0-9_]{20,}|sk-[A-Za-z0-9]{20,}|xox[baprs]-[A-Za-z0-9-]{20,}|-----BEGIN (RSA|OPENSSH|EC|DSA) PRIVATE KEY-----|Bearer[[:space:]]+[A-Za-z0-9._-]{20,})'
failures=0

report() {
  printf 'public-audit: %s\n' "$*" >&2
  failures=$((failures + 1))
}

is_suspicious_path() {
  local path="$1"

  case "$path" in
    .env|.env.*)
      [[ "$path" != ".env.example" ]]
      return
      ;;
    *secret*|*secrets*|*credential*|*credentials*|*token*|*password*)
      return 0
      ;;
    */id_rsa|*/id_ed25519|*/id_ecdsa|*/id_dsa|*/known_hosts|*/known_hosts.old)
      return 0
      ;;
  esac
  return 1
}

case "$mode" in
  --staged)
    while IFS= read -r -d '' path; do
      if is_suspicious_path "$path"; then
        report "suspicious staged path: $path"
      fi
      if git show ":$path" 2>/dev/null | grep -aEq "$secret_pattern"; then
        report "secret-shaped content in staged file: $path"
      fi
    done < <(git diff --cached --name-only --diff-filter=ACMR -z)

    if ! git diff --cached --check; then
      report "whitespace errors in staged changes"
    fi
    ;;

  --history)
    while IFS= read -r -d '' path; do
      if [[ -n "$path" ]] && is_suspicious_path "$path"; then
        report "historical suspicious path: $path"
      fi
    done < <(git log --all --format= --name-only -z)

    # Scan each unique blob once. Never print matching file contents.
    while IFS= read -r object; do
      [[ -n "$object" ]] || continue
      [[ "$(git cat-file -t "$object" 2>/dev/null || true)" == blob ]] || continue
      if git cat-file blob "$object" | grep -aEq "$secret_pattern"; then
        report "secret-shaped content in historical blob: $object"
      fi
    done < <(git rev-list --objects --all | awk '{print $1}' | sort -u)
    ;;

  *)
    echo "usage: $0 [--staged|--history]" >&2
    exit 2
    ;;
esac

if (( failures > 0 )); then
  printf 'public-audit: %d finding(s)\n' "$failures" >&2
  exit 1
fi
printf 'public-audit: no secret-like findings\n'
