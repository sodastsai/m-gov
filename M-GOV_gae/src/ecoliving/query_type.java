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

@Path("/query_type")

public class query_type {

	@SuppressWarnings("unchecked")
	@GET
	@Produces(MediaType.TEXT_PLAIN)
	@Path("{c1}")		

	public static String go(@PathParam("c1") String cmd)
	{
		PersistenceManager pm = PMF.get().getPersistenceManager();
		Query query = pm.newQuery(GAENodeSimple.class);
		query.setFilter("typeid == typeidParam");
		query.setOrdering("key desc");
		query.declareParameters("String typeidParam");
		
		List<GAENodeSimple> list = (List<GAENodeSimple>) query.execute("1110");
		
		JSONArray array = new JSONArray();
		
		for(GAENodeSimple ob:list){
			array.put(ob.toJson());
			System.out.print(ob.toJson());
		}
		return array.toString();
		
		
	}
}
