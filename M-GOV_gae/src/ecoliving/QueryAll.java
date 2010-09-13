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

@Path("/query")
public class QueryAll {

	@SuppressWarnings("unchecked")
	@GET
	@Produces(MediaType.TEXT_PLAIN)
	@Path("{c1}/{c2}/{c3}/{c4}")
	public static String go(@PathParam("c1") String method,
			@PathParam("c2") String arg, @PathParam("c3") String st,
			@PathParam("c4") String ed) {
		String methods[] = method.split("&"), args[] = arg.split("&");
		String filter = "";

		PersistenceManager pm = PMF.get().getPersistenceManager();
		Query query = pm.newQuery(GAENodeSimple.class);
		query.setRange(Integer.parseInt(st), Integer.parseInt(ed));

		int i,j;
		for (i=j=0; i < methods.length; i++, j++) {
			if (i != 0)
				filter += "& ";

			if ("coord_mul".equals(methods[i])) {
				double p1 = Double.parseDouble(args[j]) - 0.000001;
				double p2 = Double.parseDouble(args[j]) + 0.000001;
				
				filter += methods[i] + " > " + p1;
				filter += "& ";
				filter += methods[i] + " < " + p2;

			} else if ("status".equals(methods[i])) {
				
				int k=Integer.parseInt(args[j]);
				if( k < tool.StaticValue.status.length)
					filter = methods[i] + " == '" + tool.StaticValue.status[k] + "'";
			} else {
				filter = methods[i] + " == '" + args[j] + "'";
			}

		}
		System.out.println(filter);
		query.setFilter(filter);
//		query.setOrdering("key desc");

		
		List<GAENodeSimple> list = (List<GAENodeSimple>) query.execute();
//		List<GAENodeSimple> list = null;

 		if (list ==null || list.size() == 0 )
			return "{\"error\":\"null\"}";

		JSONArray array = new JSONArray();
		for (GAENodeSimple ob : list) {
			array.put(ob.toJson());
			// System.out.print(ob.toJson());
		}
		return array.toString();
	}
}
