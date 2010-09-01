package net;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;

public class ReadUrl {

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
			builder.append(line+"\n");
		}

		String response = builder.toString();
		return response;
	}

}
