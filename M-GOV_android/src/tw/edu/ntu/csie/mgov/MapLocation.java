package tw.edu.ntu.csie.mgov;

import com.google.android.maps.GeoPoint;

public class MapLocation {

	private GeoPoint	point;
	private String		name;
	public MapLocation(String name,double latitude, double longitude) {
		this.name = name;
		point = new GeoPoint((int)(latitude*1e6),(int)(longitude*1e6));
	}

	public GeoPoint getPoint() {
		return point;
	}
	public void setPoint(GeoPoint p){
		point = p; 
	}
	public String getName() {
		return name;
	}
}
