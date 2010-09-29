package tw.edu.ntu.csie.mgov.gae;


import java.util.HashMap;
import java.util.Iterator;

import org.json.JSONException;
import org.json.JSONObject;

public class GAECase {

	JSONObject json;
	HashMap<String, Object> data;
	
	@SuppressWarnings("unchecked")
	public GAECase(JSONObject ob) throws JSONException {
		data = new HashMap<String, Object>();
		Iterator<String> it = json.keys();

		while (it.hasNext()) {
			String key = it.next();
			data.put(key, json.getString(key));
		}
	}

	public HashMap<String, Object> getMap() throws JSONException {
		return data;
	}

	public JSONObject getJSON() {
		return json;
	}
}
