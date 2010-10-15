package tw.edu.ntu.mgov.addcase;

import java.io.IOException;
import java.util.Locale;

import tw.edu.ntu.mgov.R;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.ShapeDrawable;
import android.location.Address;
import android.location.Geocoder;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Bundle;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

import com.google.android.maps.GeoPoint;
import com.google.android.maps.MapActivity;
import com.google.android.maps.MapView;

import de.android1.overlaymanager.ManagedOverlay;
import de.android1.overlaymanager.ManagedOverlayGestureDetector;
import de.android1.overlaymanager.ManagedOverlayItem;
import de.android1.overlaymanager.MarkerRenderer;
import de.android1.overlaymanager.OverlayManager;
import de.android1.overlaymanager.ZoomEvent;

/**
 * @author vagrants
 * 2010/10/9
 * @company NTU CSIE Mobile HCI Lab
 */
public class SelectLocationMap extends MapActivity {

	private MapView mapView;
	private Toast addressToast;
	
	private OverlayManager overlayManager;
	private Geocoder geocoder;
	
	private GeoPoint previousGeoPoint;
	private GeoPoint selectedGeoPoint;
	private GeoPoint userLocationGeoPoint;	// used for user want to relocate his location
	
	private String address;
	
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
		setPreviousGeoPoint();
		setupMapView();
		setupButtonsListener();
		
		geocoder = new Geocoder(this, Locale.getDefault());
	}
	
	@Override
	public void onWindowFocusChanged(boolean b) {
		createOverlayWithListener();
	}

	private void setPreviousGeoPoint() {
		Bundle bundle = getIntent().getExtras();
		
		int latitudeE6  = bundle.getInt(BUNDLE_LATE6, -1);
		int longitudeE6 = bundle.getInt(BUNDLE_LONE6, -1);
		
		if (latitudeE6 != -1 && longitudeE6 != -1) {
			previousGeoPoint = new GeoPoint(latitudeE6, longitudeE6);
		} else {
			Log.e(LOGTAG, "!!! does not contains the default location");
			this.finish();
		}
	}
	
	private void setupMapView() {
		mapView = (MapView) findViewById(R.id.AddCase_SelectLication_MapView);
		mapView.setBuiltInZoomControls(true);
		mapView.getController().setCenter(previousGeoPoint);
		overlayManager = new OverlayManager(this, mapView);
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
	
	private void createOverlayWithListener() {
		
		final ManagedOverlay managedOverlay = overlayManager.createOverlay("listenerOverlay", getResources().getDrawable(android.R.drawable.btn_star_big_on));
		
		final Drawable marker = this.getResources().getDrawable(R.drawable.mapoverlay_greenpin);
		
		managedOverlay.setCustomMarkerRenderer(new MarkerRenderer() {
			@Override
			public Drawable render(ManagedOverlayItem item, Drawable defaultMarker, int bitState) {
				
				int currentLocationMarkerHalfWidth =  marker.getIntrinsicWidth()/2;
				int currentLocationMarkerHalfHeight =  marker.getIntrinsicHeight()/2;
				marker.setBounds(-currentLocationMarkerHalfWidth, -currentLocationMarkerHalfHeight, currentLocationMarkerHalfWidth, currentLocationMarkerHalfHeight);
				
				return marker;
			}
		});
		
		managedOverlay.setOnOverlayGestureListener(new ManagedOverlayGestureDetector.OnOverlayGestureListener() {

			@Override
			public boolean onDoubleTap(MotionEvent arg0, ManagedOverlay arg1, GeoPoint arg2, ManagedOverlayItem arg3) {
				
				return false;
			}

			@Override
			public void onLongPress(MotionEvent arg0, ManagedOverlay arg1) {
				// TODO Auto-generated method stub
			}

			@Override
			public void onLongPressFinished(MotionEvent arg0, ManagedOverlay arg1, GeoPoint arg2, ManagedOverlayItem arg3) {
				// TODO Auto-generated method stub
			}

			@Override
			public boolean onScrolled(MotionEvent arg0, MotionEvent arg1, float arg2, float arg3, ManagedOverlay arg4) {
				return false;
			}

			@Override
			public boolean onSingleTap(MotionEvent arg0, ManagedOverlay arg1, GeoPoint arg2, ManagedOverlayItem arg3) {
				// TODO Auto-generated method stub
				
				ManagedOverlayItem item = managedOverlay.createItem(arg2, "onLongPressFinished", "");
				
				if (checkNetworkStatus(SelectLocationMap.this)) {
				
					address = getAddress(arg2);
				
					if (addressToast != null ) {
						addressToast.cancel();
					}
				
					addressToast = Toast.makeText(SelectLocationMap.this, address, Toast.LENGTH_SHORT);
					addressToast.show();
				} else {
					address = null;
				}
				
				managedOverlay.add(item);
				mapView.getController().animateTo(arg2);
				overlayManager.populate();
				selectedGeoPoint = arg2;
				
				return false;
			}

			@Override
			public boolean onZoom(ZoomEvent arg0, ManagedOverlay arg1) {
				// TODO Auto-generated method stub
				return false;
			}
			
		});

		
		overlayManager.populate();
	}
	
	private String getAddress (GeoPoint geoPoint) {
		
		double latitude = ((double)geoPoint.getLatitudeE6() /1e6) ;
		double longitude = ((double)geoPoint.getLongitudeE6() /1e6) ;
		
		Address a = null;
		
		try {
			a = geocoder.getFromLocation(latitude, longitude, 1).get(0);
		} catch (IOException e) {
			Log.e(LOGTAG, "fail to get form location ", e);
			return "";
		}
		
		return a.getAddressLine(0);
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
