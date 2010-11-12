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
package tw.edu.ntu.mgov.net;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLConnection;

public class ReadUrl {

	public static String process(String strUrl,String encode){
		URL url;
		URLConnection connection = null;
		
		try {
			url = new URL(strUrl);
			connection = url.openConnection();

		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return process(connection,encode);
	}

	public static String process(URLConnection connection,String encode) {

		String line;
		StringBuilder builder = new StringBuilder();

		BufferedReader reader;
		try {
			reader = new BufferedReader(new InputStreamReader(
					connection.getInputStream(), encode));
			while ((line = reader.readLine()) != null) {
				builder.append(line + "\n");
			}
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

		String response = builder.toString();
		return response;
	}

}
