/*
 * 
 * ReadUrlByPOST.java
 * ggm
 * 
 * Read url in POST way
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
package tw.edu.ntu.mgov.net;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Iterator;

import tw.edu.ntu.mgov.gae.GAECase;

public class ReadUrlByPOST {

	public static void main(String args[]) {

		//String url = "http://www.czone.tcg.gov.tw/tp88-1/sys/begin.cfm";
		HashMap<String, String> forms = new HashMap<String, String>();

		forms.put("LOGIN", "guest");
		forms.put("PASSWORD", "guest");

		try {
//			String res = doSubmit(url, forms);
//			System.out.println(res);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	public static String doSubmit(String url, GAECase data)
			throws Exception {

		URL siteUrl = new URL(url);
		HttpURLConnection conn = (HttpURLConnection) siteUrl.openConnection();

		conn.setRequestMethod("POST");
		conn.setDoOutput(true);
		conn.setDoInput(true);
		conn.setDoOutput(true);
		conn.setDoInput(true);
		conn.setRequestProperty("User-Agent",
				"Mozilla/5.0 (compatible; MSIE 6.0; Windows NT)");
		conn.setRequestProperty("Content-Type",
				"application/x-www-form-urlencoded");

		DataOutputStream out = new DataOutputStream(conn.getOutputStream());

		
		Iterator<String> it = data.keySet().iterator();
		String content="";		
		boolean begin=true;
		
		while(it.hasNext()){
			String key = it.next();
			Object val = data.get(key);
			
			if(val.equals(String.class) )
			{
				if(begin==false)
					content +="&";
			
				content += key + "=" + URLEncoder.encode( (String) val, "big5");
				begin = false;
			}
			else if(val.equals(byte[].class) ) //image
			{
				
			}
		}
		
		out.writeBytes(content);
		out.flush();
		out.close();
		String line = "", res = "";
		try {
/*
			for (int i = 0; i< 15; i++)
				System.out.println(conn.getHeaderField(i));
*/
			BufferedReader in = new BufferedReader(new InputStreamReader(conn
					.getInputStream(), "big5"));
			while ((line = in.readLine()) != null) {
				res += line + "\n";
			}
			in.close();
						

		} catch (Exception e) {
			e.printStackTrace();
			// System.out.println(e);
		}

		return res;
	}

}
