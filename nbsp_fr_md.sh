#!/usr/bin/env bash
set -euo pipefail

# Remplace les espaces ordinaires par des NBSP selon les règles françaises :
# - après «
# - avant : ; ? ! »
#
# Récursif sur *.md (hors dossiers .git)

for f in *.md; do
  [ -e "$f" ] || continue  # évite l'erreur si aucun .md

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
done
