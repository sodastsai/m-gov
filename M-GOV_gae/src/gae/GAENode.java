package gae;

import javax.jdo.annotations.IdentityType;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

import org.json.JSONException;
import org.json.JSONObject;

import com.google.appengine.api.datastore.Text;

@PersistenceCapable(identityType = IdentityType.APPLICATION)
public class GAENode {

	@SuppressWarnings("unused")
	@PrimaryKey
	@Persistent
	private String key;
	@Persistent
	private String date;
	@Persistent
	private String region;
	@Persistent
	private String typeid;
	@Persistent
	private String detail;
	@Persistent
	private String address;
	@Persistent
	private double coordx;
	@Persistent
	private double coordy;

	@Persistent
	private String status;
	@Persistent
	public String images[];
	@Persistent
	public Text other;

	public GAENode(String key,String date,String typeid,String detail,double x,double y,String status,String address){
		this.key = key;
		this.date = date;
		this.typeid = typeid;
		this.detail = detail;
		this.coordx = x;
		this.coordy = y;
		this.status = status;
		this.address = address;
	}
	
	public GAENode(String key, String date, String region,
					String type1, String type2, String typeid, 
					String detail, String address, String coordinates, String status,String images[],
			String other) {
		this.key = key;
		this.date = date;
		this.region = region;
		this.typeid = typeid;
		this.detail = detail;
		this.address = address;
		
		String str[]=coordinates.split(",");
		this.coordx=Double.parseDouble(str[0]);
		this.coordy=Double.parseDouble(str[1]);
		
		this.status = status;
		this.images = images;
		this.other = new Text(other);
	}

	public String getKey() {
		return key;
	};

	public String getDate() {
		return date;
	};
	
	public String getAdd(){
		return address;
	}

	
	public JSONObject toJson() {
		JSONObject o = new JSONObject();
		try {

			o.accumulate("key", key);
			o.accumulate("date", date);
//			o.accumulate("region", region);
			o.accumulate("typeid", typeid);

			o.accumulate("detail", detail);
			o.accumulate("address",address);
			o.accumulate("coordinates",coordx);
			o.accumulate("coordinates",coordy);

			o.accumulate("status", status);

//			o.accumulate("other", other.getValue());
			o.accumulate("image",images);
			// System.out.println(a);
			return o;
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public String toString() {
		return key + " " + date + " " + typeid + " "
				+ status + " " + other;
	}
}