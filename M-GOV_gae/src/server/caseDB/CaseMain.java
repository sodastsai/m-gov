package server.caseDB;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
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
	
	@GET
	@Produces(MediaType.TEXT_PLAIN)
	@Path("{query}/{c1}/{c2}/{c3}/{c4}")
	public static String doQuery(@PathParam("query") String chk,
			@PathParam("c1") String method,	@PathParam("c2") String arg, 
			@PathParam("c3") int st, @PathParam("c4") int ed) {

		if ("query".equals(chk))
			return CaseQueryAll.go(method, arg, st, ed);
		else
			return "{\"error\":\"method error\"}";
		
	}
	
}
