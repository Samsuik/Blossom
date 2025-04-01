#!/bin/bash

./scripts/prepare-build.sh && mvn clean install -Dmaven.test.skip=true -DskipTests && ./scripts/paperclip.sh
