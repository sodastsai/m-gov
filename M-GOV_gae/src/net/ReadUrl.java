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
		String strurl = "http://www.czone2.tcg.gov.tw/Gmaps/b_frameset.cfm";
		URL siteUrl = new URL(strurl);
		HttpURLConnection conn = (HttpURLConnection) siteUrl.openConnection();
		conn.setRequestProperty("Cookie","CFID=1147249;CFTOKEN=46250381");
		String res = process(strurl,"utf-8");
		res = HtmlFilter.delSpace(res);
		System.out.println("context: " + res);

		for (int i = 0; i < 15; i++)
			System.out.println(conn.getHeaderFieldKey(i) + " : "
					+ conn.getHeaderField(i));
	}

	public static String process(String strUrl,String encode)
			throws UnsupportedEncodingException, IOException {
		URL url = new URL(strUrl);
		URLConnection connection = url.openConnection();
		return process(connection,encode);
	}

	public static String process(URLConnection connection,String encode)
			throws UnsupportedEncodingException, IOException {

		String line;
		StringBuilder builder = new StringBuilder();

		BufferedReader reader = new BufferedReader(new InputStreamReader(
				connection.getInputStream(), encode));

		while ((line = reader.readLine()) != null) {
			builder.append(line + "\n");
		}
		String response = builder.toString();

		reader.close();
		return response;
	}

}
