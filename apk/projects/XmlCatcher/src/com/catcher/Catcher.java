package com.catcher;

import java.io.File;
import java.io.FileOutputStream;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.Attributes;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

public class Catcher {

	static String mainActivityName = null;
	static String tempName = null;
	
	public static void main(String[] args) {
		try {
//			String xmlFileName = System.getProperty("user.dir") + "/" + "AndroidManifest.xml";
			String xmlFileName = args[0];
			if(!xmlFileName.endsWith(".xml")) {
				xmlFileName += ".xml";
			}
			
			SAXParser parser = SAXParserFactory.newInstance().newSAXParser();
			DefaultHandler handler = new DefaultHandler() {

				@Override
				public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
					super.startElement(uri, localName, qName, attributes);
//					System.out.println("start: " + qName);
					
					if (mainActivityName != null) return;
					for (int i = 0; i < attributes.getLength(); i++) {
						String nameString = attributes.getQName(i);
						String valueString = attributes.getValue(i);
						
						if (qName.equals("activity") && nameString.equals("android:name")) {
							tempName = valueString;
						} else if (qName.equals("action") && nameString.equals("android:name") && valueString.equals("android.intent.action.MAIN")) {
							mainActivityName = tempName;
							System.out.println("Catcher get the main activity name: " + mainActivityName);
						}
					}
				}

				@Override
				public void endElement(String uri, String localName, String qName) throws SAXException {
					super.endElement(uri, localName, qName);
//					System.out.println("end: " + qName);
				}
				
			};
			parser.parse(new InputSource(xmlFileName), handler);
			
			// save the result to file
			FileOutputStream fileOutputStream = new FileOutputStream(new File("./TEMP_MainActiviyName_REMOVED"));
			fileOutputStream.write(mainActivityName.getBytes());
			fileOutputStream.close();
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
}






