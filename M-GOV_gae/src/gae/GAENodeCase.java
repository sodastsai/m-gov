package gae;

import java.util.ArrayList;
import java.util.Date;

import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.IdentityType;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

import org.json.JSONException;
import org.json.JSONObject;

import com.google.appengine.api.datastore.Blob;

@PersistenceCapable(identityType = IdentityType.APPLICATION)
public class GAENodeCase {

    @PrimaryKey
    private String key;
	@Persistent
	public String sno;

	@Persistent
	public String unit;
	
	@Persistent
	public String email,name;

	@Persistent
	public String typeid,status;

	@Persistent
	public String h_admit_name, h_admiv_name, h_summary;

	@Persistent
	public double coordx, coordy;

	@Persistent
	private Blob photo[];

	@Persistent
	private Date date;

	public GAENodeCase(){
		sno = String.valueOf(Math.random());
		date = new Date();
		status = "烏賊車";
		key = String.valueOf(Math.random());
	}

	public void setPhoto(ArrayList<Blob> photo){
		this.photo = new Blob[photo.size()];
		int id=0;
		for(Blob ob:photo)
			this.photo[id++]=ob;
	}
	
	public JSONObject toJson(){
		String coordinates=String.valueOf(coordx) + "," + String.valueOf(coordy);
		GAENodeSimple r = new GAENodeSimple(key,typeid,date.toString(),coordinates,status);
		JSONObject job = r.toJson();

		try {
			job.put("email", email);
			job.put("name", name);
//			job.put("h_admit_name", h_admit_name);
//			job.put("h_admiv_name", h_admiv_name);
			job.put("h_summary", h_summary);
			for(int i=0;i<photo.length;i++){
				job.put("photo","http://ntu-ecoliving.appspot.com/ecoliving/view/"+key+"/"+i);
			}
			
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return job;
	}
	
	public byte[] getImage(int i){
		if(i<photo.length)
			return photo[i].getBytes();
		else
			return "null".getBytes();
	}

	public GAENode toGAENode(){
		GAENode r = new GAENode(key,date.toString(),typeid,h_summary,coordx,coordy);

		return r;
	}

}
