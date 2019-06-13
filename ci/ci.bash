#!/bin/bash
#
# Within a rakudo star container, run our tests

for test in /build/t/*.t; do
    perl6 -I /build/lib "$test"
done
