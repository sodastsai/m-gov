package cache;

import gae.GAENodeCase;
import gae.PMF;

import javax.jdo.PersistenceManager;
import javax.jdo.Query;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@Path("/case_delete")
public class CaseDelete {
	@GET
	@Produces(MediaType.TEXT_PLAIN)
	public static String go() {
		PersistenceManager pm;
		pm = PMF.get().getPersistenceManager();
		Query query = pm.newQuery(GAENodeCase.class);

		long t = query.deletePersistentAll();
		return String.valueOf(t);
	}
}
