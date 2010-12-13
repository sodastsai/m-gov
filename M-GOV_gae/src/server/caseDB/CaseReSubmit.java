package server.caseDB;

import java.util.Iterator;

import gae.GAEDataBase;
import gae.GAENodeCase;
import gae.PMF;

import javax.jdo.Extent;
import javax.jdo.PersistenceManager;

import server.czone.ParseID;

import net.ReadUrlByPOST;

public class CaseReSubmit {
	public static String go(int idex) {


		PersistenceManager pm = PMF.get().getPersistenceManager();

		Extent<GAENodeCase> extent = pm.getExtent(GAENodeCase.class, false);
		Iterator<GAENodeCase> it = extent.iterator();
		
		GAENodeCase e;
		while(it.hasNext())
		{
			e = (GAENodeCase) it.next();
			if(e.getKey().length()!=12)
			{
				GAENodeCase node = e.clone();
				ReadUrlByPOST.doSend(node,"");
				String key = ReadUrlByPOST.doSend(node,"");

				if(key!=null && key.length()==12)
				{
					ParseID.go(key, node.email);
					node.setKey(key);
					GAEDataBase.store(node);
				}
				else
				{
					return ReadUrlByPOST.doSend(node,"debug");
				}
			}
		}
		extent.closeAll();
		return "done";
	}
}
