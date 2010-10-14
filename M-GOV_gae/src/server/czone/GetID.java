package server.czone;

import gae.GAENode;
import gae.GAENodeCase;
import gae.PMF;

import javax.jdo.PersistenceManager;

public class GetID {

	public static String query(String id) {

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

				try {
					GAENodeCase e2 = pm.getObjectById(GAENodeCase.class, id);
					System.out.println(e2.toJson());
					return e2.toJson().toString();
					
				} catch (Exception e3) {
					// TODO: handle exception
					return "{\"error\":\"null\"}";

				}
			}
			// return "Not Found!";
		}
	}
}
