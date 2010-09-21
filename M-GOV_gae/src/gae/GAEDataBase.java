package gae;

import javax.jdo.PersistenceManager;

public class GAEDataBase {

	public static void store(Object ob) {
		PersistenceManager pm;
		pm = PMF.get().getPersistenceManager();
		pm.makePersistent(ob);
		pm.close();
	}

}
