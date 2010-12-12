package server;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import server.czone.ParseID;



@Path("/_gen")

public class LocalGenData {

	public static String CFID = "316970";
	public static String CFTOKEN = "23019116";
	
	@GET
	@Produces(MediaType.TEXT_PLAIN)

	public static String go()
	{
		SetDBCookie.go(CFID, CFTOKEN);
		ParseID.go("09909-501655");
		ParseID.go("09909-500718");
		ParseID.go("09909-500714");
		ParseID.go("09909-006416");
		ParseID.go("09909-006413");
		ParseID.go("09909-006340");
		ParseID.go("09909-006222");
		ParseID.go("09909-006203");
		ParseID.go("09909-006131");
		
		return "done";
	}
	
}
