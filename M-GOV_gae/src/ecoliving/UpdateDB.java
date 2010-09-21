package ecoliving;

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

//		for (GAENodeSimple ob : list) {
//			GAENodeSimple e;
//			if (ob.coord_mul == 0) {
//				ob.coord_mul = ob.coordinates[0] * ob.coordinates[1];
//				GAEDataBase.store(ob.clone());
//			}
//		}
		return "done";
	}

}