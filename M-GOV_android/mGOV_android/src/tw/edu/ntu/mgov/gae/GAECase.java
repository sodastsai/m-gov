package tw.edu.ntu.mgov.gae;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.util.Log;

import com.google.android.maps.GeoPoint;

public class GAECase extends HashMap<String, String>{

	/**
	 * 
	 */
	public int len;
	
	private static final long serialVersionUID = 1L;
	ArrayList<String> image;
	
	public GAECase(){
		super();
		image = new ArrayList<String>();
	}
	
	@SuppressWarnings("unchecked")
	public GAECase(JSONObject json) throws JSONException {
		super();
		image = new ArrayList<String>();

		if(json.optBoolean("result"))
			json = json.getJSONObject("result");
		if(json.optBoolean("length"))
			len = Integer.parseInt(json.getString("length"));
		
		
		Iterator<String> it = json.keys();
		while (it.hasNext()) {
			String key = it.next();
			if("image".equals(key)){
				JSONArray array = json.getJSONArray(key);
				for(int i=0;i<array.length();i++){
					image.add(array.getString(i));
				}
			}
			if("photo".equals(key)){
				image.add(json.getString(key).toString());
			}
			else if("coordinates".equals(key)){
				JSONArray array = json.getJSONArray(key);
				this.put("coordy", array.getString(0));
				this.put("coordx", array.getString(1));
			}
			this.put(key, json.getString(key));
		}
	}

	public void addform(String key,String value){
		this.put(key, value);
	}
	
	public String getform(String key){
		return this.get(key);
	}
	
	public GeoPoint getGeoPoint() {
		double lat = Double.parseDouble(this.getform("coordx"));
		double lon = Double.parseDouble(this.getform("coordy"));
		return new GeoPoint((int)(lat*Math.pow(10, 6)), (int)(lon*Math.pow(10, 6)));
	}
	
	public void addImage(String photo){
		this.image.add(photo);
	}	

	public String[] getImage(){
		String[] res = new String[image.size()];
		for(int i=0;i<image.size();i++)
			res[i]=image.get(i);
		
		return res;
	}

	
	public String toString(){
		Set<String> keyset = this.keySet();
		String r="";
		for(String key:keyset){
			r+=this.get(key)+'\n';
		}
		return r;
	}

}
/*
image 下載URL
photo 上傳檔案路徑

 */