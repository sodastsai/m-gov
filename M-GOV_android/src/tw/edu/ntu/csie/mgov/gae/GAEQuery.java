package tw.edu.ntu.csie.mgov.gae;

import org.json.JSONArray;
import org.json.JSONException;

import tw.edu.ntu.csie.mgov.net.ReadUrl;

public class GAEQuery {

	final static String prefixURL="http://ntu-ecoliving.appspot.com/ecoliving/query/";
	
	public GAEQuery(){
	}
	
	//TODO
	public GAECase[] doQuery(String method,String args,int st,int ed){
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
