package server.caseDB;

import gae.GAEDataBase;
import gae.GAENodeCase;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;

import javax.ws.rs.Consumes;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import com.sun.jersey.core.header.FormDataContentDisposition;

import server.czone.CzoneMain;
import server.czone.ParseID;

import net.ReadUrlByPOST;


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
			return CzoneMain.doQuery(chk, method, arg, st, ed);
//			return CaseQueryAll.go(method, arg, st, ed);
		else
			return "{\"error\":\"method error\"}";
		
	}
	
	@Path("add")
	@POST
	@Produces(MediaType.TEXT_PLAIN)
	@Consumes("multipart/form-data")
	public static String doUploadCourse(
			@FormParam("photo") FormDataContentDisposition dispostion,
		    @FormParam("photo") InputStream photo_inputstream,
		    @FormParam("email") String email,
		    @FormParam("name") String name,
		    @FormParam("h_admit_name") String h_admit_name,
		    @FormParam("h_admiv_name") String h_admiv_name,
		    @FormParam("h_summary") String h_summary,
		    @FormParam("typeid") String typeid,
		    @FormParam("coordx") String coordx,
		    @FormParam("coordy") String coordy,
		    @FormParam("address") String address,
		    @FormParam("send") String send) {
		
		GAENodeCase node = null;
		try{
			node = new GAENodeCase(email, name, typeid, h_admit_name, h_admiv_name, h_summary,Double.parseDouble(coordx), Double.parseDouble(coordy), address);
		}
		catch (Exception e) {
			// TODO Auto-generated catch block
			System.out.println(e);
			return e.toString();
		}		

		ByteArrayOutputStream photo = new ByteArrayOutputStream();
		byte[] b = new byte[1024];
		int n;
		try {
			while ((n = photo_inputstream.read(b)) != -1) {
				photo.write(b, 0, n);
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		
		if(photo.size()!=0)
			node.setPhoto(photo.toByteArray());
		
		if("send".equals(send))
		{
			System.out.println("send to czone");
			String key = ReadUrlByPOST.doSend(node);
			System.out.println("key:" +key);
			if(key!=null && key.length()>1)
			{
				ParseID.go(key, node.email);
				node.setKey(key);
			}
		}
		
		GAEDataBase.store(node);
		return node.toJson().toString();
	}
}
