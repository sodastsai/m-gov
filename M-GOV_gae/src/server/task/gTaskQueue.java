package server.task;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import com.google.appengine.api.labs.taskqueue.Queue;
import com.google.appengine.api.labs.taskqueue.QueueFactory;
import com.google.appengine.api.labs.taskqueue.TaskOptions;
import com.google.appengine.api.labs.taskqueue.TaskOptions.Method;

@Path("task")
//Test
public class gTaskQueue {

	@GET
	@Produces(MediaType.TEXT_PLAIN)
	public static String go()
	{
		
        Queue queue = QueueFactory.getDefaultQueue();
        queue.add(TaskOptions.Builder.url("/email/godgunman/1234").method(Method.GET));
        //
//        queue.add
//        
//        queue.add(url("/path?a=b&c=d").method(Method.GET));
		
        return "done";
	}
}
