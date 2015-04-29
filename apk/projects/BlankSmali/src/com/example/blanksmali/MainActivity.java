package com.example.blanksmali;

import java.util.ArrayList;

import android.app.Activity;
import android.os.Bundle;

import com.iLog.IDebug;

public class MainActivity extends Activity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		
//		Debug.startT();
		IDebug.logObject(this);
//		Debug.stopT();
		
		ArrayList<String> list = new ArrayList<String>();
		IDebug.logObject(list);
		
		IDebug.log("ABC");
		
		IDebug.logStacks();
		
		String v = "Wifi.password";
		String flag = "Wifi.password";
		if (flag.equals(v)) {
			IDebug.logStacks();
		}
	}
}
