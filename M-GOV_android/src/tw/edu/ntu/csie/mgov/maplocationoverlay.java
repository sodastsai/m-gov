package tw.edu.ntu.csie.mgov;


import java.util.Iterator;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Point;
import android.graphics.RectF;
import android.graphics.Paint.Style;
import android.view.MotionEvent;
import android.widget.Toast;

import com.google.android.maps.GeoPoint;
import com.google.android.maps.MapView;
import com.google.android.maps.Overlay;

public class maplocationoverlay  extends Overlay {

	//  Store these as global instances so we don't keep reloading every time
    private Bitmap bubbleIcon, shadowIcon;
    
    private maplocationviewer mapLocationViewer;
    
	private Paint	innerPaint, borderPaint, textPaint;
    private Context c;
    long startTime,endTime,diff;
    MapLocation ok =null;
    //  The currently selected Map Location...if any is selected.  This tracks whether an information  
    //  window should be displayed & where...i.e. whether a user 'clicked' on a known map location
    private MapLocation selectedMapLocation;  
    
	public maplocationoverlay(maplocationviewer	mapLocationViewer) {
		
		this.mapLocationViewer = mapLocationViewer;
		bubbleIcon = BitmapFactory.decodeResource(mapLocationViewer.getResources(),R.drawable.bubble);
		shadowIcon = BitmapFactory.decodeResource(mapLocationViewer.getResources(),R.drawable.shadow);
	}
	
//	@Override
//	public boolean onTouchEvent(android.view.MotionEvent ev, MapView mapView) {
//	
//		if(gov.set == 1){
//		int X = (int)ev.getX(); 
//        int Y = (int)ev.getY(); 
//        int eventaction = ev.getAction();
//        GeoPoint g = null;
//        switch (eventaction ) { 
//
//        case MotionEvent.ACTION_DOWN: // touch down so check if the finger is on a ball
//        	g = mapView.getProjection().fromPixels(X, Y);
//             break; 
//
//
//        case MotionEvent.ACTION_MOVE:   // touch drag with the ball
//        
//        	
//            break; 
//
//        case MotionEvent.ACTION_UP: 
//        	mapLocationViewer.setMapLocations(g.getLatitudeE6()/1000000,g.getLongitudeE6()/1000000);
//
//             break; 
//        } 
//		}
//		gov.set = 0;
//        return true; 
//	}
	@Override
	public boolean onTap(GeoPoint p, MapView	mapView)  {
		
		//  Store whether prior popup was displayed so we can call invalidate() & remove it if necessary.
		boolean isRemovePriorPopup = selectedMapLocation != null;  

		//  Next test whether a new popup should be displayed
		selectedMapLocation = getHitMapLocation(mapView,p);
		if ( isRemovePriorPopup || selectedMapLocation != null) {
			mapView.invalidate();
		}		
		
		//  Lastly return true if we handled this onTap()
		return selectedMapLocation != null;
	}
	
    @Override
	public void draw(Canvas canvas, MapView	mapView, boolean shadow) {
    	
   		drawMapLocations(canvas, mapView, shadow);
   		drawInfoWindow(canvas, mapView, shadow);
    }

 private MapLocation getHitMapLocation(MapView	mapView, GeoPoint	tapPoint) {
    	
    	//  Track which MapLocation was hit...if any
    	MapLocation hitMapLocation = null;
		
    	RectF hitTestRecr = new RectF();
		Point screenCoords = new Point();
    	Iterator<MapLocation> iterator = mapLocationViewer.getMapLocations().iterator();
    	while(iterator.hasNext()) {
    		MapLocation testLocation = iterator.next();
    		
    		//  Translate the MapLocation's lat/long coordinates to screen coordinates
    		mapView.getProjection().toPixels(testLocation.getPoint(), screenCoords);

	    	// Create a 'hit' testing Rectangle w/size and coordinates of our icon
	    	// Set the 'hit' testing Rectangle with the size and coordinates of our on screen icon
    		hitTestRecr.set(-bubbleIcon.getWidth()/2,-bubbleIcon.getHeight(),bubbleIcon.getWidth()/2,0);
    		hitTestRecr.offset(screenCoords.x,screenCoords.y);

	    	//  Finally test for a match between our 'hit' Rectangle and the location clicked by the user
    		mapView.getProjection().toPixels(tapPoint, screenCoords);
    		if (hitTestRecr.contains(screenCoords.x,screenCoords.y)) {
    			hitMapLocation = testLocation;
    			break;
    		}
    	}
    	
    	//  Lastly clear the newMouseSelection as it has now been processed
    	tapPoint = null;
    	
    	return hitMapLocation; 
    }
    
