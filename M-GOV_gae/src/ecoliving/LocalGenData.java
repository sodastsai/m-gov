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
		SetCookie.go(CFID, CFTOKEN);
		QueryID.go("09909-501655");
		QueryID.go("09909-500718");
		QueryID.go("09909-500714");
		QueryID.go("09909-006416");
		QueryID.go("09909-006413");
		QueryID.go("09909-006340");
		QueryID.go("09909-006222");
		QueryID.go("09909-006203");
		QueryID.go("09909-006131");
		
		return "done";
	}
	
}
