package net;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;

public class ReadUrlByPOST {

	public static void main(String args[]) {
		String url = "http://www.czone.tcg.gov.tw/tp88-1/sys/guest_query_open.cfm";
		HashMap<String, String> forms = new HashMap();
		forms.put("sql_str", "1=1 and cfcma_email='abc@bbc.com'");
		forms.put("type_id", "1");
		forms.put("h_custom", "");
		forms.put("s_query", "Start");

		try {
			doSubmit(url, forms);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	public static String doSubmit(String url, HashMap<String, String> data)
			throws Exception {
		URL siteUrl = new URL(url);
		HttpURLConnection conn = (HttpURLConnection) siteUrl.openConnection();
		conn.setRequestMethod("POST");
		conn.setDoOutput(true);
		conn.setDoInput(true);
		conn.setRequestProperty("Cookie", "CFTOKEN=14172663; CFID=264151");

		DataOutputStream out = new DataOutputStream(conn.getOutputStream());

		Set keys = data.keySet();
		Iterator keyIter = keys.iterator();
		String content = "";
		for (int i = 0; keyIter.hasNext(); i++) {
			Object key = keyIter.next();
			if (i != 0) {
				content += "&";
			}
			content += key + "=" + URLEncoder.encode(data.get(key), "UTF-8");
		}
		// System.out.println(content);
		out.writeBytes(content);
		out.flush();
		out.close();
		String line="",res="";
		try {
			conn.setReadTimeout(10);
			
			BufferedReader in = new BufferedReader(new InputStreamReader(conn
					.getInputStream(), "big5"));
			while ((line = in.readLine()) != null) {
				res += line + "\n";
				// System.out.println(line);
			}
			in.close();

		} catch (Exception e) {
//			e.printStackTrace();
			System.out.println(e);
		}

		return res;
	}

}
