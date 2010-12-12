package net;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;

import server.GetDBCookie;

public class GetCzoneCookie {

	static String strurl = "http://www.czone2.tcg.gov.tw/Gmaps/b_frameset.cfm";

	public static void main(String args[]) throws IOException {

		System.out.println(go());
	}
	
	@SuppressWarnings("static-access")
	public static String go() throws IOException {
		URL siteUrl = new URL(strurl);
		HttpURLConnection conn = (HttpURLConnection) siteUrl.openConnection();

		conn.setRequestProperty("User-Agent","Mozilla/5.0 (compatible; MSIE 6.0; Windows NT)");
		conn.setRequestProperty("Content-Type","application/x-www-form-urlencoded");
		conn.setDoOutput(true);
		conn.setDoInput(true);
		conn.setDoOutput(true);
		conn.setDoInput(true);
		conn.setInstanceFollowRedirects(true);

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
//		System.out.println("getCookie: " + r);
		return r;
	}
}
