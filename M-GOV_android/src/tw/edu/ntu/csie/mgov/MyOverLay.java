package tw.edu.ntu.csie.mgov;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Point;
import android.graphics.RectF;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.GestureDetector.OnGestureListener;
import android.widget.Toast;

import com.google.android.maps.GeoPoint;
import com.google.android.maps.MapView;
import com.google.android.maps.Overlay;
import com.google.android.maps.Projection;


public class MyOverLay extends Overlay{
	private GeoPoint gp1;
	private GeoPoint gp2;
	private int mRadius = 6;
	private int mode = 0;
	private int defaultColor;
	private String text = "";
	private Bitmap img = null;
	Activity act;
	
	public MyOverLay(GeoPoint gp1, Activity c) // GeoPoint is a int.// (6E)
	{
		this.act = c;
		this.gp1 = gp1;
		this.gp2 = gp2;
		this.mode = mode;
		defaultColor = 999; // no defaultColor
		img = BitmapFactory.decodeResource(c.getResources(), R.drawable.mylocation);
	}


	@Override
	public boolean onTap(GeoPoint p, MapView mapView) {
		
		Intent intent = new Intent();
		intent.setClass(act, map.class);
		act.startActivity(intent);
		return true;
	}

	@Override
	public boolean draw(Canvas canvas, MapView mapView, boolean shadow,
			long when) {
		Projection projection = mapView.getProjection();
		if (shadow == false) {
			Paint paint = new Paint();
			paint.setAntiAlias(true);
			Point point = new Point();
			projection.toPixels(gp1, point);
			
				if (defaultColor == 999)
					paint.setColor(Color.BLUE);
				else
					paint.setColor(defaultColor);
				
				RectF oval = new RectF(point.x - mRadius, point.y - mRadius,
						point.x + mRadius, point.y + mRadius);
				
//				canvas.drawOval(oval, paint);
				canvas.drawBitmap(img, point.x - mRadius, point.y - mRadius, paint);
		}
		return super.draw(canvas, mapView, shadow, when);
	}

}
