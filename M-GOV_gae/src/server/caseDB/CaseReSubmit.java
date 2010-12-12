package server.caseDB;

import java.util.Iterator;

import gae.GAEDataBase;
import gae.GAENodeCase;
import gae.PMF;

import javax.jdo.Extent;
import javax.jdo.PersistenceManager;

import net.ReadUrlByPOST;

import server.czone.ParseID;

public class CaseReSubmit {
	public static String go(int idex) {


		PersistenceManager pm = PMF.get().getPersistenceManager();

		Extent<GAENodeCase> extent = pm.getExtent(GAENodeCase.class, false);
		Iterator<GAENodeCase> it = extent.iterator();
		
		GAENodeCase e;
		String res="";
		while(it.hasNext())
		{
			e = (GAENodeCase) it.next();
			if(Integer.parseInt(e.getKey())<0)
			{
				GAENodeCase node = e.clone();
				node.setKey(e.sno);
				GAEDataBase.store(node);
			}
		}
		extent.closeAll();
		return "done";
	}
}
