package tw.edu.ntu.csie.mgov;

import android.app.Activity;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.location.Criteria;
import android.location.Location;
import android.location.LocationManager;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.ViewGroup;
import android.widget.Toast;

import com.google.android.maps.GeoPoint;
import com.google.android.maps.MapActivity;
import com.google.android.maps.MapView;

public class gov extends MapActivity{
	
	private maplocationviewer mpviewLoyout;
	private MapView mapview;
	ViewGroup zoom;
	private maplocationoverlay overlay = null;
	public static Activity google_act;
	public static final int MENU_MAP = Menu.FIRST + 6;
	public static double lat = 0;
	public static double lon = 0;
	
	protected boolean isRouteDisplayed() {
		// TODO Auto-generated method stub
		return false;
	}
	
	@Override
		public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.map);
		google_act = gov.this;
		
		
		LocationManager lm = (LocationManager) this.getSystemService(Context.LOCATION_SERVICE);
		Location center = getLocationProvider(lm);
		GeoPoint gpoint = new GeoPoint((int) (center.getLatitude() * 1e6),
				(int) (center.getLongitude() * 1e6));
		lat = center.getLatitude();
		lon = center.getLongitude();
		Toast.makeText(gov.this, gov.lat+" "+gov.lon, Toast.LENGTH_SHORT).show();
		int h =1;
		findViews();
	}
	
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		super.onCreateOptionsMenu(menu);

		menu.add(0, MENU_MAP, 0, "目前位置").setIcon(R.drawable.icon);
				return true;
	}
		
	@Override
	protected Dialog onCreateDialog(int id) {
		switch (id) {
		
		case MENU_MAP:
			return buildBusMenuDialog(gov.this);
		}
		return null;
	}
	public Dialog buildBusMenuDialog(Context context) {
		final CharSequence[] items = {"是", "否"};

		AlertDialog.Builder builder = new AlertDialog.Builder(this);
		
		builder.setTitle("目前所在位置嗎?");
		builder.setItems(items, new DialogInterface.OnClickListener() {
		    public void onClick(DialogInterface dialog, int item) {

					    }
		});
		AlertDialog alert = builder.create();
		return alert;
		}
	public boolean onOptionsItemSelected(MenuItem item) {

		switch (item.getItemId()) {
	
		case MENU_MAP:
			showDialog(MENU_MAP);
			break;
		}
		return super.onOptionsItemSelected(item);
	}
	public GeoPoint getCenter(MapView mapview, Activity activity) {
		LocationManager lm = (LocationManager) activity
				.getSystemService(Context.LOCATION_SERVICE);
		Location center = getLocationProvider(lm);
		GeoPoint gpoint = null;
		boolean debug = false;
		if (center == null || !debug) {
//			Object mLocation = poiService.getDefaultLoaction();
//			gpoint = mLocation.getGeoPoint();
		} else {
			gpoint = new GeoPoint((int) (center.getLatitude() * 1e6),
					(int) (center.getLongitude() * 1e6));
		}
		return gpoint;
	}

	public Location getLocationProvider(LocationManager lm) {
		Location retLocation = null;
		try {

			Criteria mCriteria01 = new Criteria();
			mCriteria01.setAccuracy(Criteria.ACCURACY_FINE);
//			 mCriteria01.setAccuracy(Criteria.ACCURACY_COARSE);
			mCriteria01.setAltitudeRequired(false);
			mCriteria01.setBearingRequired(false);
			mCriteria01.setCostAllowed(true);
			mCriteria01.setPowerRequirement(Criteria.POWER_LOW);
			String strLocationProvider = lm.getBestProvider(mCriteria01, true);
			retLocation = lm.getLastKnownLocation(strLocationProvider);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return retLocation;
	};
	
	private void findViews() {
		
		
//		mpviewLoyout = (maplocationviewer) findViewById(R.id.mapview);
		mpviewLoyout.setcontext(gov.this);
		mapview = mpviewLoyout.getMapView();
		
			// Zooming
//		zoom = (ViewGroup) findViewById(R.id.zoomview);
//		zoom.addView(mapview.getZoomControls());

	}

	public Location getLocationProvider(Context googlemap_activity) {

		LocationManager lm = (LocationManager) googlemap_activity
				.getSystemService(Context.LOCATION_SERVICE);
		Location retLocation = null;
		try {
			Criteria mCriteria01 = new Criteria();
			// mCriteria01.setAccuracy(Criteria.ACCURACY_FINE);
			mCriteria01.setAccuracy(Criteria.ACCURACY_COARSE);
			mCriteria01.setAltitudeRequired(false);
			mCriteria01.setBearingRequired(false);
			mCriteria01.setCostAllowed(true);
			mCriteria01.setPowerRequirement(Criteria.POWER_LOW);
			String strLocationProvider = lm.getBestProvider(mCriteria01, true);
			retLocation = lm.getLastKnownLocation(strLocationProvider);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return retLocation;
	};

}