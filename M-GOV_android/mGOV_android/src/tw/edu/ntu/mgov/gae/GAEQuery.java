package tw.edu.ntu.mgov.gae;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

//import com.google.android.maps.GeoPoint;

import tw.edu.ntu.mgov.net.ReadUrl;

public class GAEQuery {

	final static String prefixURL = "http://ntu-ecoliving.appspot.com/";
	final static String dbstr[] = { "czone/query/", "case/query/" };

	public static void main(String args[]) throws JSONException {
		GAEQuery query = new GAEQuery();
		query.addQuery("email", "NTU@mikechen.com");

		GAECase cases[] = query.doQuery(1, 0, 100);
		for(int i=0;i<cases.length;i++){
			System.out.println(cases[i].toString());
		}
	}

	public static enum GAEQueryCondtionType {
		GAEQueryByID, GAEQueryByEmail, GAEQueryByCoordinate, GAEQueryByType, GAEQueryByStatus
	}

	String method, args;

	public GAEQuery() {
		method = "";
		args = "";
	}

	public GAECase getID(String id) throws JSONException {
		String res = ReadUrl.process(prefixURL + "czone/get_id/" + id, "utf-8");
		return new GAECase(new JSONObject(res));
	}

	public void addQuery(String method, String arg) {
		if (this.method != "")
			this.method += '&';
		if (this.args != "")
			this.args += '&';

		this.method += method;
		this.args += arg;
	}

	/*
	 * // Overload public void addQuery(GAEQueryCondtionType conditionType,
	 * GeoPoint location, int latitudeSpanE6, int longitudeSpanE6) {
	 * Log.d("GAEQuery",
	 * "Span: "+Integer.toString(latitudeSpanE6)+" "+Integer.toString
	 * (longitudeSpanE6)); // Accept for GAEQueryByCoordinate only if
	 * (conditionType!=GAEQueryCondtionType.GAEQueryByCoordinate) return; String
	 * locationString; locationString =
	 * Double.toString((double)(location.getLongitudeE6()/Math.pow(10, 6)));
	 * locationString += "&"; locationString +=
	 * Double.toString((double)(location.getLatitudeE6()/Math.pow(10,6)));
	 * locationString += "&"; locationString +=
	 * Double.toString((double)longitudeSpanE6/Math.pow(10, 6)); locationString
	 * += "&"; locationString +=
	 * Double.toString((double)latitudeSpanE6/Math.pow(10, 6));
	 * this.addQuery(conditionType, locationString); }
	 */

	
	// 0:czone ,1:case
	public GAECase[] doQuery(int db, int start, int end) {
		if (db > 1)
			return null;

		String queryStr = prefixURL + dbstr[db] + method + "/" + args + "/"
				+ start + "/" + end;
		String jsonStr = ReadUrl.process(queryStr, "utf-8");

		// Log.d("GAEQuery", "URL: "+queryStr);
		System.out.println(queryStr);
		System.out.println(jsonStr);
		try {
			JSONObject ob = new JSONObject(jsonStr);

			if (ob.has("error")==true)
				return null;
			if (ob.has("result")) 
			{
				JSONArray array = ob.getJSONArray("result");
				int len = array.length();
				GAECase res[] = new GAECase[len];

				for (int i = 0; i < len; i++) 
					res[i] = new GAECase(array.getJSONObject(i));
				return res;
			}
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return null;
	}

}
