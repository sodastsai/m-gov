package gae;

import java.util.ArrayList;
import java.util.Date;

import javax.jdo.annotations.IdentityType;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

import org.json.JSONException;
import org.json.JSONObject;

import tool.StaticValue;

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
	public Blob photo[];

	@Persistent
	private Date date;


	private void defualtInit(){
		date = new Date();
		status = "查報";
		key = String.valueOf(Math.abs(date.hashCode())%100000);
		sno = key;
//		photo = new Blob[3];
	}
	
	public GAENodeCase(String sno,String email,String name,String typeid,
			String h_admit_name,
			String h_admiv_name, 
			String h_summary,
			double coordx,double coordy,
			String address){
		
		this.sno = sno;
		this.email = email;
		this.name = name;
		this.typeid = typeid;
		this.h_admit_name = h_admit_name;
		this.h_admiv_name = h_admiv_name;
		this.h_summary = h_summary;
		this.coordx = coordx;
		this.coordy = coordy;
		this.address = address;
		
		defualtInit();
	}
	
	public GAENodeCase clone()
	{
		GAENodeCase node = new GAENodeCase(this.sno,this.email,this.name,this.typeid,this.h_admit_name,this.h_admiv_name,this.h_summary,this.coordx,this.coordy,this.address); 
		node.photo = this.photo;
		return node; 
	}
	
	public GAENodeCase(){
		defualtInit();
	}

	public void setPhoto(byte[] photo){
		this.photo = new Blob[1];
		this.photo[0] = new Blob(photo);
	}

	public void setPhoto(ArrayList<Blob> photo){
		this.photo = new Blob[photo.size()];
		int id=0;
		for(Blob ob:photo)
			this.photo[id++]=ob;
	}
	

	//此地方的json格式和GAENode稍微不同。
	@SuppressWarnings("deprecation")
	public JSONObject toJson(){
		String coordinates=String.valueOf(coordx) + "," + String.valueOf(coordy);

		String dateStr = (date.getYear()-11)+"年"+(date.getMonth()+1)+"月"+date.getDate()+"日";
		
		GAENodeSimple r = new GAENodeSimple(sno,typeid,dateStr,coordinates,status,address,email);
		JSONObject job = r.toJson();

		try {
			job.put("email", email);
			job.put("name", name);
			
//			job.put("h_admit_name", h_admit_name);
//			job.put("h_admiv_name", h_admiv_name);
			if(photo!=null)
			{
				String image[]=new String[photo.length];
				for(int i=0;i<photo.length;i++)
					image[i]="http://ntu-ecoliving.appspot.com/view/"+key+"/"+i;
				job.put("image",image);
			}

			job.put("detail", h_summary);			
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return job;
	}
	
	public byte[] getImage(int i){
		if(photo==null)
			return null;
		if(0<=i && i<photo.length)
			return photo[i].getBytes();
		else
			return null;
	}

	public void setKey(String key){
		this.key = key;
		this.sno = key;
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
