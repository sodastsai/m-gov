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

@Path("/query")
public class query {
	@GET
	@Produces(MediaType.TEXT_PLAIN)
	@Path("{c1}")
	public static String go(@PathParam("c1") String cmd) {
		try {
			CookiesInURL urlcon = new CookiesInURL();
			String str=String.format("http://www.czone.tcg.gov.tw/tp88-1/sys/query_memo_a.cfm?h_id=%s",cmd);
//			System.out.print(str);

			urlcon.setConnection(str);
			urlcon.addCookie("CFID", "264151", true);
			urlcon.addCookie("CFTOKEN", "14172663", true);
			
			String res=HtmlFilter.process(urlcon.getConnection());
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
				line[i+1].substring(line[i+1].indexOf("：") + 1),
				line[i+2], 
				line[i+3] + " "+ line[i+4].substring(line[i+4].indexOf("：") + 1), 
				line[i+5],
				line[i+6] + " "+ line[i+7].substring(line[i+7].indexOf("：") + 1),
				line[i+8],
				images,
				res.substring(res.indexOf("查報來源")));

		// System.out.println(node.getKey());
		GAEDateBase.store(node);
	}
}