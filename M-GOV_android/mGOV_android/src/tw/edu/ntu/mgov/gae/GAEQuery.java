package tw.edu.ntu.mgov.gae;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.util.Log;

import com.google.android.maps.GeoPoint;

import tw.edu.ntu.mgov.net.ReadUrl;

public class GAEQuery {

	final static String prefixURL="http://ntu-ecoliving.appspot.com/";
	public static enum GAEQueryCondtionType {
		GAEQueryByID,
		GAEQueryByEmail,
		GAEQueryByCoordinate,
		GAEQueryByType,
		GAEQueryByStatus
	}
	
	String method, args;
	
	public GAEQuery(){
		method = "";
		args = "";
	}

	public GAECase getID(String id) throws JSONException{
		String res = ReadUrl.process(prefixURL+"get_id/"+id,"utf-8");
		return new GAECase(new JSONObject(res));
	}
	
	public void addQuery(GAEQueryCondtionType conditionType, String condition){
		String conditionString = "";
		if (conditionType==GAEQueryCondtionType.GAEQueryByID) conditionString = "czone/get_id";
		else if (conditionType==GAEQueryCondtionType.GAEQueryByEmail) conditionString = "case/query/email";
		else if (conditionType==GAEQueryCondtionType.GAEQueryByCoordinate) conditionString = "czone/query/coordinates";
		else if (conditionType==GAEQueryCondtionType.GAEQueryByType) conditionString = "czone/query/typeid";
		else if (conditionType==GAEQueryCondtionType.GAEQueryByStatus) conditionString = "case/query/status";
		
		if (method=="") this.method = conditionString;
		else this.method += "&"+conditionString;
		if (args=="") this.args = condition;
		else this.args += "&"+condition;
	}
	// Overload
	public void addQuery(GAEQueryCondtionType conditionType, GeoPoint location, int latitudeSpanE6, int longitudeSpanE6) {
		Log.d("GAEQuery", "Span: "+Integer.toString(latitudeSpanE6)+" "+Integer.toString(longitudeSpanE6));
		// Accept for GAEQueryByCoordinate only
		if (conditionType!=GAEQueryCondtionType.GAEQueryByCoordinate) return;
		String locationString;
		locationString = Double.toString((double)(location.getLongitudeE6()/Math.pow(10, 6)));
		locationString += "&";
		locationString += Double.toString((double)(location.getLatitudeE6()/Math.pow(10,6)));
		locationString += "&";
		locationString += Double.toString((double)longitudeSpanE6/Math.pow(10, 6));
		locationString += "&";
		locationString += Double.toString((double)latitudeSpanE6/Math.pow(10, 6));
		this.addQuery(conditionType, locationString);
	}
	
	//TODO
	public GAECase[] doQuery(int start,int end){
		String queryStr = prefixURL + method + "/" + args +"/"+ start +"/"+ end;
		Log.d("GAEQuery", "URL: "+queryStr);
		String jsonStr = ReadUrl.process(queryStr, "utf-8");
		
		try {
			JSONArray array = new JSONArray(jsonStr);
			int len = array.length();
			GAECase res[]=new GAECase[len];
			
			for(int i=0;i<len;i++){
				res[i] = new GAECase(array.getJSONObject(i));
			}
		
			return res;
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return null;
	}
}
