package server;

import gae.GAENode;
import gae.GAENodeCase;
import gae.PMF;

import javax.jdo.PersistenceManager;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;


@Path("/view")


public class ViewPhoto {
	@GET
	@Produces({"image/jpeg,image/png"})
	@Path("{c1}/{c2}")
	public static byte[] query(@PathParam("c1") String id,@PathParam("c2") int i) {

		GAENodeCase e;
		PersistenceManager pm = PMF.get().getPersistenceManager();

		try {
			e = pm.getObjectById(GAENodeCase.class, id);
			System.out.println(e.toJson());
			return e.getImage(i);

		} catch (Exception E) {
			// TODO: handle exception
		}
		return "error".getBytes();
	}
	
}
