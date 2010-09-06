package tool;


import java.io.*;

public class WriteFile {

	public static void write(String in,String file) throws IOException {

		FileWriter fw = new FileWriter(file);
		BufferedWriter bfw = new BufferedWriter(fw);


//		in = new String(in.getBytes("GBK"));

		// String textcontent=new
		// String(request.getParameter("boy").getBytes("UTF-8")).trim();
		// String textcontent=new
		// String(request.getParameter("boy").getBytes("GBK")).trim();

		bfw.write(in);
		bfw.flush();
		fw.close();
	}
}