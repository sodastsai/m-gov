package ecoliving;


import gae.GAEDateBase;
import gae.GAENode;

import net.CookiesInURL;
import net.HtmlFilter;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import tool.TypeFilter;

import com.sun.xml.internal.rngom.binary.AfterPattern;

@Path("/query_id")
public class query_id {
	@GET
	@Produces(MediaType.TEXT_PLAIN)
	@Path("{c1}")
	public static String go(@PathParam("c1") String cmd) {
		try {
			CookiesInURL urlcon = new CookiesInURL();
			String str=String.format("http://www.czone.tcg.gov.tw/tp88-1/sys/query_memo_a.cfm?h_id=%s",cmd);
//			System.out.print(str);

			urlcon.setConnection(str);
			urlcon.addCookie("CFID", "280040", true);
			urlcon.addCookie("CFTOKEN", "27012071", true);

			
			String res="";
			res = HtmlFilter.processByURL(urlcon.getConnection());
			res = HtmlFilter.delTrash(res);
			
			if(res.contains("查報案件")==false)
				return "Not Found.";
			
			storeResult(res);
			return res;
			// return Store(table);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return "failed" + e.toString();
		}
	}

	private static void storeResult(String res) {
		String line[] = res.split("\n");
		String images[] =null;
		int i,j,k;
		for (i = 0; !("查報案件".equals(line[i])) && i<line.length; i++);
		
		if(i==line.length) 
			return ;
		
		for (j = i; j<line.length && !("案情補述相關照片：".equals(line[j])) ; j++);
		for (k = j; k<line.length && !("處理狀態一覽表".equals(line[k])) ; k++);

		images = new String[k-j-1];
		for (int p=j+1;p<k;p++)
			images[p-j-1] = line[p];
		
		GAENode node = new GAENode(
				afterColon(line[i+1]),
				afterColon(line[i+2]), 
				afterColon(line[i+3]) + " "+ afterColon(line[i+4]), 
				afterColon(line[i+5]),
				afterColon(line[i+6]),
				TypeFilter.process(line[i+6]),
				afterColon(line[i+7]),
				parseAddress(line[i+8]),
				afterColon(line[i+12]),
				images,
				res.substring(res.indexOf("查報來源")));

		// System.out.println(node.getKey());
		GAEDateBase.store(node);
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