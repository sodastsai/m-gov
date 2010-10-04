package server.caseDB;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@Path("case")
public class CaseMain {

	@Path("list")
	@GET
	@Produces(MediaType.TEXT_PLAIN)
	public static String doList() {
		return CaseList.go();
	}	

	@Path("delete")
	@GET
	@Produces(MediaType.TEXT_PLAIN)
	public static String doDelete() {
		return CaseDelete.go();
	}	
	
	
	
	
}
