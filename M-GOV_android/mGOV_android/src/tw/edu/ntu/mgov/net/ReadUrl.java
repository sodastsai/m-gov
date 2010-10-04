package tw.edu.ntu.mgov.net;

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
		String strurl = "http://www.nownews.com.tw/2009/12/15/334-2546270.htm";
		URL siteUrl = new URL(strurl);
		HttpURLConnection conn = (HttpURLConnection) siteUrl.openConnection();
//		conn.setRequestProperty("Cookie","CFID=316970;CFTOKEN=23019116");
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
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		String response = builder.toString();
		return response;
	}

}
