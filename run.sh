#!/usr/bin/env bash
# run.sh [JAVA_OPTIONS] <MainClass> <args...>
CLASSPATH=./lib/; export CLASSPATH=$(find "$CLASSPATH" -name '*.jar' -type f -printf ':%p\n' | sort -u | tr -d '\n');

java -cp $CLASSPATH:./antbuild/ $@
