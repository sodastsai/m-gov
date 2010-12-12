package server;

import java.net.HttpURLConnection;
import java.net.URL;

import gae.GAENodeCookie;
import gae.PMF;

import javax.jdo.PersistenceManager;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@Path("/get_cookie")

public class GetDBCookie {

	@GET
	@Produces(MediaType.TEXT_PLAIN)

	public static String go()
	{
		GAENodeCookie c1,c2;
		PersistenceManager pm = PMF.get().getPersistenceManager();
		c1 = pm.getObjectById(GAENodeCookie.class,"CFID");
		c2 = pm.getObjectById(GAENodeCookie.class,"CFTOKEN");
		String res = String.format("CFID=%s;CFTOKEN=%s", c1.getValue(),c2.getValue());
		matainCookie(res);
		
		return res;
	}
	
	public static void matainCookie(String cookie_str)
	{
		String strurl = "http://www.czone2.tcg.gov.tw/Gmaps/b_frameset.cfm";
		URL siteUrl;
		HttpURLConnection conn = null;
		
		try {
			siteUrl = new URL(strurl);
			conn = (HttpURLConnection) siteUrl.openConnection();
		} catch(Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		conn.setRequestProperty("Cookie",cookie_str);
		for (int i = 0; i < 10; i++)
			System.out.println(conn.getHeaderFieldKey(i) + " : " + conn.getHeaderField(i));
	}
}
