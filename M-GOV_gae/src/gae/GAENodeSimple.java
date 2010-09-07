package gae;

import javax.jdo.annotations.IdentityType;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

import org.json.JSONException;
import org.json.JSONObject;

@PersistenceCapable(identityType = IdentityType.APPLICATION)
public class GAENodeSimple {

	@PrimaryKey
	@Persistent
	private String key;
	@Persistent
	public String typeid;
	@Persistent
	public String region;
	@Persistent
	public double coordinates[];
	@Persistent
	public String status;

	public GAENodeSimple(){}
	
	public GAENodeSimple(String key, String typeid, String region,
			String coordinates, String status) {
		this.key = key;
		this.typeid = typeid;
		this.region = region;

		String str[]=coordinates.split(",");
		this.coordinates = new double[2]; 
		this.coordinates[0]=Double.parseDouble(str[0]);
		this.coordinates[1]=Double.parseDouble(str[1]);

		this.status = status;
	}

	public String getKey() {
		return key;

	}

	public JSONObject toJson() {
		try {

			JSONObject o = new JSONObject();
			o.accumulate("key", key);
			o.accumulate("coordinates", coordinates);
			o.accumulate("region", region);
			o.accumulate("typeid", typeid);
			o.accumulate("status", status);

			return o;
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
	}
	
	public GAENodeSimple clone(){
		GAENodeSimple e = new GAENodeSimple();
		e.key = key ;
		e.typeid = typeid;
		e.region = region;
		e.coordinates = coordinates;
		e.status = status;
		return e;
	}

	@Override
	public String toString() {
		return toJson().toString();
	}

}
