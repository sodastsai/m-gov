package tool;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

public class SenpImageLocal {

	/** */
	/**
	 * 上传方法 返回上传完毕的文件名 *
	 */
	public String upload(File f) {
		try {
			// 服务器IP(这里是从属性文件中读取出来的)
			String hostip = "http://ggm-test.appspot.com/";
			URL url = new URL("http://" + hostip + "/oxServer/ReceiveServlet");

			HttpURLConnection uc = (HttpURLConnection) url.openConnection();
			// 上传图片的一些参数设置
			uc
					.setRequestProperty(
							"Accept",
							"image/gif,   image/x-xbitmap,   image/jpeg,   image/pjpeg,   application/vnd.ms-excel,   application/vnd.ms-powerpoint,   application/msword,   application/x-shockwave-flash,   application/x-quickviewplus,   */*");
			uc.setRequestProperty("Accept-Language", "zh-cn");
			uc
					.setRequestProperty("Content-type",
							"multipart/form-data;   boundary=---------------------------7d318fd100112");
			uc.setRequestProperty("Accept-Encoding", "gzip,   deflate");
			uc
					.setRequestProperty("User-Agent",
							"Mozilla/4.0   (compatible;   MSIE   6.0;   Windows   NT   5.1)");
			uc.setRequestProperty("Connection", "Keep-Alive");
			uc.setDoOutput(true);
			uc.setUseCaches(true);

			// 读取文件流
			int size = (int) f.length();
			byte[] data = new byte[size];
			FileInputStream fis = new FileInputStream(f);
			OutputStream out = uc.getOutputStream();
			fis.read(data, 0, size);
			// 写入文件名
			out.write(f.getName().trim().getBytes());
			// 写入分隔符
			out.write('|');
			// 写入图片流
			out.write(data);
			out.flush();
			out.close();
			fis.close();

			// 读取响应数据
			int code = uc.getResponseCode();
			String sCurrentLine = "";
			// 存放响应结果
			String sTotalString = "";
			if (code == 200) {
				java.io.InputStream is = uc.getInputStream();
				BufferedReader reader = new BufferedReader(
						new InputStreamReader(is));
				while ((sCurrentLine = reader.readLine()) != null)
					if (sCurrentLine.length() > 0)
						sTotalString = sTotalString + sCurrentLine.trim();
			} else {
				sTotalString = "远程服务器连接失败,错误代码:" + code;
			}
			return sTotalString;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

}
