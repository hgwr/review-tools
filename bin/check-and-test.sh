#!/usr/bin/env bash
#
# Usage: prepare-rails-and-frontend.sh
#
# Example of ~/.config/review-tools.yml
# 
# additional_preparation: |
#   ( cd frontend && nodebrew use v`cat .node-version` && rm -rf node_modules && yarn )
#   
# additional_db_preparation: |
#   bundle exec bin/rails db:task:you:made
#

set -o errexit
set -o pipefail
set -o nounset

bundle exec pronto run
bundle exec rspec spec
bundle exec rubocop

