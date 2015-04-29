## ApkSmaliTools

### 1. ApkTool

#### Refrence

0. [Apktool - A tool for reverse engineering Android apk files](http://ibotpeaches.github.io/Apktool/)

1. [Smali - Overview](https://bitbucket.org/JesusFreke/smali/overview)

2. [Eclipse Class Decompiler](http://bbs.csdn.net/topics/390263414)
 
3. [APKTool+eclipse dynamic debugging smali](http://bbs.pediy.com/showthread.php?t=189610)

4. [Debug Android Apk without source codes(ApkTool+Eclipse ADT)](http://blog.csdn.net/roland_sun/article/details/26399669)

5. [android reverse analysis - log](http://www.9hao.info/pages/2014/07/androidni-xiang-fen-xi-zhi-logpian)

#### Usage

######First. Connect your device(root) to your PC:

    adb root
    adb shell
    ls /data/app          // get the com.xxx.apk name

######Second. Open another terminal and start:

    ./apk.sh com.xxx.apk


######Third
1.Copy your smali codes into Java Project, set some breakpoints 
2.Close your origin project (if needed)
2.In Debug Configuration, set Remote Port, then hit Debug


### 2. JEB


#### Refrence

1. [pediy.com jeb download](http://bbs.pediy.com/showthread.php?t=189980)

2. [kanxue.com jeb download](http://www.kanxue.com/bbs/showthread.php?t=189980)

3. [JEBDecompileAll.py useage](http://www.cnblogs.com/maseng/p/4065853.html)

4. [office download site](http://www.android-decompiler.com/download.php)

5. [JEBDecompileAll.py office download site](https://www.pnfsoftware.com/viewer?file1=scripts/JEBDecompileAll.py)


#### Usage

######First. Extract you com.xxx.apk file

######Second. Use jeb to rename the classes, variables, functions

	 ./jeb.sh ./com.xxx.xxx/classes.dex.jdb

	 ./jeb.sh -f ./com.xxx.xxx/classes.dex.jdb "Callback_s"
