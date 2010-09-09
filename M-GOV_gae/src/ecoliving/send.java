package ecoliving;

import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.datanucleus.jta.JOnASTransactionManagerLocator;
import org.json.JSONException;
import org.json.JSONObject;


@Path("/send")

public class send {
	
	@SuppressWarnings("unchecked")
	@GET
	@Produces(MediaType.TEXT_PLAIN)
	@Path("{c1}")		

	public static String go(@PathParam("c1") String str) throws Exception
	{
		JSONObject ob = new JSONObject(str);
		
		
		
		
		return "";		
	}
}
