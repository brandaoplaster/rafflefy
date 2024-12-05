#!/bin/bash
set -e

bin/rafflefy eval "Rafflefy.Release.migrate"
bin/rafflefy start

exec "$@"
