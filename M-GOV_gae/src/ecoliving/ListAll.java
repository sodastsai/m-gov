package ecoliving;

import java.util.Iterator;
import java.util.List;

import gae.GAENodeSimple;
import gae.PMF;

import javax.jdo.Extent;
import javax.jdo.PersistenceManager;
import javax.jdo.Query;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.json.JSONArray;

@Path("/list")
public class ListAll {

	@SuppressWarnings("unchecked")
	@GET
	@Produces(MediaType.TEXT_PLAIN)
	public static String go() {
		PersistenceManager pm = PMF.get().getPersistenceManager();

		Extent extent = pm.getExtent(GAENodeSimple.class, false);
		Iterator it = extent.iterator();
		
		JSONArray array = new JSONArray();

		GAENodeSimple e;
		while(it.hasNext())
		{
			e = (GAENodeSimple) it.next();
			array.put(e.toJson());
		}
		
		extent.closeAll();
		return array.toString();
	}

}
