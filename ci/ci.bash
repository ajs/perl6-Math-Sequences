#!/bin/bash
#
# Within a rakudo star container, run our tests

perl6 -I /build/lib /build/t/*.t
