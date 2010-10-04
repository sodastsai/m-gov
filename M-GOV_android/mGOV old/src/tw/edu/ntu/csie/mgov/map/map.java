package tw.edu.ntu.csie.mgov.map;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.xml.sax.SAXException;

import tw.edu.ntu.csie.mgov.R;
import tw.edu.ntu.csie.mgov.R.drawable;
import tw.edu.ntu.csie.mgov.R.id;
import tw.edu.ntu.csie.mgov.R.layout;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.graphics.Color;
import android.os.Bundle;
import android.util.Log;
import android.view.MotionEvent;
import android.widget.Toast;

import com.google.android.maps.GeoPoint;
import com.google.android.maps.MapActivity;
import com.google.android.maps.MapView;

import de.android1.overlaymanager.ManagedOverlay;
import de.android1.overlaymanager.ManagedOverlayGestureDetector;
import de.android1.overlaymanager.ManagedOverlayItem;
import de.android1.overlaymanager.OverlayManager;
import de.android1.overlaymanager.ZoomEvent;

public class map extends MapActivity {

	/** Called when the activity is first created. */

	MapView mapView;
	OverlayManager overlayManager;
	int src_lat;
	int src_long;
	int dest_lat;
	int dest_long;
	int s = 0;
	GeoPoint srcGeoPoint;
	GeoPoint destGeoPoint;
	
	@Override
	public void onWindowFocusChanged(boolean b) {
		// uncomment the overlayer you want to see.

		 createOverlayWithListener();

	}
	
	public void createOverlayWithListener() {
        //This time we use our own marker
		ManagedOverlay managedOverlay = overlayManager.createOverlay("listenerOverlay", getResources().getDrawable(R.drawable.icon));

		managedOverlay.setOnOverlayGestureListener(new ManagedOverlayGestureDetector.OnOverlayGestureListener() {
			@Override
			public boolean onZoom(ZoomEvent zoom, ManagedOverlay overlay) {
				Toast.makeText(getApplicationContext(), "Zoom yeah!", Toast.LENGTH_SHORT).show();
				return false;
			}

			@Override
			public boolean onDoubleTap(MotionEvent e, ManagedOverlay overlay, GeoPoint point, ManagedOverlayItem item) {
//				mapController.animateTo(point);
//				mapController.zoomIn();
				return true;
			}

			@Override
			public void onLongPress(MotionEvent e, ManagedOverlay overlay) {
//				Toast.makeText(getApplicationContext(), "LongPress incoming...!", Toast.LENGTH_SHORT).show();
			}

			@Override
			public void onLongPressFinished(MotionEvent e, ManagedOverlay overlay, GeoPoint point, ManagedOverlayItem item) {
				
				AlertDialog.Builder builder = new AlertDialog.Builder(map.this);
				builder.setIcon(R.drawable.icon);
				builder.setTitle("選擇地點");
				
				builder.setMessage(String.valueOf(point.getLatitudeE6())+" "+String.valueOf(point.getLongitudeE6()));
				builder.setPositiveButton("OK",
						new DialogInterface.OnClickListener() {
							public void onClick(DialogInterface dialog, int whichButton) {
								
							}
						});

				builder.setNegativeButton("取消", new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int whichButton) {
						
						
					}
				});
				
				builder.create();
				builder.show();
			}

			@Override
			public boolean onScrolled(MotionEvent e1, MotionEvent e2, float distanceX, float distanceY, ManagedOverlay overlay) {
				return false;
			}

			@Override
			public boolean onSingleTap(MotionEvent e, ManagedOverlay overlay, GeoPoint point, ManagedOverlayItem item) {
				return false;
			}
		});
		overlayManager.populate();
	}
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
	super.onCreate(savedInstanceState);
	setContentView(R.layout.map);

	mapView = (MapView) findViewById(R.id.myMapView1);

//	mapView.getController().animateTo(srcGeoPoint1);
	mapView.getController().setZoom(15);
	overlayManager = new OverlayManager(getApplication(), mapView);
	
	}
	
	@Override
	protected boolean isRouteDisplayed() {
	// TODO Auto-generated method stub
	return false;
	}


}