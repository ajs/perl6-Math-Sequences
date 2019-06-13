#!/bin/bash
#
# Within a rakudo star container, run our tests

for test in /build/t/*.t; do
    timeout 30s perl6 -I /build/lib "$test"
done
