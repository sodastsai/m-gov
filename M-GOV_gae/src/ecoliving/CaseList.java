package ecoliving;

import java.util.Iterator;

import gae.GAENodeCase;
import gae.PMF;

import javax.jdo.Extent;
import javax.jdo.PersistenceManager;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@Path("/case_list")
public class CaseList {

	@SuppressWarnings("unchecked")
	@GET
	@Produces(MediaType.TEXT_PLAIN)
	public static String go() {
		PersistenceManager pm = PMF.get().getPersistenceManager();

		Extent extent = pm.getExtent(GAENodeCase.class, false);
		
		int cnt=0;
		Iterator it = extent.iterator();
		
		GAENodeCase e;
		
		String res = "";
		while(it.hasNext())
		{
			e = (GAENodeCase) it.next();
			res += e.toJson().toString()+"\n";
			cnt ++ ;
		}
		extent.closeAll();
		
		return res.toString();
	}

}
