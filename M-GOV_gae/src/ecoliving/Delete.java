package ecoliving;

import gae.GAENode;
import gae.GAENodeSimple;
import gae.PMF;

import javax.jdo.PersistenceManager;
import javax.jdo.Query;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@Path("ecoliving")
public class Delete {
	@GET
	@Produces(MediaType.TEXT_PLAIN)
	@Path("delete")
	public static String doGet() {
		PersistenceManager pm;
		pm = PMF.get().getPersistenceManager();
		Query query = pm.newQuery(GAENode.class);
		Query query2 = pm.newQuery(GAENodeSimple.class);

		long t = query.deletePersistentAll() + query2.deletePersistentAll();
		return String.valueOf(t);
	}
}
