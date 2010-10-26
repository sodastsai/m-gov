package net;

import gae.GAENodeCase;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import tool.TypeFilter;

public class ReadUrlByPOST {

	static String add_caseURL = "http://www.czone.tcg.gov.tw/tp95-4/sys/add_case.cfm";
	static String preview_caseURL = "http://www.czone.tcg.gov.tw/tp95-4/sys/preview_case.cfm";
	
	public static void main(String args[]) {

		HashMap<String, String> forms = new HashMap<String, String>();

		String unitStr="4209";
		
		forms.put("sno","09908-521171");
		forms.put("unit" ,"區民政課");
		forms.put("pic_check" ,"1");
		forms.put("h_item1" ,TypeFilter.Id2Type1(unitStr));
		forms.put("h_item2" ,TypeFilter.Id2Type2(unitStr));
		forms.put("h_admit_name" ,"大安區");
		forms.put("h_admiv_name" ,"民輝里");
		forms.put("h_summary" ,"cc");
		forms.put("h_memo" ,"建議事項：");
		forms.put("pt_name" ,"");
		forms.put("h_pname" ,"某人");
		forms.put("h_punit" ,"民眾");
		forms.put("h_ptel" ,"");
		forms.put("h_pfax" ,"");
		forms.put("h_pemail" ,"example@gmail.com");
		forms.put("h_x1" ,"121.524838262");
		forms.put("h_y1" ,"25.0461800482");
		forms.put("h_width" ,"0");
		forms.put("h_ddx" ,"121.524838262");
		forms.put("h_ddy" ,"25.0461800482");
		forms.put("input_type" ,"pt");
		forms.put("case_type" ,"0");
		
		forms.put("img_name" ,"");
		forms.put("img_name1" ,"");
		forms.put("img_name2" ,"");
		
		forms.put("h_pic" ,"");
		forms.put("h_pic1" ,"");
		forms.put("h_pic2" ,"");

		
		forms.put("h_per" ,"0");
		forms.put("h_item4" ,"");
		
		try {
			String preRes = doSubmit(add_caseURL, forms);
			System.out.println(preRes);
			System.out.println(getSno(preRes)+"  "+getUnit(preRes));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	@SuppressWarnings("static-access")
	public static String doSubmit(String url, HashMap<String, String> data)
			throws Exception {
		URL siteUrl = new URL(url);
		HttpURLConnection conn = (HttpURLConnection) siteUrl.openConnection();

		conn.setRequestMethod("POST");
		conn.setDoOutput(true);
		conn.setDoInput(true);
		conn.setDoOutput(true);
		conn.setDoInput(true);
		conn.setInstanceFollowRedirects(true);
//		conn.setFollowRedirects(true);
		conn.setRequestProperty("User-Agent",
				"Mozilla/5.0 (compatible; MSIE 6.0; Windows NT)");
		conn.setRequestProperty("Content-Type",
				"application/x-www-form-urlencoded");

		String cookie = "CFID=" + CookiesInURL.CFID + ";CFTOKEN="
				+ CookiesInURL.CFTOKEN;
		conn.setRequestProperty("Cookie", cookie);

		DataOutputStream out = new DataOutputStream(conn.getOutputStream());

		Set<String> keys = data.keySet();
		Iterator<String> keyIter = keys.iterator();
		String content = "";
		for (int i = 0; keyIter.hasNext(); i++) {
			Object key = keyIter.next();
			if (i != 0) {
				content += "&";
			}
			content += key + "=" + URLEncoder.encode(data.get(key), "big5");
		}
		out.writeBytes(content);
		out.flush();
		out.close();
		String line = "", res = "";
		try {
			/*
			 * for (int i = 0; i< 15; i++)
			 * System.out.println(conn.getHeaderField(i));
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

	// 藉由預覽 preview_case 先取得案件編號 分析html內容取得sno
	public static String getSno(String htmlcontext){
		try {
			
			String res = "";
			
			Matcher matcher;
			matcher = Pattern.compile("<.*input type.*sno.*?>", Pattern.MULTILINE).matcher(htmlcontext);
			while (matcher.find())
				res = matcher.group();
			matcher = Pattern.compile("[0-9]{5}-[0-9]{6}", Pattern.MULTILINE).matcher(res);
			res = "";

			for(res = "";matcher.find();)
				res = matcher.group();
			return res;

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}

	// 藉由預覽 preview_case 先取得權責單位 分析html內容取得unit
	public static String getUnit(String htmlcontext){
		try {
			String res = "";
			
			Matcher matcher;
			
			matcher = Pattern.compile("<input type(.*?)name=\"unit\".*?>", Pattern.MULTILINE).matcher(htmlcontext);
			while (matcher.find())
				res += matcher.group();
			matcher = Pattern.compile("[^ <=\">|\\w]", Pattern.MULTILINE).matcher(res);

			for(res = "";matcher.find();)
				res += matcher.group();
			return res;

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}

	
	public static void doSend(GAENodeCase node) {
		// TODO Auto-generated method stub
		
		HashMap<String, String> forms = new HashMap<String, String>();

		forms.put("sno","09908-521171");
		forms.put("unit" ,"區民政課");
		forms.put("pic_check" ,"0");
		forms.put("h_item1" ,TypeFilter.Id2Type1(node.typeid));
		forms.put("h_item2" ,TypeFilter.Id2Type2(node.typeid));
		forms.put("h_admit_name" ,node.h_admit_name);
		forms.put("h_admiv_name" ,node.h_admiv_name);
		forms.put("h_summary" ,node.h_summary);
		forms.put("h_memo" ,"地點:"+node.address);
		forms.put("pt_name" ,"");
		forms.put("h_pname" ,node.name);
		forms.put("h_punit" ,"民眾");
		forms.put("h_ptel" ,"");
		forms.put("h_pfax" ,"");
		forms.put("h_pemail" ,node.email);
		forms.put("h_x1" ,String.valueOf(node.coordx));
		forms.put("h_y1" ,String.valueOf(node.coordy));
		forms.put("h_width" ,"0");
		forms.put("h_ddx" ,String.valueOf(node.coordx));
		forms.put("h_ddy" ,String.valueOf(node.coordy));
		forms.put("input_type" ,"pt");
		forms.put("case_type" ,"0");
		
		forms.put("img_name" ,"");
		forms.put("img_name1" ,"");
		forms.put("img_name2" ,"");
		
		forms.put("h_pic" ,"");
		forms.put("h_pic1" ,"");
		forms.put("h_pic2" ,"");

		
		forms.put("h_per" ,"0");
		forms.put("h_item4" ,"");

		try {
			String preRes = doSubmit(preview_caseURL, forms);
			//preview取得sno和unit後送出
			node.sno = getSno(preRes);
			node.setKey(node.sno);
			node.unit = getUnit(preRes);
			
			forms.put("sno",node.sno);
			forms.put("unit",node.unit);

			doSubmit(add_caseURL, forms);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
}
