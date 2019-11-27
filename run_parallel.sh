#!/usr/bin/env bash
# Use to run a task to process a input file with multithreading. Each element of the input file and output file should be in a single line.
# <input> and <output> of the MainClass should be the first 2 arguments. MainClass processes input and output files in GZIP format.
# run_parallel.sh <nProcesses> <MainClass> <input> <output> <more args...>
# Real output file will be also in GZIP format.
CLASSPATH=./lib/; export CLASSPATH=$(find "$CLASSPATH" -name '*.jar' -type f -printf ':%p\n' | sort -u | tr -d '\n');

np=$(($1-1))
echo "Split data"
java -cp $CLASSPATH:./antbuild/ util.FileSplitter $3 $1

echo "Run in parallel"
for i in $(seq -f "%02g" 0 ${np}); do
java -cp $CLASSPATH:./antbuild/ -Xmx8G $2 $3.part$i.gz $4.part$i.gz ${@:5} 1>$4.part$i.out 2>$4.part$i.err &
done

wait

echo "Combine result"
zcat $4.part*.gz | gzip > $4
echo "Clean"
# Remove input parts.
rm $3.part*.gz
# Remove output parts.
rm $4.part*.gz
