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
	public String date;
	@Persistent
	public double coordinates[];
	@Persistent
	public double coord_mul;
	
	@Persistent
	public String status;

	public GAENodeSimple(){}
	
	public GAENodeSimple(String key, String typeid, String date,
			String coordinates, String status) {
		this.key = key;
		this.typeid = typeid;
		this.date = date;

		String str[]=coordinates.split(",");
		this.coordinates = new double[2]; 
		
		double d1=Double.parseDouble(str[0]);
		double d2=Double.parseDouble(str[1]);

		this.coordinates[0]=d1;
		this.coordinates[1]=d2;
		this.coord_mul = d1 * d2; 
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
			o.accumulate("coord_mul", coord_mul);

			o.accumulate("date", date);
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
		e.date = date;
		e.coordinates = coordinates;
		e.status = status;
		return e;
	}

	@Override
	public String toString() {
		return toJson().toString();
	}

}
