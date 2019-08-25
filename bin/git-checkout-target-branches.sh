#!/usr/bin/env bash
#
# Usage: git-checkout-target-branches.sh into milestone/abc from feature/cde
#

set -o errexit
set -o pipefail
set -o nounset

trap 'echo "Ctrl-C captured and exit."; exit 1' INT
trap 'echo "some error occured at $(pwd) and exit."; exit 8' SIGHUP

if [ $# -ne 4 ] || [ "$1" != "into" ]  || [ "$3" != "from" ]; then
  echo "Usage: git-checkout-target-branches.sh into milestone/abc from feature/cde" 1>&2
  exit 1
fi

