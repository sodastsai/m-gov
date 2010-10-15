package tw.edu.ntu.mgov.net;


import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Iterator;

import android.content.Context;
import android.net.Uri;
import android.util.Log;

import tw.edu.ntu.mgov.gae.GAECase;

public class ReadUrlByPOST {

	public static void main(String args[]) {

		String url = "http://www.czone.tcg.gov.tw/tp88-1/sys/begin.cfm";
		HashMap<String, String> forms = new HashMap<String, String>();

		forms.put("LOGIN", "guest");
		forms.put("PASSWORD", "guest");

		try {
//			String res = doSubmit(url, forms);
//			System.out.println(res);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	public static String doSubmit(String url, GAECase data,Context context)
			throws Exception {

		String path[] = data.getImage();
		byte[] bytes = null;
		if(path!=null){
			String uri=path[0];
			
			InputStream is = context.getContentResolver().openInputStream(Uri.parse(uri));
			long size = context.getContentResolver().openFileDescriptor(Uri.parse(uri), "r").getStatSize();
			bytes = new byte[(int) size];
			is.read(bytes, 0, (int) size);
			
			Log.d("NSLog", bytes + "");
		}
		
		
		
		URL siteUrl = new URL(url);
		HttpURLConnection conn = (HttpURLConnection) siteUrl.openConnection();

		conn.setRequestMethod("POST");
		conn.setDoOutput(true);
		conn.setDoInput(true);
		conn.setDoOutput(true);
		conn.setDoInput(true);
		conn.setRequestProperty("User-Agent",
				"Mozilla/5.0 (compatible; MSIE 6.0; Windows NT)");
		conn.setRequestProperty("Content-Type",
				"application/x-www-form-urlencoded");

		DataOutputStream out = new DataOutputStream(conn.getOutputStream());

		
		Iterator<String> it = data.keySet().iterator();
		String content="";		
		boolean begin=true;
		
		while(it.hasNext()){
			String key = it.next();
			Object val = data.get(key);
			
			if(val.equals(String.class) )
			{
				if(begin==false)
					content +="&";
			
				content += key + "=" + URLEncoder.encode( (String) val, "big5");
				begin = false;
			}
			else if(val.equals(byte[].class) ) //image
			{
				
			}
		}
		
		out.writeBytes(content);
		out.flush();
		out.close();
		String line = "", res = "";
		try {

/*
			for (int i = 0; i< 15; i++)
				System.out.println(conn.getHeaderField(i));
*/
			BufferedReader in = new BufferedReader(new InputStreamReader(conn
					.getInputStream(), "big5"));
			while ((line = in.readLine()) != null) {
				res += line + "\n";
			}
			in.close();
						

		} catch (Exception e) {
			e.printStackTrace();
			// System.out.println(e);
		}

		return res;
	}

}
