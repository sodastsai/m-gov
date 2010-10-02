package tw.edu.ntu.csie.mgov;

import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.location.Criteria;
import android.location.Location;
import android.location.LocationManager;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import com.google.android.maps.GeoPoint;
import com.google.android.maps.MapActivity;
import com.google.android.maps.MapView;

public class submit extends MapActivity {

	ImageView myImage;
	final int select_click_pic = 1;
	String pic_dialog_option = "";
	TextView take_pic, select_pic;
	MapView mapview;
	private EditText submit_name,submit_desc;
	Button btnSubmitType;
	Bitmap myBitmap;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.submit);
		
		findview();		
		setlistener();
		
		myBitmap = BitmapFactory.decodeFile(getIntent().getStringExtra("currentPic"));
		myImage.setImageBitmap(myBitmap);		
		
	}

	void setlistener() {

		myImage.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				showDialog(select_click_pic);
			}
		});

		btnSubmitType.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				Intent intent = new Intent();
				intent.setClass(submit.this, NoPicSubmit.class);
				startActivity(intent);
			}
		});
		
	}
	
	@Override
	protected Dialog onCreateDialog(int id) {

		switch (id) {
		case select_click_pic:
			return submitDialog();
		}
		return super.onCreateDialog(id);
	}
	
	Dialog submitDialog(){
		
		LayoutInflater inflater = LayoutInflater.from(this);
		final View textEntryView = inflater.inflate(R.layout.picture_dialog,null);
		
		take_pic = (TextView)textEntryView.findViewById(R.id.take_pic);
		select_pic = (TextView)textEntryView.findViewById(R.id.select_pic);
		
		take_pic.setText(getResources().getString(R.string.takePicture));
		select_pic.setText(getResources().getString(R.string.selectPicture));
		
		take_pic.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {

				Intent intent = new Intent();
				intent.setClass(submit.this, CameraActivity.class);
				startActivity(intent);
			}
		});
		
		select_pic.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				
				Intent intent = new Intent();
				intent.setClass(submit.this, photoGallery.class);
				startActivity(intent);
			}
		});
		
		AlertDialog.Builder builder = new AlertDialog.Builder(this);
		builder.setIcon(R.drawable.icon);
		builder.setTitle(getResources().getString(R.string.pickOrSelectPicture));
		builder.setView(textEntryView);
		
		return builder.create();
	}
	
	void findview(){
		myImage = (ImageView) findViewById(R.id.pic);	
		mapview = (MapView) findViewById(R.id.myMapView1);
		
//		double src_lat1 = 25.04202; // the testing source
//		double src_long1 = 121.534761;
//		double dest_lat = 25.05202; // the testing destination
//		double dest_long = 121.554761;
//		GeoPoint srcGeoPoint1 = new GeoPoint((int) (src_lat1 * 1E6),
//		(int) (src_long1 * 1E6));
		
		
		LocationManager lm = (LocationManager) this.getSystemService(Context.LOCATION_SERVICE);
		Location center = getLocationProvider(lm);
		GeoPoint gpoint = new GeoPoint((int) (center.getLatitude() * 1e6),(int) (center.getLongitude() * 1e6));
		mapview.getOverlays().add(new MyOverLay(gpoint,submit.this));
		mapview.getController().animateTo(gpoint);
		mapview.getController().setZoom(15);
		
		submit_name = (EditText)findViewById(R.id.submit_name);
		submit_desc = (EditText)findViewById(R.id.submit_suggestion);
		btnSubmitType = (Button)findViewById(R.id.submit_type_btn);
	}

	public Location getLocationProvider(LocationManager lm) {
		Location retLocation = null;
		try {

			Criteria mCriteria01 = new Criteria();
//			mCriteria01.setAccuracy(Criteria.ACCURACY_FINE);
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
	
	 @Override  
	 protected void onActivityResult(int requestCode, int resultCode, Intent data) {  

		super.onActivityResult(requestCode, resultCode, data);

		if (resultCode == RESULT_OK)
			btnSubmitType.setText("text");
	   }
	 
	@Override
	protected boolean isRouteDisplayed() {
		return false;
	}
}
