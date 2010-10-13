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
