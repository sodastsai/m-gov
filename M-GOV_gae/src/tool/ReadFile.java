package tool;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class ReadFile {

	public static void main(String args[]) throws IOException {
		System.out
				.println(read(
						"/Users/wildmind5/Desktop/NTU/mobileHCI/summer project/m-gov/trunk/M-GOV_gae/src/admin",
						"big5"));
	}

	public static byte[] fileToBytes(File f) throws Exception {
		FileInputStream in = new FileInputStream(f);
		ByteArrayOutputStream out = new ByteArrayOutputStream();
		byte[] b = new byte[1024];
		int n;
		while ((n = in.read(b)) != -1) {
			out.write(b, 0, n);
		}
		in.close();
		return out.toByteArray();
	}
	
	public static String read(String path, String encode) throws IOException {
		InputStreamReader fis = new InputStreamReader(
				new FileInputStream(path), "big5");
		String r = "";
		int c;
		while ( (c=fis.read())!=-1 ) 
			r += (char)c;
		return r;
	}

	public static String read(String path) {
		FileReader fr = null;
		String res = "";
		try {
			fr = new FileReader(path);
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		BufferedReader bfr = new BufferedReader(fr);

		String str;
		try {
			while ((str = bfr.readLine()) != null) {
				res += str + '\n';
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return res;
	}
}
