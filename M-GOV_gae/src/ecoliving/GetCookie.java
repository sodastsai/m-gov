package ecoliving;

import gae.GAENodeCookie;
import gae.PMF;

import javax.jdo.PersistenceManager;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;


@Path("/get_cookie")

public class GetCookie {

	@GET
	@Produces(MediaType.TEXT_PLAIN)

	public static String go()
	{
		GAENodeCookie c1,c2;
		PersistenceManager pm = PMF.get().getPersistenceManager();
		c1 = pm.getObjectById(GAENodeCookie.class,"CFID");
		c2 = pm.getObjectById(GAENodeCookie.class,"CFTOKEN");
		
		return c1.getValue() + "  " +c2.getValue();
	}
}
