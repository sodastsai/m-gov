package tw.edu.ntu.mgov.gae;

import org.json.JSONArray;
import org.json.JSONException;

import tw.edu.ntu.mgov.net.ReadUrl;

public class GAEQuery {

	final static String prefixURL="http://ntu-ecoliving.appspot.com/ecoliving/query/";
	
	String method,args;
	
	public GAEQuery(){
	}

	public void addQuery(String method,String args[]){
		this.method += "&"+method;

		for(String ob:args){
			this.args += "&"+ob;
		}
		
	}
	
	//TODO
	public GAECase[] doQuery(int st,int ed){
		String queryStr = prefixURL + method + "/" + args +"/"+ st +"/"+ ed;
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
