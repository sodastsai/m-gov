package server;

import gae.GAENodeCase;
import gae.GAENodeSimple;
import gae.PMF;

import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import javax.jdo.PersistenceManager;
import javax.jdo.Query;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import com.google.appengine.api.labs.taskqueue.Queue;
import com.google.appengine.api.labs.taskqueue.QueueFactory;
import com.google.appengine.api.labs.taskqueue.TaskOptions;
import com.google.appengine.api.labs.taskqueue.TaskOptions.Method;

import server.czone.ParseID;
import tool.StaticValue;

@Path("/update_status")
public class UpdateStatus {

	static String strurl;

	@SuppressWarnings("unchecked")
	@GET
	@Produces(MediaType.TEXT_PLAIN)
	public static String go() {

		PersistenceManager pm = PMF.get().getPersistenceManager();
		ArrayList<String> sno_list = new ArrayList<String>();
		
		for(int i=0;i<StaticValue.statusv.length;i++)
		{
			if(StaticValue.statusv[i]==0)
			{
				Query query = pm.newQuery(GAENodeSimple.class);
				query.setFilter(String.format("status == '%s'",StaticValue.status[i]));
				query.execute();
				List<GAENodeSimple> results = (List<GAENodeSimple>) query.execute();
				for(GAENodeSimple ob:results){
					sno_list.add(ob.getKey());
				}
			}
		}
		Queue queue = QueueFactory.getQueue("subscription-queue");
		for(String sno:sno_list){
	        queue.add(TaskOptions.Builder.url("/czone/parse_id/"+sno).method(Method.GET));
		}
		
		return sno_list.toString();
	}
}