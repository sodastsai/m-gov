package tw.edu.ntu.mgov.gae;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import tw.edu.ntu.mgov.net.ReadUrl;

public class GAEQuery {

	final static String prefixURL="http://ntu-ecoliving.appspot.com/czone/";
	
	String method,args;
	
	public GAEQuery(){
	}

	public GAECase getID(String id) throws JSONException{
		String res = ReadUrl.process(prefixURL+"get_id/"+id,"utf-8");
		return new GAECase(new JSONObject(res));
	}
	
	public void addQuery(String method,String args[]){
		this.method += "&"+method;

		for(String ob:args){
			this.args += "&"+ob;
		}
		
	}
	
	//TODO
	public GAECase[] doQuery(int start,int end){
		String queryStr = prefixURL + "query/" + method + "/" + args +"/"+ start +"/"+ end;
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
