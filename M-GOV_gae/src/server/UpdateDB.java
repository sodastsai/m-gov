package server;

import gae.GAEDataBase;
import gae.GAENode;
import gae.GAENodeSimple;
import gae.PMF;

import java.util.List;

import javax.jdo.PersistenceManager;
import javax.jdo.Query;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;


@Path("/update")
public class UpdateDB {

	static String strurl;

	@SuppressWarnings("unchecked")
	@GET
	@Produces(MediaType.TEXT_PLAIN)
	public static String go() {
		PersistenceManager pm = PMF.get().getPersistenceManager();
		Query query = pm.newQuery(GAENodeSimple.class);
		
		List<GAENodeSimple> list = (List<GAENodeSimple>) query.execute();
		System.out.println(list.size());

		pm.close();

		for (GAENodeSimple ob : list) {
			if (ob.address == null || ob.address.length()<=2) {

				GAENodeSimple e = ob;
				
				pm = PMF.get().getPersistenceManager();
				GAENode e2 = pm.getObjectById(GAENode.class, e.getKey());
				e.address = e2.getAdd();
				pm.close();
				
				GAEDataBase.store(e);
			}
		}
		return "done";
	}

}