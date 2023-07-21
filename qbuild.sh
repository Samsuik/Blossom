#!/bin/bash

mvn clean install -Dmaven.test.skip=true -DskipTests && ./scripts/paperclip.sh
