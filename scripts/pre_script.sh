#!/bin/bash
set -xeu

REQ_FILE=".github/setup.sh"
if [ -e $REQ_FILE ]; then
    chmod +x $REQ_FILE
    $REQ_FILE
fi