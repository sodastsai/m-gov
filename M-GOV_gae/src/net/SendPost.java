package net;

import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.SocketTimeoutException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import tool.ReadFile;

public class SendPost {
	static String CFTOKEN="35573909",CFID="1122207"; 
	
	URL url;
	HttpURLConnection conn;
	String boundary = "--------httppost123";
	Map<String, String> textParams = new HashMap<String, String>();
	Map<String, byte[]> byteParams = new HashMap<String, byte[]>();

	static String photo_name = "pic";
	DataOutputStream ds;

	public static void main(String[] args) throws Exception {
		SendPost u = new SendPost("http://ntu-ecoliving.appspot.com/case/add");
		u.addByteParameter("photo", ReadFile.fileToBytes(new File("/Users/ggm/Desktop/GET_CZONE_PHOTO.JPG")) );
		u.addTextParameter("h_admit_name", "大安區");
		u.addTextParameter("h_admiv_name", "民輝里");
		u.addTextParameter("email", "aa@bb.cc");
		u.addTextParameter("name", "測試人");
		u.addTextParameter("address", "高雄市");
		u.addTextParameter("typeid", "1110");
		u.addTextParameter("coordx", "123.2");
		u.addTextParameter("coordy", "12.2");
		u.addTextParameter("send", "測試");
		
		byte[] b = u.send();
		String result = new String(b);
		System.out.println(result);

	}
	
	public SendPost(String url) throws Exception {
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

		conn.setRequestProperty("Cookie","CFTOKEN="+CFTOKEN+";CFID="+CFID);
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


	//添加结尾数据
	private void paramsEnd() throws Exception {
		ds.writeBytes("--" + boundary + "--" + "\r\n");
		ds.writeBytes("\r\n");
	}
	// 对包含中文的字符串进行转码，此为UTF-8。服务器那边要进行一次解码
    private String encode(String value) throws Exception{
    	return URLEncoder.encode(value, "UTF-8");
    }


}
