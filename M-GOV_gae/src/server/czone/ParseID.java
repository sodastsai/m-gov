package server.czone;

import gae.GAEDataBase;
import gae.GAENode;
import gae.GAENodeSimple;

import net.HtmlFilter;

import tool.TypeFilter;

public class ParseID {

	static String strurl ;
	static String email ;
	
	public static String go(String cmd,String _email){
		email = _email;
		return go(cmd);
	}
	
	public static String go(String cmd) {
		try {
			strurl=String.format("http://www.czone2.tcg.gov.tw/GMaps/desc.cfm?sn=%s",cmd);

			String res,res2;
			res = net.ReadUrl.process(strurl,"utf-8");
			System.out.println(res);

			res2= net.HtmlFilter.praseCoordinates(res);
			res = HtmlFilter.parseHTMLStr(res);
			res = HtmlFilter.delSpace(res);
			
			if(res.contains("未經授權無法存取此頁"))
				return "未經授權無法存取此頁";
			if(res.contains("資料已刪除"))
				return "資料已刪除";			
			if(res.contains("查報案件")==false)
				return "未知錯誤" + res;
			
			storeResult(res,res2);
			return res + "\n" + res2;

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return "failed" + e.toString();
		}
	}

	private static void storeResult(String res,String res2) {
		String line[] = res.split("\n");
		String images[] =null;
		int i,j,k;
		for (i = 0; !("查報案件".equals(line[i])) && i<line.length; i++);
		
		if(i==line.length) 
			return ;
		
		for (j = i; j<line.length && !("案情補述相關照片：".equals(line[j])) ; j++);
		for (k = j; k<line.length && !("處理狀態一覽表".equals(line[k])) ; k++);

		images = new String[k-j-1];
		for (int p=j+1;p<k;p++){
			images[p-j-1] = line[p];
			System.out.println(images[p-j-1]);
		}
		
		GAENode node = new GAENode(
				afterColon(line[i+1]),
				afterColon(line[i+2]), 
				afterColon(line[i+3]) + " "+ afterColon(line[i+4]), 
				afterColon(line[i+5]),
				afterColon(line[i+6]),
				TypeFilter.Type22Id(afterColon(line[i+6])),
				afterColon(line[i+7]),
				parseAddress(line[i+8]),
				res2,
				afterColon(line[i+12]),
				images,
				res.substring(res.indexOf("查報來源")));

		GAENodeSimple node2 = new GAENodeSimple(
				afterColon(line[i+1]),
				TypeFilter.Type22Id(afterColon(line[i+6])),
				afterColon(line[i+2]),
				res2,
				afterColon(line[i+12]),
				parseAddress(line[i+8]),
				email
		);
		
		// System.out.println(node.getKey());
		GAEDataBase.store(node);
		GAEDataBase.store(node2);
	}
	
	private static String afterColon(String str){
		return str.substring(str.indexOf("：")+1);
	}
	
	private static String parseAddress(String str){
		str = afterColon(str);
		int st = 0,ed = str.length();
	
		if(str.contains("地點:"))
			st = str.indexOf("地點:")+3;
		
		if(str.contains("建議事項"))
			ed = str.indexOf("建議事項");
		else if(str.contains("號"))
			ed = str.indexOf("號")+1;
		else if(str.contains("弄"))
			ed = str.indexOf("弄")+1;
		
		return str.substring(st,ed);
	}
	
}