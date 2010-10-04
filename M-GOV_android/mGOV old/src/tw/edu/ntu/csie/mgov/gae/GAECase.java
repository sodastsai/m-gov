package tw.edu.ntu.csie.mgov.gae;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class GAECase extends HashMap<String, String>{

	JSONObject json;
	ArrayList<String> photo,image,coordinates;
	
	public GAECase(){
		super();
		photo = new ArrayList<String>();
		image = new ArrayList<String>();
		coordinates = new ArrayList<String>(2);
	}
	
	@SuppressWarnings("unchecked")
	public GAECase(JSONObject ob) throws JSONException {
		super();
		
		Iterator<String> it = json.keys();
		while (it.hasNext()) {
			String key = it.next();
			
			if("image".equals(key)){
				JSONArray array = json.getJSONArray(key);
				for(int i=0;i<array.length();i++){
					image.add(array.getString(i));
				}
			}
			else if("coordinates".equals(key)){
				JSONArray array = json.getJSONArray(key);
				setCoordinates(array.getString(0),array.getString(1));
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

	public void addPhoto(String photo){
		this.photo.add(photo);
	}	

	public void setCoordinates(String x,String y){
		coordinates.add(x);
		coordinates.add(y);

	}
	
	public String[] getImage(){
		return (String[]) image.toArray();
	}
	
	public String[] getCoordinates(){
		return (String[]) coordinates.toArray();
	}


}
/*
image 下載URL
photo 上傳檔案路徑

 */