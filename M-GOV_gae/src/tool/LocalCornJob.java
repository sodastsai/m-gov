package tool;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;

import net.ReadUrl;

public class LocalCornJob {

	public static void main(String args[]) throws IOException {
		String path = "/Users/wildmind5/Desktop/NTU/mobileHCI/summer project/m-gov/trunk/M-GOV_gae/src/out";
		String ids[] = tool.ReadFile.read(path).split("\n");

		for (int i = 0; i < ids.length; i++) {
			while (i + 1 < ids.length && ids[i].equals(ids[i + 1])) {
				i++;
			}
			String strurl = "http://ntu-ecoliving.appspot.com/ecoliving/query_id/" + ids[i];
			if(ids[i].length()<=5)
				continue;
			URL url = new URL(strurl);
			URLConnection connection = url.openConnection();
			BufferedReader reader = new BufferedReader(new InputStreamReader(
					connection.getInputStream(), "big5"));

			System.out.println(strurl);
		}
	}
}
