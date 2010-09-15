package gae;

import javax.jdo.annotations.IdentityType;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

import org.json.JSONArray;
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
//	@Persistent
//	private String type1;
//	@Persistent
//	private String type2;
	@Persistent
	private String typeid;
	@Persistent
	private String detail;
	@Persistent
	private String address;
	@Persistent
	private double coordinates[];
	@Persistent
	private String status;
	@Persistent
	public String images[];
	@Persistent
	public Text other;

	public GAENode(String key, String date, String region,
					String type1, String type2, String typeid, 
					String detail, String address, String coordinates, String status,String images[],
			String other) {
		this.key = key;
		this.date = date;
		this.region = region;
//		this.type1 = type1;
//		this.type2 = type2;
		this.typeid = typeid;
		this.detail = detail;
		this.address = address;
		
		String str[]=coordinates.split(",");
		this.coordinates = new double[2]; 
		this.coordinates[0]=Double.parseDouble(str[0]);
		this.coordinates[1]=Double.parseDouble(str[1]);
		
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

	
	public String toJson() {
		JSONObject o = new JSONObject();
		try {

			o.accumulate("key", key);
			o.accumulate("date", date);
//			o.accumulate("region", region);
//			o.accumulate("type1", type1);
//			o.accumulate("type2", type2);
			o.accumulate("typeid", typeid);

			o.accumulate("detail", detail);
			o.accumulate("address",address);
			o.accumulate("coordinates",coordinates);
			o.accumulate("status", status);

			JSONArray array = new JSONArray();
//			o.accumulate("other", other.getValue());
			for (int i = 0; i < images.length; i++)
				array.put(images[i]);
			o.accumulate("image",array);
			// System.out.println(a);
			return o.toString();
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return "Failure";
		}
	}

	@Override
	public String toString() {
		return key + " " + date + " " + typeid + " "
				+ status + " " + other;
	}
}