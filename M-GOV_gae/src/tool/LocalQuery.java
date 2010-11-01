package tool;

import java.io.IOException;

import java.util.HashMap;

import net.HtmlFilter;
import net.SendPost;

public class LocalQuery {

	static String admin_region[];

	public static void main(String args[]) throws IOException {
		String path = "/Users/wildmind5/Desktop/NTU/mobileHCI/summer project/m-gov/trunk/M-GOV_gae/src/admin";
		String out_path = "/Users/wildmind5/Desktop/NTU/mobileHCI/summer project/m-gov/trunk/M-GOV_gae/src/out";

		admin_region = tool.ReadFile.read(path, "big5").split(",");
		String res = "";
		for (int i = 0; i < admin_region.length; i++) {
			res += query_admin(admin_region[i])+"\n\n";
		}
		WriteFile.write(res, out_path);
	}

	public static String query_admin(String region) {
		System.out.println(region);
		
		String url = "http://www.czone2.tcg.gov.tw/tp88-1/sys/guest_query_open.cfm";
		HashMap<String, String> forms = new HashMap<String, String>();

		region = "'" + region +"'";
		forms.put("sql_str", "1=1 and cfcma_admit=" + region);
		forms.put("type_id", "1");
		forms.put("h_custom", "");
		forms.put("s_query", "Start");

		try {
			String res;
			SendPost sendpost = new SendPost(url);
			sendpost.setTextPatams(forms);
			res = new String(sendpost.send());
			res = HtmlFilter.parseQueryResult(res);
			return res;
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "";
	}

	public static void fun() {
		try {

			// 測試中文轉碼
			String x = "中文訊息";

			System.out.printf("%s:\t%s\n", "String", x);

			System.out.print("BIG5:\t");
			byte y[] = x.getBytes("big5");
			for (int i = 0; i < y.length; i++) {
				System.out.printf("%x ", y[i]);
			}
			System.out.println(y);

			System.out.print("UTF-8:\t");
			byte z[] = x.getBytes("utf-8");
			for (int i = 0; i < z.length; i++) {
				System.out.printf("%x ", z[i]);
			}
			System.out.println(z);

			String v = new String(y);
			System.out.println("BIG5:\t".concat(v));

			String w = new String(z);
			System.out.println("UTF-8:\t".concat(w));

		} catch (java.io.UnsupportedEncodingException e) {
			System.out.println("Error: UnsupportedEncodingException - "
					.concat(e.getMessage()));
			System.exit(1);
		}

	}

}
