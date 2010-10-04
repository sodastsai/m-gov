package server;

import java.io.IOException;
import java.io.UnsupportedEncodingException;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@Path("/geocoding")
public class Geocoding {
	@GET
	@Produces(MediaType.TEXT_PLAIN)
	@Path("{c1}/{c2}")		
	
	public static String go(@PathParam("c1") String x,@PathParam("c2") String y) {
		String query=String.format("http://maps.google.com/maps/api/geocode/json?latlng=%s,%s&sensor=true&language=zh_TW",y,x);
		try {
			return net.ReadUrl.process(query,"utf-8");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "{\"error\":\"null\"}";
	}
}
