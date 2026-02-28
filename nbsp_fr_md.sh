#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Incorrect number of args ($# ≠ 1)"
  exit
fi

f=$1

if [[ ! -e "$f" ]]; then
  echo "File not found: $f"
  exit
fi

perl -i -pe '
  use strict;
  use warnings;

  s/« /« /g;

  s/ ([:;?!»])/ $1/g;

' "$f"
echo "ok: $f"
