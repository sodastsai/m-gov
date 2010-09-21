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
public class GAENodeCase {

	@PrimaryKey
	@Persistent
	private Long key;
	@Persistent
	public String sno;
	@Persistent
	public String unit;

	@Persistent
	public String h_item1;
	@Persistent
	public String h_item2;

	@Persistent
	public String h_admit_name;
	@Persistent
	public String h_admiv_name;
	
	@Persistent
	public String h_summary, h_memo;

	@Persistent
	public String h_x1;
	@Persistent
	public String h_y1;

	@Persistent
	private Blob photo[];

	@Persistent
	private Date date;

	public GAENodeCase(){
	}
	
	public GAENodeCase(String sno, Date date, String unit,
					   String h_item1, String h_item2,
					   String h_admit_name, String h_admiv_name,
					   String h_summary, String h_memo,
					   String h_x1, String h_y1,
					   Blob bImg) {
		
		this.sno = sno;
		this.date = date;
		this.unit = unit;
		
		this.h_item1 = h_item1;
		this.h_item2 = h_item2;

		this.h_admit_name = h_admit_name;
		this.h_admiv_name = h_admiv_name;

		this.h_summary = h_summary;
		this.h_memo = h_memo;
		
		this.h_x1 = h_x1;
		this.h_y1 = h_y1;
		
	}
	
	public void genKey() {
		key = Long.valueOf( (this.sno + this.date ).hashCode());
	}

	public void setDate(Date date){
		this.date = date;
	}
	
	public void setPhoto(ArrayList<Blob> photo){
		this.photo = new Blob[photo.size()];
		int id=0;
		for(Blob ob:photo)
			this.photo[id++]=ob;
	}
	
	public JSONObject toJson() {
		JSONObject o = new JSONObject();
		try {
			o.accumulate("key", key);
			o.accumulate("sno", sno);
			o.accumulate("unit", unit);

			o.accumulate("h_item1",h_item1);
			o.accumulate("h_item2",h_item2);
			
			o.accumulate("h_admit_name",h_admit_name);
			o.accumulate("h_admiv_name",h_admiv_name);

			o.accumulate("h_summary",h_summary);
			o.accumulate("h_memo",h_memo);

			o.accumulate("date", date);
			o.accumulate("photo", photo);
			
			
			System.out.println(o.toString());
			return o;
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
	}
	
	
	public void setKey(Long key) {
		this.key = key;
	}
}
