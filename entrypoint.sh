#!/bin/bash

set -e

# Print the input message
echo "Executing command: ${INPUT_COMMAND}"
sh -c "${INPUT_COMMAND}"
