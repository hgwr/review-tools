#!/usr/bin/env bash
#
# Usage: check-and-test.sh
#
# Example of ~/.config/review-tools.yml
# 
# additional_test_tasks: |
#   cd frontend && ng test --watch=false --code-coverage
#   cd frontend && ng lint
#

set -o errexit
set -o pipefail
set -o nounset

trap 'echo "Ctrl-C captured and exit."; exit 1' INT
trap 'echo "some error occured at $(pwd) and exit."; exit 8' SIGHUP

dir=$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
source "${dir}/common-functions.sh"

bundle exec pronto run
if grep 'rspec-rails' Gemfile > /dev/null; then
  bundle exec rspec spec
else
  bundle exec rake test
fi
bundle exec rubocop

run_additional_task test_tasks