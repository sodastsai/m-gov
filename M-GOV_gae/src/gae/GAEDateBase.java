package gae;

import javax.jdo.PersistenceManager;

public class GAEDateBase {

	public static void store(GAENode node)
	{
		PersistenceManager pm;
		pm = PMF.get().getPersistenceManager();
		pm.makePersistent(node);	
				
	}
}
