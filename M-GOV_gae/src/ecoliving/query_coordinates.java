package ecoliving;

import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@Path("/query_coordinates")

public class query_coordinates {
	
	//TODO
	@POST
	@Produces(MediaType.TEXT_PLAIN)
	public static String go()
	{
		
		return "ker ker";
	}

}
