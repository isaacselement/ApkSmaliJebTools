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
	echo "-----------------"
	find . | xargs grep -rl $3
	echo "-----------------"
	popd
	exit 1
fi

classesDexDecompiledPath=${classesDexPath}_decompiled
if [ -d "${classesDexDecompiledPath}" ]; then
	rm -rf ${classesDexDecompiledPath} 
fi

java -Xmx1024m -jar ${jebJarPath} --automation --script=${JEBDecompileAllPyPath} ${classesDexPath}

