/*
 * 
 * SendImage.java
 * ggm
 * 
 * photo sender
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

import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.SocketTimeoutException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

public class SendImage {
	
	URL url;
	HttpURLConnection conn;
	String boundary = "--------httppost123";
	Map<String, String> textParams = new HashMap<String, String>();
	Map<String, byte[]> byteParams = new HashMap<String, byte[]>();

	static String photo_name = "pic";
	DataOutputStream ds;

	
	public SendImage(String url) throws Exception {
		this.url = new URL(url);
	}

	public void setUrl(String url) throws Exception {
		this.url = new URL(url);
	}
	public void setTextPatams(Map<String, String> textParams){
		this.textParams = textParams;
	}

	public void addTextParameter(String name, String value) {
		textParams.put(name, value);
	}

	public void addByteParameter(String name, byte[] value) {
		byteParams.put(name, value);
	}

	public void clearAllParameters() {
		textParams.clear();
		byteParams.clear();
	}
    // 傳送，並返回結果
	public byte[] send() throws Exception {
		initConnection();
		try {
			conn.connect();
		} catch (SocketTimeoutException e) {
			// TODO
			throw new RuntimeException();
		}
		ds = new DataOutputStream(conn.getOutputStream());
		writeTextsParams();
		writeByteParams();
		paramsEnd();
		InputStream in = conn.getInputStream();
		ByteArrayOutputStream out = new ByteArrayOutputStream();
		int b;
		while ((b = in.read()) != -1) {
			out.write(b);
		}
		conn.disconnect();
		return out.toByteArray();
	}
    //connection init
	private void initConnection() throws Exception {
		conn = (HttpURLConnection) this.url.openConnection();
		conn.setDoOutput(true);
		conn.setUseCaches(false);
		conn.setConnectTimeout(10000); //连接超时为10秒
		conn.setRequestMethod("POST");
		conn.setRequestProperty("Content-Type",
				"multipart/form-data; boundary=" + boundary);

	}
    //傳text
	private void writeTextsParams() throws Exception {
		Set<String> keySet = textParams.keySet();
		for (Iterator<String> it = keySet.iterator(); it.hasNext();) {
			String name = it.next();
			String value = textParams.get(name);
			ds.writeBytes("--" + boundary + "\r\n");
			ds.writeBytes("Content-Disposition: form-data; name=\"" + name
					+ "\"\r\n");
			ds.writeBytes("\r\n");
			ds.write(value.getBytes());
			ds.writeBytes("\r\n");
		}
	}
    //傳bytes
	private void writeByteParams() throws Exception {
		Set<String> keySet = byteParams.keySet();
		for (Iterator<String> it = keySet.iterator(); it.hasNext();) {
			String name = it.next();
			byte[] value = byteParams.get(name);
			ds.writeBytes("--" + boundary + "\r\n");
			ds.writeBytes("Content-Disposition: form-data; name=\"" + name
					+ "\"; filename=\"" + encode(String.valueOf(value.hashCode())) + "\"\r\n");
			ds.writeBytes("Content-Type: " + "image/png" + "\r\n");
			ds.writeBytes("\r\n");
			ds.write(value);
			ds.writeBytes("\r\n");
		}
	}


	// form結尾
	private void paramsEnd() throws Exception {
		ds.writeBytes("--" + boundary + "--" + "\r\n");
		ds.writeBytes("\r\n");
	}
	// encode
    private String encode(String value) throws Exception{
    	return URLEncoder.encode(value, "UTF-8");
    }


}
