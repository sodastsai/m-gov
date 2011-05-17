/*
 * 
 * ReadUrl.java
 * ggm
 * 
 * Read url
 *
 * Copyright 2010 NTU CSIE Mobile & HCI Lab
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */
package tw.edu.ntu.mgov1999.net;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map.Entry;

public class URLUtil {
	/* http request type */
	public enum ReadURLMethod { HTTP_GET, HTTP_POST }
	
	public static String readURL(String URL, ReadURLMethod method) throws IOException { return readURL(URL, null, method); }

	public static String readURL(String URL, HashMap<String, String> data, ReadURLMethod method) throws IOException {
		if (method==ReadURLMethod.HTTP_GET) return readURLbyGET(URL, data);
		else if (method==ReadURLMethod.HTTP_POST) return readURLbyPOST(URL, data);
		return null;
	}
	
	public static String readURLbyGET(String strURL, HashMap<String, String> data) throws IOException {
		URL url;
		URLConnection connection = null;
		
		String queryString = "";
		for (Entry<String, String> entry : data.entrySet())
			queryString += "&"+URLEncoder.encode(entry.getKey(), "utf-8") + "=" + URLEncoder.encode(entry.getValue(), "utf-8");
		queryString = queryString.substring(1, queryString.length());
		strURL+= "?"+queryString;
		
		url = new URL(strURL);
		connection = url.openConnection();
		
		String line;
		StringBuilder builder = new StringBuilder();

		BufferedReader reader;
		reader = new BufferedReader(new InputStreamReader(connection.getInputStream(), "utf-8"));
		while ((line = reader.readLine()) != null)
			builder.append(line + "\n");
		return builder.toString();
	}
	
	public static String readURLbyPOST(String strURL, HashMap<String, String> data) throws IOException {
		String result = "";
		
		// Construct data
		String dataString = "";
		for (Entry<String, String> entry : data.entrySet())
			dataString += "&"+URLEncoder.encode(entry.getKey(), "utf-8") + "=" + URLEncoder.encode(entry.getValue(), "utf-8");
		// Remove first &
		dataString = dataString.substring(1, dataString.length());
		
	    // Send data
	    URL url = new URL(strURL);
	    URLConnection conn = url.openConnection();
	    conn.setDoOutput(true);
	    conn.setRequestProperty("User-Agent", "Mozilla/5.0 (Linux; U; Android 2.3.3; zh-tw; Nexus S Build/GRI40)" +
			" AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1,gzip(gfe)");
	    conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
	    OutputStreamWriter ouputStream = new OutputStreamWriter(conn.getOutputStream());
	    
	    ouputStream.write(dataString);
	    ouputStream.flush();

	    // Get the response
	    BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
	    String line;
	    while ((line = reader.readLine()) != null)
	        result += line + "\n";
	    ouputStream.close();
	    ouputStream.close();

		return result;
	}
}
