package cache;

import java.util.Iterator;

import gae.GAENodeCase;
import gae.GAENodeSimple;
import gae.PMF;

import javax.jdo.Extent;
import javax.jdo.PersistenceManager;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

@Path("/case_list")
public class CaseList {

	@SuppressWarnings("unchecked")
	@GET
	@Produces(MediaType.TEXT_PLAIN)
	public static String go() {
		PersistenceManager pm = PMF.get().getPersistenceManager();

		Extent extent = pm.getExtent(GAENodeCase.class, false);
		
		int cnt=0;
		Iterator it = extent.iterator();
		
		JSONArray array = new JSONArray();
		GAENodeCase e;
		while(it.hasNext())
		{
			e = (GAENodeCase) it.next();
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
