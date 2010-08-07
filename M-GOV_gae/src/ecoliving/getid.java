package ecoliving;

import gae.GAENode;
import gae.PMF;

import javax.jdo.PersistenceManager;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@Path("/getid")
public class getid {

	@SuppressWarnings("unchecked")
	@GET
	@Produces(MediaType.TEXT_PLAIN)
	@Path("{c1}")
	public static String query(@PathParam("c1") String id) {

		try {
			GAENode e;
			PersistenceManager pm = PMF.get().getPersistenceManager();
			e = pm.getObjectById(GAENode.class,id);
			System.out.println(e.toJson());
			return e.toJson() + "\ndone\n";

		} catch (Exception e) {
			// TODO: handle exception
//			return myQuery.query(dep, arr);
			return "Not Found!";
		}

		// return Store(table);
	}
}
