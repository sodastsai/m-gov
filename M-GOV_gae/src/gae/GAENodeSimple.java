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
	public String coordinates;
	
	
	public GAENodeSimple(String key,String typeid,String region, String coordinates)
	{
		this.key = key;
		this.typeid = typeid;
		this.region = region;
		this.coordinates = coordinates;
	}

	public JSONObject toJson() {
		JSONObject o = new JSONObject();
		try {

			o.accumulate("key", key);
			o.accumulate("coordinates", coordinates);
			o.accumulate("region", region);
			o.accumulate("typeid", typeid);

			return o;
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public String toString() {
		return key + "  " + coordinates + "  " + typeid;
	}
	
	
}
