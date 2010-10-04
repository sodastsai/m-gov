package czone;

import gae.GAENodeSimple;
import gae.PMF;

import java.util.Collections;
import java.util.Iterator;
import java.util.List;

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

@Path("/query")
public class QueryAll {

	private static final String CompByKey = null;

	@SuppressWarnings("unchecked")
	@GET
	@Produces(MediaType.TEXT_PLAIN)
	@Path("{c1}/{c2}/{c3}/{c4}")
	public static String go(@PathParam("c1") String method,
			@PathParam("c2") String arg, @PathParam("c3") int st,
			@PathParam("c4") int ed) {
		
		String methods[] = method.split("&"), args[] = arg.split("&");
		String filter = "";
		
		
		PersistenceManager pm = PMF.get().getPersistenceManager();
		Query query = pm.newQuery(GAENodeSimple.class);

		int i,j;
		double x,y = 0,r1,r2 = 0;
		boolean ifcoord=false;
		
		for (i=j=0; i < methods.length; i++, j++) {
			if (i != 0)
				filter += "& ";

			if("coordinates".equals(methods[i])) {
				
				x = Double.parseDouble(args[j]);
				y = Double.parseDouble(args[j+1]);
				r1 = Double.parseDouble(args[j+2]);
				r2 = Double.parseDouble(args[j+3]);
				
				filter += "coordx" + " > " + (x - r1);
				filter += "& ";
				filter += "coordx" + " < " + (x + r2);
				
				j+=3;
				ifcoord = true;
			} else if ("status".equals(methods[i])) {
				
				int k=Integer.parseInt(args[j]);
				if( k < tool.StaticValue.status.length)
					filter += methods[i] + " == '" + tool.StaticValue.status[k] + "'";
			} else if ("region".equals(methods[i])) {
				
				int k=Integer.parseInt(args[j]);
				if( k < tool.StaticValue.region.length)
					filter += methods[i] + " == '" + tool.StaticValue.region[k] + "'";
			} else {
				filter += methods[i] + " == '" + args[j] + "'";
			}

		}
		System.out.println(filter);
		query.setFilter(filter);
		
		List<GAENodeSimple> list = (List<GAENodeSimple>) query.execute();
		Collections.sort(list);
		
 		if (list ==null || list.size() == 0 )
			return "{\"error\":\"null\"}";

 		if(ifcoord)
 			coordyFilter(list,y,r2);
 		
		
		JSONArray array = new JSONArray();
		int index=0;
		for (GAENodeSimple ob : list){ 
			if(index>=st && index<=ed)
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
	
	private static void coordyFilter(List<GAENodeSimple> list,double y,double r)
	{
		double low = y-r;
		double up = y+r;
		double d;
		Iterator<GAENodeSimple> it = list.iterator();
		while(it.hasNext()){				

			d = it.next().coordy;
			if(d<low || d>up)
				it.remove();
			// System.out.print(ob.toJson());
		}
	}

	public class CompByKey implements java.util.Comparator {
		@Override
		public int compare(Object o1, Object o2) {
			// TODO Auto-generated method stub
			return ((GAENodeSimple)o1).getKey().compareTo(((GAENodeSimple)o1).getKey());
		}
	} 
}
