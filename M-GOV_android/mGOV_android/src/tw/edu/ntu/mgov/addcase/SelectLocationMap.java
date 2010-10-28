package tw.edu.ntu.mgov.addcase;

import java.io.IOException;
import java.util.Locale;

import tw.edu.ntu.mgov.PopoutItemizedOverlay;
import tw.edu.ntu.mgov.R;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.location.Address;
import android.location.Geocoder;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Bundle;
import android.util.Log;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ZoomControls;
import android.widget.RelativeLayout.LayoutParams;

import com.google.android.maps.GeoPoint;
import com.google.android.maps.MapActivity;
import com.google.android.maps.MapView;
import com.google.android.maps.OverlayItem;

/**
 * @author vagrants
 * 2010/10/9
 * @company NTU CSIE Mobile HCI Lab
 */
public class SelectLocationMap extends MapActivity {

	private MapView mapView;
	private ZoomControls mapZoomControl;
	private TextView addrLabel;
	private int motionEventCount;
	
	private GeoPoint previousGeoPoint;
	private GeoPoint selectedGeoPoint;
	private GeoPoint userLocationGeoPoint;	// used for user want to relocate his location
	
	private String address;
	private PopoutItemizedOverlay overlay;
	
	// define the tag of bundle that exchanges information to other Activity 
	public static final String BUNDLE_LONE6 = "bundle_lone6";
	public static final String BUNDLE_LATE6 = "bundle_late6";
	public static final String BUNDLE_ADDRESS = "bundle-address"; 
	
	private static final String LOGTAG = "mGOV-SelectLocationMap";
	
	@Override
	protected void onCreate(Bundle icicle) {
		super.onCreate(icicle);
		setTitle("請選擇案件地點");
		setContentView(R.layout.addcase_select_location);
		
		addrLabel = (TextView)findViewById(R.id.addcase_locationSelector_addrLabel);
		
		setupMapView();
		setPreviousGeoPoint();
		setupButtonsListener();
	}
	
	@Override
	protected void onResume() {
		Toast selectHint = Toast.makeText(this, getResources().getString(R.string.addcase_locationSelector_hint), Toast.LENGTH_LONG);
		selectHint.setGravity(Gravity.BOTTOM|Gravity.CENTER_HORIZONTAL, 0, 120);
		selectHint.show();
		selectHint=null;
		super.onResume();
	}

	private void setPreviousGeoPoint() {
		Bundle bundle = getIntent().getExtras();
		
		int latitudeE6  = bundle.getInt(BUNDLE_LATE6, -1);
		int longitudeE6 = bundle.getInt(BUNDLE_LONE6, -1);
		
		if (latitudeE6 != -1 && longitudeE6 != -1) {
			previousGeoPoint = new GeoPoint(latitudeE6, longitudeE6);
			addrLabel.setText(getAddress(previousGeoPoint, this));
			mapView.getOverlays().clear();
			overlay.clearOverLayList();
			overlay.addOverlay(new OverlayItem(previousGeoPoint, "", ""));
			mapView.getOverlays().add(overlay);
			mapView.invalidate();
			
			mapView.getController().animateTo(previousGeoPoint);
			
		} else {
			Log.e(LOGTAG, "!!! does not contains the default location");
			this.finish();
		}
	}
	
