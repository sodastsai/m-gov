/**
 * 
 */
package tw.edu.ntu.mgov.addcase;

import tw.edu.ntu.mgov.R;
import android.os.Bundle;

import com.google.android.maps.MapActivity;
import com.google.android.maps.MapView;

/**
 * @author vagrants
 * 2010/10/9
 * @company NTU CSIE Mobile HCI Lab
 */
public class SelectLocationMap extends MapActivity {

	MapView mapView;
	
	@Override
	protected void onCreate(Bundle icicle) {
		super.onCreate(icicle);
		
		setTitle("請選擇案件地點");
		setContentView(R.layout.addcase_select_location);
		findAllViews();
		
		mapView.setBuiltInZoomControls(true);
	}

	void findAllViews() {
		mapView = (MapView) findViewById(R.id.AddCase_SelectLication_MapView);
	}
	
	/* (non-Javadoc)
	 * @see com.google.android.maps.MapActivity#isRouteDisplayed()
	 */
	@Override
	protected boolean isRouteDisplayed() {
		// TODO Auto-generated method stub
		return false;
	}
}
