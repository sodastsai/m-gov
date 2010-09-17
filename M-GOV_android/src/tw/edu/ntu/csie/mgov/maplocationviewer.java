package tw.edu.ntu.csie.mgov;

import java.util.ArrayList;
import java.util.List;
import android.content.Context;
import android.util.AttributeSet;
import android.widget.LinearLayout;
import com.google.android.maps.MapView;

public class maplocationviewer extends LinearLayout{
	
	private maplocationoverlay overlay;
    private List<MapLocation> mapLocations;
    private MapView mapView;
    Context c;
	public maplocationviewer(Context context, AttributeSet attrs) {
		super(context, attrs);
		init();
	}

	public maplocationviewer(Context context) {
		super(context);
		c = context;
		init();
	}

	public void init() {		

		setOrientation(VERTICAL);
		setLayoutParams(new LinearLayout.LayoutParams(android.view.ViewGroup.LayoutParams.FILL_PARENT,android.view.ViewGroup.LayoutParams.FILL_PARENT));

		mapView = new MapView(getContext(),"0RXnT5qrqdm-I08nvJSSU1nnDY2jpNUkXVQJqQg");
		mapView.setEnabled(true);
		mapView.setClickable(true);
		addView(mapView);
		overlay = new maplocationoverlay(this);
		mapView.getOverlays().add(overlay);
    	mapView.getController().setZoom(14);
    	mapView.getController().setCenter(getMapLocations().get(0).getPoint());
	
	}

	public void setcontext(Context context) {
		this.c = context;
		
	}
	public Context getcontext(){return c;}
	
	public List<MapLocation> getMapLocations() {
		if (mapLocations == null) {
			mapLocations = new ArrayList<MapLocation>();
//			mapLocations.add(new MapLocation("我的位置",gov.lat,gov.lon));
			mapLocations.add(new MapLocation("我的位置",25.02019,121.54267));;
//			mapLocations.add(new MapLocation("North Beach",37.799800872802734,-122.40699768066406));
//			mapLocations.add(new MapLocation("China Town",37.792598724365234,-122.40599822998047));
//			mapLocations.add(new MapLocation("Fisherman's Wharf",37.80910110473633,-122.41600036621094));
//			mapLocations.add(new MapLocation("Financial District",37.79410171508789,-122.4010009765625));
		}
		return mapLocations;
	}

	public MapView getMapView() {
		return mapView;
	}
		
	}
//key1 : 0s1B1FF9d_ivqw4Rv1vLav_kQfSLtI8VZElRIPQ ,
// key2 : 0s1B1FF9d_ivqw4Rv1vLav_kQfSLtI8VZElRIPQ
// by KM 0RXnT5qrqdm-I08nvJSSU1nnDY2jpNUkXVQJqQg
// by 打包 0aCvUxNP140qQe4prugHmRvnmNMQVMgwtq6Fp9g
