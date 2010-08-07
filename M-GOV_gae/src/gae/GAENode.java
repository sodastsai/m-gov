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
public
class GAENode {

	@SuppressWarnings("unused")
	@PrimaryKey
	@Persistent
	private String key;
	@Persistent
	public String date;
	@Persistent
	public String admin_region;
	@Persistent
	public String category;
	@Persistent
	public String detail;
	@Persistent
	public Text other;
	
	public GAENode(String key,String date,String admin_region,String category,String detail,String other) {
		this.key=new String(key);
		this.date=new String(date);
		this.admin_region=new String(admin_region);
		this.category=new String(category);
		this.detail=new String(detail);
		this.other=new Text(other);
	}

	public String getKey() {return key;};
	public String toJson()
	{
		JSONObject o = new JSONObject();
		try {			
			o.accumulate("key",key);
			o.accumulate("date",date);
			o.accumulate("region", admin_region);
			o.accumulate("category", category);
			o.accumulate("detail", detail);
			o.accumulate("other", other.getValue());
//			System.out.println(a);
			return o.toString();		
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return "Failure";
		}
	}
	
	@Override
	public String toString() {
		return key + " " + date + " " + admin_region + " " + category + " " + detail + " " + other;
	}
}