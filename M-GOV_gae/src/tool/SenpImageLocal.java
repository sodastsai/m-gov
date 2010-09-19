package tool;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;

import net.HtmlFilter;
import net.ReadUrlByPOST;

public class SenpImageLocal {

	/** */
	/**
	 * 上传方法 返回上传完毕的文件名 *
	 */
	
	public static void main(String args[])
	{		
		upload();
		System.out.println("done");
	}
	
	public static void test()
	{
		String url = "http://ggm-test.appspot.com/photo?method=upload";
		HashMap<String, String> forms = new HashMap<String, String>();
		forms.put("photo", "test");
		try {
			String res;
			res = ReadUrlByPOST.doSubmit(url, forms);
			res = HtmlFilter.parseQueryResult(res);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public static String upload() {
		try {
			File f = new File("/Users/wildmind5/Desktop/NTU/mobileHCI/summer project/m-gov/trunk/M-GOV_gae/war/image.png");
			
			// 服务器IP(这里是从属性文件中读取出来的)
			String strurl = "http://ggm-test.appspot.com/photo?method=upload";
			URL url = new URL(strurl);
			HttpURLConnection uc = (HttpURLConnection) url.openConnection();
			// 上传图片的一些参数设置
			uc.setRequestProperty("Accept","image/gif,image/x-xbitmap,image/jpeg,image/pjpeg,application/vnd.ms-excel,application/vnd.ms-powerpoint,application/msword,application/x-shockwave-flash,application/x-quickviewplus, */*");
			uc.setRequestProperty("Accept-Language", "zh-TW");
			uc.setRequestProperty("Content-type","multipart/form-data");
			uc.setRequestProperty("Accept-Encoding", "gzip,   deflate");
			uc.setRequestProperty("User-Agent","Mozilla/4.0 (compatible;MSIE6.0;WindowsNT5.1)");
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
			System.out.println(data);
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
				sTotalString = "連接失敗，錯誤代碼：" + code;
			}
			return sTotalString;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

}
