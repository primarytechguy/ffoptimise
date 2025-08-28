#!/bin/bash

export PATH="/opt/homebrew/bin/:$PATH"

CURRENT_DIR="$(pwd)"

/usr/local/bin/ffoptimise "$CURRENT_DIR" --delete-audio

