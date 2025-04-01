#!/bin/bash

git submodule update --init && ./scripts/remap.sh && ./scripts/decompile.sh && ./scripts/init.sh && ./applyPatches.sh