	private void setupMapView() {
		mapView = new MapView(this, getResources().getString(R.string.google_mapview_api_key)) {
			@Override
			public boolean onTouchEvent(MotionEvent ev) {
				if (ev.getAction()==MotionEvent.ACTION_DOWN) {
					motionEventCount=0;
				} else if (ev.getAction()==MotionEvent.ACTION_MOVE) {
					motionEventCount++;
				} else if (ev.getAction()==MotionEvent.ACTION_UP) {
					// Android is too sensitive
					if (motionEventCount<=3) {
						// Fetch Location
						selectedGeoPoint = mapView.getProjection().fromPixels((int)ev.getX(), (int)ev.getY());
						// Convert to Address
						if (checkNetworkStatus(SelectLocationMap.this)) address = getAddress(selectedGeoPoint, getApplicationContext());
						else address = null;
						// Update Label
						if (address!=null) addrLabel.setText(address);
						else addrLabel.setText(getResources().getString(R.string.addcase_locationSelector_addrNull));
						// Add Overlay
						mapView.getOverlays().clear();
						overlay.clearOverLayList();
						overlay.addOverlay(new OverlayItem(selectedGeoPoint, "", ""));
						mapView.getOverlays().add(overlay);
						mapView.invalidate();
					}
				}
				return super.onTouchEvent(ev);
			}
		};
		RelativeLayout.LayoutParams param = new RelativeLayout.LayoutParams(LayoutParams.FILL_PARENT, LayoutParams.FILL_PARENT);
		param.addRule(RelativeLayout.ALIGN_PARENT_TOP, RelativeLayout.ALIGN_PARENT_LEFT);
		mapView.setClickable(true);
		mapView.setEnabled(true);
		mapView.setBuiltInZoomControls(false);
		mapZoomControl = (ZoomControls)findViewById(R.id.LocationSelectoyZoomControl);
		mapZoomControl.setOnZoomInClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) { mapView.getController().zoomIn(); }
		});
		mapZoomControl.setOnZoomOutClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) { mapView.getController().zoomOut(); }
		});
		RelativeLayout frame = (RelativeLayout)findViewById(R.id.addcase_locationSelector_mapFrame);
		frame.addView(mapView, 0, param);
		param=null;
		frame=null;
		
		overlay = new PopoutItemizedOverlay(getResources().getDrawable(R.drawable.okspot), mapView) {
			@Override
			public boolean onTap(GeoPoint p, MapView mapView) {
				return false;
			}
		};
		// Get Current User Location
		LocationManager locationManager = (LocationManager) this.getSystemService(Context.LOCATION_SERVICE);
		LocationListener locationListener = new LocationListener() {
			@Override
			public void onLocationChanged(Location location) {
				userLocationGeoPoint = new GeoPoint((int)(location.getLatitude()*Math.pow(10, 6)), (int)(location.getLongitude()*Math.pow(10, 6)));
				mapView.getController().animateTo(userLocationGeoPoint);
				userLocationGeoPoint=mapView.getMapCenter();
			}
			@Override
			public void onProviderDisabled(String provider) {}
			@Override
			public void onProviderEnabled(String provider) {}
			@Override
			public void onStatusChanged(String provider, int status, Bundle extras) {}
		};
		locationManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, 0, 0, locationListener);
		Location lastKnownLocation = locationManager.getLastKnownLocation(LocationManager.NETWORK_PROVIDER);
		if (lastKnownLocation!=null) {
			userLocationGeoPoint = new GeoPoint((int)(lastKnownLocation.getLatitude()*Math.pow(10, 6)), (int)(lastKnownLocation.getLongitude()*Math.pow(10, 6)));
			mapView.getController().animateTo(userLocationGeoPoint);
			userLocationGeoPoint=mapView.getMapCenter();
		}
		locationManager.removeUpdates(locationListener);
		locationListener = null;
		
		addrLabel.setText(getAddress(userLocationGeoPoint, this));
		overlay.addOverlay(new OverlayItem(userLocationGeoPoint, "", ""));
		mapView.getOverlays().clear();
		mapView.getOverlays().add(overlay);
		mapView.invalidate();
		
		addrLabel.setText(getAddress(userLocationGeoPoint, this));
		mapView.getController().setCenter(userLocationGeoPoint);
	}
	
	private void setupButtonsListener() {
		Button btn;
		
		btn = (Button) findViewById(R.id.AddCase_SelectLication_Btn_Confirm);
		btn.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				if (selectedGeoPoint == null) {	/* no new location is select, return to previous Activity as CANCELLED */
					setResult(Activity.RESULT_CANCELED);
					finish();
				} else {
					Bundle bundle = new Bundle();
					bundle.putInt(BUNDLE_LATE6, selectedGeoPoint.getLatitudeE6());
					bundle.putInt(BUNDLE_LONE6, selectedGeoPoint.getLongitudeE6());
					bundle.putString(BUNDLE_ADDRESS, address);
					bundle.putInt("zoomLevel", mapView.getZoomLevel());
					
					Intent intent = new Intent();
					intent.putExtras(bundle);
					setResult(Activity.RESULT_OK, intent);
					finish();
				}
			}
		});
		
		btn = (Button) findViewById(R.id.AddCase_SelectLication_Btn_Cancel);
		btn.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				setResult(Activity.RESULT_CANCELED);
				finish();
			}
		});
	}
	
	private boolean checkNetworkStatus(Context context) {
		ConnectivityManager manager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
		NetworkInfo networkInfo = manager.getActiveNetworkInfo();
		if (networkInfo == null || !networkInfo.isAvailable()) {
			return false;
		}
		return true;
	}	
		
	static String getAddress (GeoPoint geoPoint, Context c) {
		
		double latitude = ((double)geoPoint.getLatitudeE6() /1e6) ;
		double longitude = ((double)geoPoint.getLongitudeE6() /1e6) ;
		
		Address a = null;
		
		try {
			Geocoder geocoder = new Geocoder(c, Locale.getDefault());
			a = geocoder.getFromLocation(latitude, longitude, 1).get(0);
		} catch (IOException e) {
			Log.e(LOGTAG, "fail to get form location ", e);
			return "";
		}
		
		return a.getAddressLine(0).substring(5);
	}
	
	@Override
	protected boolean isRouteDisplayed() {
		return false;
	}
}
