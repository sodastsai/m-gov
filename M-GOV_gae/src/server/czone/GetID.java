package server.czone;

import gae.GAENode;
import gae.PMF;

import javax.jdo.PersistenceManager;
import javax.ws.rs.PathParam;

public class GetID {

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
				ParseID.go(id);
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
