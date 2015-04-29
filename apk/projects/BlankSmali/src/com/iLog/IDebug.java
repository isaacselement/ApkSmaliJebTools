package com.iLog;

import android.util.Log;

public class IDebug {
	
	private static final String iDEBUG_LOG = "iDEBUG_LOG";
	private static final String iDEBUG_STACKS = "iDEBUG_STACKS";

	public static void logObject(Object obj) {
		if (obj == null) {
			log("~null object");
		} else {
			log(obj.toString());
		}
	}
	
	public static void log(String str) {
		if (str == null) {
			Log.d(iDEBUG_LOG, "~null string");
		} else if (str.equals("")) {
			Log.d(iDEBUG_LOG, "~empty string");
		} else {
			Log.d(iDEBUG_LOG, str);
		}
	}
	
	public static void logStacks() {
		StackTraceElement[] stacks = Thread.currentThread().getStackTrace();
		int length = stacks.length;
		Log.d(iDEBUG_STACKS, "length: " + length);
		for (int i = 0; i < length; i++) {
			Log.d(iDEBUG_STACKS, stackElementToString(stacks[i]));
		}
	}
	
	private static String stackElementToString(StackTraceElement e) {
		String clazzName = e.getClassName();
		String methodName = e.getMethodName();
		int lineNumber = e.getLineNumber();
		return clazzName + " - " + methodName + ":" + lineNumber;
	}
	
	public static void startT() {
		android.os.Debug.startMethodTracing("iDEBUG");
	}
	
	public static void stopT() {
		android.os.Debug.stopMethodTracing();
	}
}
