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
	public String date;
	@Persistent
	public String region;
	@Persistent
	public String type1;
	@Persistent
	public String type2;
	@Persistent
	public String typeid;
	@Persistent
	public String detail;
	@Persistent
	public String address;
	@Persistent
	public String state;
	
	@Persistent
	public String images[];
	@Persistent
	public Text other;

	public GAENode(String key, String date, String region,
			String type1, String type2, String typeid, String detail, String address, String state,String images[],
			String other) {
		this.key = key;
		this.date = date;
		this.region = region;
		this.type1 = type1;
		this.type2 = type2;
		this.typeid = typeid;
		this.detail = detail;
		this.address = address;
		this.state = state;
		this.images = images;
		this.other = new Text(other);
	}

	public String getKey() {
		return key;
	};

	public String toJson() {
		JSONObject o = new JSONObject();
		try {

			o.accumulate("key", key);
			o.accumulate("date", date);
			o.accumulate("region", region);
			o.accumulate("type1", type1);
			o.accumulate("type2", type2);
			o.accumulate("typeid", typeid);

			o.accumulate("detail", detail);
			o.accumulate("address",address);
			o.accumulate("state", state);

			// o.accumulate("other", other.getValue());
			for (int i = 0; i < images.length; i++)
				o.accumulate("image", images[i]);
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
		return key + " " + date + " " + region + " " + type1 + " "
				+ type2 + " " + other;
	}
}