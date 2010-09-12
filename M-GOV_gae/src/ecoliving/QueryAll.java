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
		query.setOrdering("key desc");
		query.setRange(Integer.parseInt(st), Integer.parseInt(ed));

		for (int i = 0; i < methods.length; i++) {
			if (i != 0)
				filter += '&';
			if ("coordinates".equals(methods[i])) {
				// TODO
			} else if ("region".equals(methods[i])) {
				// TODO
			} else if ("status".equals(methods[i])) {
				int j=Integer.parseInt(args[i]);
				if(j<tool.StaticValue.status.length)
					filter = methods[i] + " == '" + tool.StaticValue.status[j] + "'";
				
			} else {
				filter = methods[i] + " == '" + args[i] + "'";
			}
		}
		System.out.println(filter);
		query.setFilter(filter);
		List<GAENodeSimple> list = (List<GAENodeSimple>) query.execute();
		if (list.size() == 0)
			return "{\"error\":\"null\"}";

		JSONArray array = new JSONArray();
		for (GAENodeSimple ob : list) {
			array.put(ob.toJson());
			// System.out.print(ob.toJson());
		}
		return array.toString();
	}
}
