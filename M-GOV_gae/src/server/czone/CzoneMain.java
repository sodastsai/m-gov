package server.czone;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@Path("czone")
public class CzoneMain {

	
	@GET
	@Produces(MediaType.TEXT_PLAIN)
	@Path("list")
	public static String doList() {
		return List.go();
	}
	
	@GET
	@Produces(MediaType.TEXT_PLAIN)
	@Path("{get_id}/{id}")
	public static String doGetID(@PathParam("get_id") String chk,
			@PathParam("id") String arg) {
		if ("get_id".equals(chk))
			return GetID.query(arg);
		else
			return "{\"error\":\"method error\"}";
	}

	@GET
	@Produces(MediaType.TEXT_PLAIN)
	@Path("{parse_id}/{id}")
	public static String doParseID(@PathParam("parse_id") String chk,
			@PathParam("id") String arg) {
		if ("parse_id".equals(chk))
			return GetID.query(arg);
		else
			return "{\"error\":\"method error\"}";
	}

	
	@GET
	@Produces(MediaType.TEXT_PLAIN)
	@Path("{query}/{c1}/{c2}/{c3}/{c4}")
	public static String doQuery(@PathParam("query") String chk,
			@PathParam("c1") String method,	@PathParam("c2") String arg, 
			@PathParam("c3") int st, @PathParam("c4") int ed) {

		if ("query".equals(chk))
			return QueryAll.go(method, arg, st, ed);
		else
			return "{\"error\":\"method error\"}";
		
	}


}
