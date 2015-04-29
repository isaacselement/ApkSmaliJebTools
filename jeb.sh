#!/bin/bash

## You need to extract the com.xxx.apk file, then set the classes.dex file path

jebJarPath=./jeb/jeb.jar
JEBDecompileAllPyPath=./jeb/JEBDecompileAll.py

__OPTION__=$1

classesDexPath=$1

if [ $__OPTION__ == "-f" ]; then
	classesDexPath=$2
	classesDexDecompilePath=${classesDexPath}_decompiled
	pushd ${classesDexDecompilePath} 
	find . | xargs grep -ri $3 -l
	popd
	exit 1
fi
 
java -Xmx1024m -jar ${jebJarPath} --automation --script=${JEBDecompileAllPyPath} ${classesDexPath}

