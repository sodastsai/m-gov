package server;

import gae.GAEDataBase;
import gae.GAENode;
import gae.GAENodeCase;
import gae.GAENodeSimple;
import gae.PMF;

import java.util.List;

import javax.jdo.PersistenceManager;
import javax.jdo.Query;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import server.czone.ParseID;


@Path("/update")
public class UpdateDB {

	static String strurl;

	@SuppressWarnings("unchecked")
	@GET
	@Produces(MediaType.TEXT_PLAIN)
	public static String go() {
		PersistenceManager pm = PMF.get().getPersistenceManager();
		Query query = pm.newQuery(GAENodeCase.class);
		
		List<GAENodeCase> list = (List<GAENodeCase>) query.execute();
		System.out.println(list.size());

		pm.close();

		for (GAENodeCase ob : list) {
			ParseID.go(ob.getKey(), ob.email);
		}
		return "done";
	}

}