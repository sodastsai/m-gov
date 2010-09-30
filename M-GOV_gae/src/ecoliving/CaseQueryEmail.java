package ecoliving;

import java.util.List;

import gae.GAENodeCase;
import gae.PMF;

import javax.jdo.PersistenceManager;
import javax.jdo.Query;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

@Path("/case_queryemail")
public class CaseQueryEmail {

	static String strurl ;

	@SuppressWarnings("unchecked")
	@GET
	@Produces(MediaType.TEXT_PLAIN)
	@Path("{c1}")		
	public static String go(@PathParam("c1") String cmd) {

		System.out.print("hi");
		
		
		PersistenceManager pm = PMF.get().getPersistenceManager();
		Query query = pm.newQuery(GAENodeCase.class);

		query.setFilter("h_pemail == '" + cmd +"'");
		
		List<GAENodeCase> list = (List<GAENodeCase>) query.execute();
		
 		if (list ==null || list.size() == 0 )
			return "{\"error\":\"null\"}";
		
		JSONArray array = new JSONArray();
		int index=0;
		for (GAENodeCase ob : list){ 
				array.put(ob.toJson());
			index++;
		}
		
		JSONObject res = new JSONObject();

		try {
			res.put("length",list.size());
			res.put("result",array);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return res.toString();
	}	
}