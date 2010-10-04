package server.czone;

import java.util.Iterator;

import gae.GAENodeSimple;
import gae.PMF;

import javax.jdo.Extent;
import javax.jdo.PersistenceManager;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class List {

	@SuppressWarnings("unchecked")
	public static String go() {
		PersistenceManager pm = PMF.get().getPersistenceManager();

		Extent extent = pm.getExtent(GAENodeSimple.class, false);
		
		int cnt=0;
		Iterator it = extent.iterator();
		
		JSONArray array = new JSONArray();
		GAENodeSimple e;
		while(it.hasNext())
		{
			e = (GAENodeSimple) it.next();
			array.put(e.toJson());
			cnt ++ ;
		}
		extent.closeAll();
		
		JSONObject res = new JSONObject();
		
		try {
			res.put("result",array);
			res.put("length",array.length());
		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		return res.toString();
	}

}
