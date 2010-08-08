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
	public String admin_region;
	@Persistent
	public String category;
	@Persistent
	public String detail;
	@Persistent
	public String detail2;
	@Persistent
	public String images[];
	@Persistent
	public Text other;

	public GAENode(String key, String date, String admin_region,
			String category, String detail, String detail2, String images[],
			String other) {
		this.key = key;
		this.date = date;
		this.admin_region = admin_region;
		this.category = category;
		this.detail = detail;
		this.detail2 = detail2;
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
			o.accumulate("region", admin_region);
			o.accumulate("category", category);
			o.accumulate("detail", detail);
			o.accumulate("detail2", detail2);
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
		return key + " " + date + " " + admin_region + " " + category + " "
				+ detail + " " + other;
	}
}