//URLfetch time out !!

package ecoliving;

import java.util.HashMap;

import net.HtmlFilter;
import net.ReadUrlByPOST;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@Path("/query_email")
public class query_email {
	@GET
	@Produces(MediaType.TEXT_PLAIN)
	@Path("{c1}")
	public static String go(@PathParam("c1") String cmd) {

		String url = "http://www.czone2.tcg.gov.tw/tp88-1/sys/guest_query_open.cfm";
		HashMap<String, String> forms = new HashMap();
		
		forms.put("sql_str","1=1 and cfcma_email='abc@bbc.com'");
		forms.put("type_id","1");
		forms.put("h_custom","");
		forms.put("s_query","Start");
		
		String res="failed";
		try {
			res = ReadUrlByPOST.doSubmit(url,forms);
			res = HtmlFilter.parseHTMLStr(res);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return res;
	}

	public static void main (String args[])
	{
		String url = "http://www.czone2.tcg.gov.tw/tp88-1/sys/guest_query_open.cfm";
		HashMap<String, String> forms = new HashMap();
		
		forms.put("sql_str","1=1 and cfcma_email='abc@bbc.com'");
		forms.put("type_id","1");
		forms.put("h_custom","");
		forms.put("s_query","Start");
		
		try {
			String res;
			res = ReadUrlByPOST.doSubmit(url,forms);
			res = HtmlFilter.parseHTMLStr(res);
			res = HtmlFilter.delSpace(res);

			System.out.println(res);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	private static void storeResult(String res) {
	}
}