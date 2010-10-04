package czone;

import gae.GAENode;
import gae.PMF;

import javax.jdo.PersistenceManager;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@Path("get_id")
public class GetID {

	@SuppressWarnings("unchecked")
	@GET
	@Produces(MediaType.TEXT_PLAIN)
	@Path("{c1}")
	public static String query(@PathParam("c1") String id) {

		GAENode e;
		PersistenceManager pm = PMF.get().getPersistenceManager();

		try {
			e = pm.getObjectById(GAENode.class, id);
			System.out.println(e.toJson());
			return e.toJson().toString();

		} catch (Exception E) {
			// TODO: handle exception
			try {
				QueryID.go(id);
				e = pm.getObjectById(GAENode.class, id);
				System.out.println(e.toJson());
				return e.toJson().toString();

			} catch (Exception E2) {
				return "{\"error\":\"null\"}";
			}
			// return "Not Found!";
		}
	}
}
