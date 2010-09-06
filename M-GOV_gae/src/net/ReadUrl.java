package net;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;

public class ReadUrl {

	public static void main(String[] args) throws UnsupportedEncodingException,
			IOException {
		String strurl = "http://www.czone.tcg.gov.tw/tp88-1/sys/query_memo_a.cfm?h_id=09908-521175";
		URL siteUrl = new URL(strurl);
		HttpURLConnection conn = (HttpURLConnection) siteUrl.openConnection();
		conn.setRequestProperty("Cookie","CFID=316970;CFTOKEN=23019116");
		BufferedReader in = new BufferedReader(new InputStreamReader(conn
				.getInputStream(), "big5"));
		String line, res = "";
		while ((line = in.readLine()) != null) {
			res += line + "\n";
			// System.out.println(line);
		}
		in.close();
		System.out.println("context: " + res);

		for (int i = 0; i < 15; i++)
			System.out.println(conn.getHeaderFieldKey(i) + " : "
					+ conn.getHeaderField(i));

	}

	public static String process(String strUrl)
			throws UnsupportedEncodingException, IOException {
		URL url = new URL(strUrl);
		URLConnection connection = url.openConnection();
		return process(connection);
	}

	public static String process(URLConnection connection)
			throws UnsupportedEncodingException, IOException {

		String line;
		StringBuilder builder = new StringBuilder();

		BufferedReader reader = new BufferedReader(new InputStreamReader(
				connection.getInputStream(), "big5"));

		while ((line = reader.readLine()) != null) {
			builder.append(line + "\n");
		}

		String response = builder.toString();
		return response;
	}

}
