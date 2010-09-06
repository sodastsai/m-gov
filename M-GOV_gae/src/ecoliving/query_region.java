package ecoliving;

import gae.GAENodeSimple;
import gae.PMF;
import java.util.List;

import javax.jdo.PersistenceManager;
import javax.jdo.Query;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.json.JSONArray;

@Path("/query_region")

public class query_region {
	
	@SuppressWarnings("unchecked")
	@GET
	@Produces(MediaType.TEXT_PLAIN)
	@Path("{c1}/{c2}")		

	public static String go(@PathParam("c1") String cmd,@PathParam("c2") String size)
	{
		PersistenceManager pm = PMF.get().getPersistenceManager();
		Query query = pm.newQuery(GAENodeSimple.class);
		query.setFilter("region == regionParam");
		query.setOrdering("key desc");
		query.declareParameters("String regionParam");
		
		List<GAENodeSimple> list = (List<GAENodeSimple>) query.execute(cmd);
		
		JSONArray array = new JSONArray();
		int count = Integer.parseInt(size);
		for(GAENodeSimple ob:list){
			array.put(ob.toJson());
			System.out.print(ob.toJson());
			count--;
			if(count<=0) break;
		}
		return array.toString();
		
		
	}
}
