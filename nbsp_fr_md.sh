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

  my $nbsp = "\x{00A0}";

  # 1) Après « : si pas déjà NBSP
  s/« /« /g;

  # 2) Avant : ; ? ! » : remplace espaces (y compris NBSP multiples) par NBSP unique
  s/ ([:;?!»])/ $1/g;

' "$f"
echo "ok: $f"
