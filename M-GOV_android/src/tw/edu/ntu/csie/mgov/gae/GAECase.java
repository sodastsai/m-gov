package tw.edu.ntu.csie.mgov.gae;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class GAECase {

	private String key;

	private String typeid;
	private String date;
	private String region;
	private String detail;
	private String address;
	private String email;
	private String name;
	private double coordx;
	private double coordy;

	private String status;
	public String images[];

	JSONObject json;
	
	public GAECase(JSONObject ob) throws JSONException {
		this.typeid = (String) ob.get("typeid");
		this.date = (String) ob.get("date");
		this.region = (String) ob.get("region");
		this.detail = (String) ob.get("detail");
		this.address = (String) ob.get("address");
		this.coordx = Double.parseDouble((String) ob.get("coordx"));
		this.coordy = Double.parseDouble((String) ob.get("coordy"));
	}

	public HashMap<String, String> toMap() throws JSONException {
		HashMap<String, String> table = new HashMap();
		Iterator<String> it = json.keys();

		while (it.hasNext()) {
			String key = it.next();
			table.put(key, json.getString(key));
		}
		return table;
	}

	public JSONObject getJSON() {
		return json;
	}
}
