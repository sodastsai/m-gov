package ecoliving;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@Path("/query_near")

public class query_near {
	
	//TODO
	@GET
	@Produces(MediaType.TEXT_PLAIN)
	public static String go()
	{
		
		return "ker ker";
	}

}
