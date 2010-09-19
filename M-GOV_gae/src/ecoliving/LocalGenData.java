package ecoliving;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;


@Path("/_gen")

public class LocalGenData {

	public static String CFID = "316970";
	public static String CFTOKEN = "23019116";
	
	@GET
	@Produces(MediaType.TEXT_PLAIN)

	public static String go()
	{
		set_cookie.go(CFID, CFTOKEN);
		query_id.go("09909-501655");
		query_id.go("09909-500718");
		query_id.go("09909-500714");
		query_id.go("09909-006416");
		query_id.go("09909-006413");
		query_id.go("09909-006340");
		query_id.go("09909-006222");
		query_id.go("09909-006203");
		query_id.go("09909-006131");
		
		return "done";
	}
	
}
