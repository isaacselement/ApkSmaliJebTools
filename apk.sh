#!/bin/bash

# Connect your device, confirm you have install this apk: adb shell, ls /data/app

# log function
function ilog {
	echo ""
	echo "----- $1"
	echo ""
}

if [[ $1 = "" ]]; then
	ilog "no arguments"
	exit 1
fi

# run adb as root
adb root

# get the configs and variables
apktoolJarPath=./apk/apktool_2.0.0.jar
signapkDirectory=./apk/signapk
xmlCutorJarPaht=./apk/XmlCatcher.jar

__OPTION__=$1
PROJECT_NAME=""


if [[ $__OPTION__ == "-P" ]];then
	PROJECT_NAME=$2
	PROJECT_NAME=${PROJECT_NAME/%\//}
else
	apkName=$1
	PROJECT_NAME=${apkName/%-*/}

	# download the .apk file, // for windows's git-bash
	apkPath=//data/app/$apkName
	ilog "pulling: $apkPath"
	adb pull $apkPath

	# decomplie the .apk file
	if [ ! -f "${apkName}" ]; then
		ilog "apk file not exists"
		exit 1
	else
		ilog "pull apk successfully"	
	fi
	ilog "decompling: $apkName"
	tempPullDir=${apkName/.apk/_apk}
	java -jar $apktoolJarPath d -f -d $apkName -o $tempPullDir
	
	# for eclipse project
	if [ ! -d "${PROJECT_NAME}" ]; then
		mkdir ${PROJECT_NAME}
	fi
	pushd ${PROJECT_NAME}
	ls | grep -E -v ".classpath|.project|.settings" | xargs rm -rf
	popd
	mv ${tempPullDir}/* ${PROJECT_NAME}/
	rm -rf ${tempPullDir}
fi

# get the package name 
manifestfileName=$PROJECT_NAME/AndroidManifest.xml
packageName=`cat $manifestfileName | grep package | sed -n 's/.*package="//p' | tr "\"" "\n" | head -n 1`
ilog "package name: $packageName"

# insert the debuggabel flag
tmpString="android:debuggable=\"true\""
applicationString=`cat $manifestfileName | grep "<application "`
echo "$applicationString" | grep -q "$tmpString"
if [ $? -eq 1 ]; then
	ilog "Inserting android:debuggable='true' flag"
	sed -i -e 's/<application /<application android:debuggable="true" /g' $manifestfileName
fi

# get the activity name
# tempActivityXMLStr=`xmllint --xpath "//action[@*='android.intent.action.MAIN'][1]/../../@*" $manifestfileName`
# mainActivityName=`echo $tempActivityXMLStr | sed -n 's/.*android:name="//p' | tr "\"" "\n" | head -n 1`
java -jar $xmlCutorJarPaht $manifestfileName
mainActivityName=`cat TEMP_MainActiviyName_REMOVED`
rm TEMP_MainActiviyName_REMOVED
mainActivityPath=$packageName/$mainActivityName

# wait for modify smali job done
if [[ $__OPTION__ == "-P" ]];then
	ilog "Project Mode, continue ..."
else
	for((i=1;i<=3;i++));
	do
		ilog "i.e. ${mainActivityName}.onCreate(Android): a=0;// 	invoke-static {}, Landroid/os/Debug;->waitForDebugger()V"
		ilog "After Changed Smali Codes, Press ENTER (or Ctrl-C to cancel):"
		read -s -n 1 key
		if [[ $key = "" ]]; then
			break
		else
			continue
		fi
	done
fi


# generate debug file
debugfile="${PROJECT_NAME}_debug.apk"
ilog "generating: $debugfile"
java -jar $apktoolJarPath b -d $PROJECT_NAME -o $debugfile

# generate signed file
signedfile=${debugfile/.apk/_signed.apk}
ilog "signing: $signedfile"
java -jar ${signapkDirectory}/signapk.jar ${signapkDirectory}/key.media.x509.pem ${signapkDirectory}/key.media.pk8 $debugfile $signedfile

# unistall the old app and install the new one
ilog "unistalling"
adb uninstall $packageName
ilog "installing"
adb install $signedfile

# launch the debug apk
ilog "Run: adb shell am start -n $mainActivityPath"
ilog "Debug: adb shell am start -D -n $mainActivityPath"
ilog "For Debug, make sure you have close your origin project and set breakpoint in your remote debug smali codes"
ilog "Press 'ENTER' key to Debug, Press 'R/r' to Run :"
read -s -n 1 key
if [[ $key == "" ]]; then
	ilog "debuging..."
	adb shell am start -D -n $mainActivityPath
elif [[ $key == "r" ]] || [[ $key == "R" ]]; then
	ilog "running..."
	adb shell am start -n $mainActivityPath
else
	ilog "Cancel Launch."
fi
