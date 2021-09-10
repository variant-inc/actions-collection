#!/bin/bash
set -eu

REQ_FILE=".github/actions/pre_test.sh"
if [ -f $REQ_FILE ]; then
    echo "_____________________________PRE_STEPS_BEGIN_OUTPUT_________________________________"
    chmod +x $REQ_FILE
    $REQ_FILE
    echo "______________________________PRE_STEPS_END_OUTPUT__________________________________"
fi