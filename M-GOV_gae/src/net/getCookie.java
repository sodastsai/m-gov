package net;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class getCookie {

	static String strurl = "http://www.czone.tcg.gov.tw/tp88-1/sys/begin_frameset.cfm";

	public static void main(String args[]) throws IOException {

		System.out.print(process());
	}

	public static String process() throws IOException {
		URL siteUrl = new URL(strurl);
		HttpURLConnection conn = (HttpURLConnection) siteUrl.openConnection();

		conn.setRequestProperty("User-Agent","Mozilla/5.0 (compatible; MSIE 6.0; Windows NT)");
		conn.setRequestProperty("Content-Type","application/x-www-form-urlencoded");
		conn.setDoOutput(true);
		conn.setDoInput(true);
		conn.setDoOutput(true);
		conn.setDoInput(true);
		conn.setInstanceFollowRedirects(true);
		conn.setFollowRedirects(true);

		BufferedReader in = new BufferedReader(new InputStreamReader(conn
				.getInputStream(), "big5"));

		String r = "", field;
		for (int i = 0; conn.getHeaderField(i) != null; i++) {
			if ("Set-Cookie".equalsIgnoreCase(conn.getHeaderFieldKey(i))) {
				field = conn.getHeaderField(i);
				int id = field.indexOf(";");

				if (id >= 0) {
					if (r != "")
						r += ';';
					r += field.substring(0, id);
				}
			}
		}
		System.out.println("getCookie: " + r);
		return r;
	}
}