    private void drawMapLocations(Canvas canvas, MapView	mapView, boolean shadow) {
    	
		Iterator<MapLocation> iterator = mapLocationViewer.getMapLocations().iterator();
		Point screenCoords = new Point();
    	while(iterator.hasNext()) {	   
    		MapLocation location = iterator.next();
    		mapView.getProjection().toPixels(location.getPoint(), screenCoords);
			
	    	if (shadow) {
	    		//  Only offset the shadow in the y-axis as the shadow is angled so the base is at x=0; 
	    		canvas.drawBitmap(shadowIcon, screenCoords.x, screenCoords.y - shadowIcon.getHeight(),null);
	    	} else {
    			canvas.drawBitmap(bubbleIcon, screenCoords.x - bubbleIcon.getWidth()/2, screenCoords.y - bubbleIcon.getHeight(),null);
	    	}
    	}
    }

    private void drawInfoWindow(Canvas canvas, MapView	mapView, boolean shadow) {
    	
    	if ( selectedMapLocation != null) {
    		if ( shadow) {
    			//  Skip painting a shadow in this tutorial
    		} else {
				//  First determine the screen coordinates of the selected MapLocation
				Point selDestinationOffset = new Point();
				mapView.getProjection().toPixels(selectedMapLocation.getPoint(), selDestinationOffset);
		    	
		    	//  Setup the info window with the right size & location
				int INFO_WINDOW_WIDTH = 125;
				int INFO_WINDOW_HEIGHT = 25;
				RectF infoWindowRect = new RectF(0,0,INFO_WINDOW_WIDTH,INFO_WINDOW_HEIGHT);				
				int infoWindowOffsetX = selDestinationOffset.x-INFO_WINDOW_WIDTH/2;
				int infoWindowOffsetY = selDestinationOffset.y-INFO_WINDOW_HEIGHT-bubbleIcon.getHeight();
				infoWindowRect.offset(infoWindowOffsetX,infoWindowOffsetY);

				//  Draw inner info window
				canvas.drawRoundRect(infoWindowRect, 5, 5, getInnerPaint());
				
				//  Draw border for info window
				canvas.drawRoundRect(infoWindowRect, 5, 5, getBorderPaint());
					
				//  Draw the MapLocation's name
				int TEXT_OFFSET_X = 10;
				int TEXT_OFFSET_Y = 15;
				canvas.drawText(selectedMapLocation.getName(),infoWindowOffsetX+TEXT_OFFSET_X,infoWindowOffsetY+TEXT_OFFSET_Y,getTextPaint());
			}
    	}
    }

	public Paint getInnerPaint() {
		if ( innerPaint == null) {
			innerPaint = new Paint();
			innerPaint.setARGB(225, 75, 75, 75); //gray
			innerPaint.setAntiAlias(true);
		}
		return innerPaint;
	}

	public Paint getBorderPaint() {
		if ( borderPaint == null) {
			borderPaint = new Paint();
			borderPaint.setARGB(255, 255, 255, 255);
			borderPaint.setAntiAlias(true);
			borderPaint.setStyle(Style.STROKE);
			borderPaint.setStrokeWidth(2);
		}
		return borderPaint;
	}

	public Paint getTextPaint() {
		if ( textPaint == null) {
			textPaint = new Paint();
			textPaint.setARGB(255, 255, 255, 255);
			textPaint.setAntiAlias(true);
		}
		return textPaint;
	}
}