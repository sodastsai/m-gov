package ecoliving;

import gae.GAEDataBase;
import gae.GAENodeCookie;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import net.CookiesInURL;

@Path("/set_cookie")

public class SetCookie {

	@GET
	@Produces(MediaType.TEXT_PLAIN)
	@Path("{c1}/{c2}")		

	public static String go(@PathParam("c1") String CFID,@PathParam("c2") String CFTOKEN)
	{
		GAENodeCookie node1 = new GAENodeCookie("CFID",CFID);		
		GAENodeCookie node2 = new GAENodeCookie("CFTOKEN",CFTOKEN);
		
		GAEDataBase.store(node1);
		GAEDataBase.store(node2);
		
		return GetCookie.go();
	}
}
