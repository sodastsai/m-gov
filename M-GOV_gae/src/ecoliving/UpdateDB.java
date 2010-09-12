package ecoliving;

import gae.GAEDateBase;
import gae.GAENode;
import gae.GAENodeSimple;
import gae.PMF;

import java.util.List;

import javax.jdo.JDOHelper;
import javax.jdo.PersistenceManager;
import javax.jdo.Query;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.json.JSONArray;

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
		GAENode e;
		System.out.println(list.size());
		for (GAENodeSimple ob : list) {
			e = pm.getObjectById(GAENode.class, ob.getKey());
			if (ob.date == null) {
				ob.date = e.getDate();
				GAEDateBase.store(ob.clone());
			}
		}
		return "done";
	}

}