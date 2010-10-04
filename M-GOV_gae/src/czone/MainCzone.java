package czone;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;

//@Path("czone")
public class MainCzone {


	@GET
	@Path("{id}")
	static public void doQueryID(@PathParam("id") String arg){
		QueryID.go(arg);
	} 


}
