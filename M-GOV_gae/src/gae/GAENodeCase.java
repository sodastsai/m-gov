package gae;

import java.util.ArrayList;
import java.util.Date;

import javax.jdo.annotations.IdentityType;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

import org.json.JSONException;
import org.json.JSONObject;

import com.google.appengine.api.datastore.Blob;

@PersistenceCapable(identityType = IdentityType.APPLICATION)
public class GAENodeCase implements Comparable<GAENodeCase>{

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
	public String address;

//	@Persistent
//	public boolean send;

	@Persistent
	private Blob photo[];

	@Persistent
	private Date date;


	
	public GAENodeCase(){
		sno = String.valueOf(Math.random());
		date = new Date();
		status = "nodata";
		key = String.valueOf(Math.abs(date.hashCode())%100000);
	}

	public void setPhoto(ArrayList<Blob> photo){
		this.photo = new Blob[photo.size()];
		int id=0;
		for(Blob ob:photo)
			this.photo[id++]=ob;
	}
	
	//此地方的json格式和GAENode稍微不同。
	public JSONObject toJson(){
		String coordinates=String.valueOf(coordx) + "," + String.valueOf(coordy);
		GAENodeSimple r = new GAENodeSimple(key,typeid,date.toString(),coordinates,status,address,email);
		JSONObject job = r.toJson();

		try {
			job.put("email", email);
			job.put("name", name);
			
//			job.put("h_admit_name", h_admit_name);
//			job.put("h_admiv_name", h_admiv_name);
			String image[]=new String[photo.length];
			for(int i=0;i<photo.length;i++)
				image[i]="http://ntu-ecoliving.appspot.com/view/"+key+"/"+i;

			job.put("image",image);
			job.put("detail", h_summary);
			
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

	public void setKey(String key){
		this.key = key;
	}

	public String getKey(){
		return key;
	}
	
	public void genStatus(){

		int len = tool.StaticValue.status.length; 
		status = tool.StaticValue.status[Math.abs((new Date().toString().hashCode()))%len];

	}		
	

	@Override
	public int compareTo(GAENodeCase o) {
		// TODO Auto-generated method stub
		return this.date.compareTo(o.date)*-1;
	}

}
