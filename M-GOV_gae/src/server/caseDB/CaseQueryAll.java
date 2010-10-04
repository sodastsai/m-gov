package server.caseDB;

import gae.GAENodeCase;

import gae.PMF;

import java.util.Collections;
import java.util.Iterator;
import java.util.List;

import javax.jdo.PersistenceManager;
import javax.jdo.Query;
import javax.ws.rs.Path;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

@Path("/query")
public class CaseQueryAll {

	@SuppressWarnings("unchecked")
	public static String go(String method,String arg,int st,int ed) {
		
		String methods[] = method.split("&"), args[] = arg.split("&");
		String filter = "";
		
		
		PersistenceManager pm = PMF.get().getPersistenceManager();
		Query query = pm.newQuery(GAENodeCase.class);

		int i,j;
		double x,y = 0,r1,r2 = 0;
		
		boolean ifcoord=false;
		int ifstatus=-2;
		
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
				ifstatus=Integer.parseInt(args[j]);
			} else if ("region".equals(methods[i])) {
				
				int k=Integer.parseInt(args[j]);
				if( k < tool.StaticValue.region.length)
					filter += methods[i] + " == '" + tool.StaticValue.region[k] + "'";
			} else {
				filter += methods[i] + " == '" + args[j] + "'";
			}

		}
		System.out.println(filter);
		if(!("".equals(filter)))
			query.setFilter(filter);
		
		List<GAENodeCase> list = (List<GAENodeCase>) query.execute();
		Collections.sort(list);

 		if (list ==null || list.size() == 0 )
			return "{\"error\":\"null\"}";

 		if(ifcoord)
 			coordyFilter(list,y,r2);
 		if(ifstatus!=-2)
 			stautsFilter(list,ifstatus);
		
 		JSONArray array = new JSONArray();
		int index=0;
		for (GAENodeCase ob : list){ 
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
	

	private static void stautsFilter(List<GAENodeCase> list, int ifstatus) {
		// TODO Auto-generated method stub
		Iterator<GAENodeCase> it = list.iterator();
		while(it.hasNext()){				
			if(tool.StaticValue.findStatusv(it.next().status)!=ifstatus)
				it.remove();
		}		
	}


	private static void coordyFilter(List<GAENodeCase> list,double y,double r)
	{
		double low = y-r;
		double up = y+r;
		double d;
		Iterator<GAENodeCase> it = list.iterator();
		while(it.hasNext()){				

			d = it.next().coordy;
			if(d<low || d>up)
				it.remove();
			// System.out.print(ob.toJson());
		}
	}

}
