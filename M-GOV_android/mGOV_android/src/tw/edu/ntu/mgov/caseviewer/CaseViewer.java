/**
 * 
 */
package tw.edu.ntu.mgov.caseviewer;

import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;

import org.json.JSONException;

import tw.edu.ntu.mgov.R;
import tw.edu.ntu.mgov.gae.GAECase;
import tw.edu.ntu.mgov.gae.GAEQuery;
import tw.edu.ntu.mgov.typeselector.QidToDescription;

import com.google.android.maps.ItemizedOverlay;
import com.google.android.maps.MapActivity;
import com.google.android.maps.MapView;
import com.google.android.maps.OverlayItem;

import android.app.ProgressDialog;
import android.graphics.Canvas;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

/**
 * @author shou
 * 2010/10/13
 * @company NTU CSIE Mobile HCI Lab
 */
public class CaseViewer extends MapActivity implements Runnable {

	// Views 
	private ImageView photoView;
	private MapView mapView;
	private TextView caseID;
	private TextView date;
	private TextView caseStatus;
	private TextView caseType;
	private TextView description;
	private TextView caseAddress;
	
	GAEQuery qGAE;
	GAECase queryResult;
	private ProgressDialog loadingView;
	protected Drawable image;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		loadingView = ProgressDialog.show(this, "", getResources().getString(R.string.loading_message), false);
		Thread thread = new Thread(this);
		thread.start();
		super.onCreate(savedInstanceState);
		setTitle("案件資料");
		setContentView(R.layout.caseviewer);
		findAllViews();
	}
	private Handler handler = new Handler() {
		public void handleMessage(Message msg) {
			loadingView.cancel();
			setAllAttributes();
		}
	};
	@Override
	public void run() {
		qGAE = new GAEQuery();
		try {
			queryResult = qGAE.getID(getIntent().getExtras().getString("caseID"));
		} catch (JSONException e) {
			e.printStackTrace();
		}
		String [] imageURL = queryResult.getImage();
		image = LoadImageFromWebOperations(imageURL[0].replace("GET_SHOW_PHOTO.CFM?photo_filename=", "photo/"));
		handler.sendEmptyMessage(0);
	}

	private void findAllViews() {
		photoView = (ImageView) findViewById(R.id.CaseViewer_Photo);
		mapView = (MapView) findViewById(R.id.CaseViewer_Map);
		caseID = (TextView) findViewById(R.id.CaseViewer_CaseID);
		date = (TextView) findViewById(R.id.CaseViewer_Date);
		caseStatus = (TextView) findViewById(R.id.CaseViewer_CaseStatus);
		caseType = (TextView) findViewById(R.id.CaseViewer_CaseType);
		description = (TextView) findViewById(R.id.CaseViewer_Description);
		caseAddress = (TextView) findViewById(R.id.CaseViewer_Address);
	}
	
	protected class MapOverlay extends ItemizedOverlay<OverlayItem> {
		private ArrayList<OverlayItem> gList = new ArrayList<OverlayItem>();
		Drawable marker;
		public MapOverlay(Drawable defaultMarker) {
			super(defaultMarker);
			marker = defaultMarker;
		}
		protected void addOverlayItem(OverlayItem oItem) {
			gList.add(oItem);
			populate();
		}
		
		@Override
		public void draw(Canvas canvas, MapView mapView, boolean shadow) {
			super.draw(canvas, mapView, false);
			boundCenterBottom(marker);
		}
		@Override
		protected OverlayItem createItem(int i) {
			return gList.get(i);
		}
		@Override
		public int size() {
			return gList.size();
		}
		
	}
	
	private void setAllAttributes() {
		caseID.setText(queryResult.getform("key"));
		date.setText(queryResult.getform("date"));
		caseStatus.setText(queryResult.getform("status"));
		caseType.setText(QidToDescription.getDetailByQID(this, Integer.parseInt(queryResult.getform("typeid"))));
		description.setText(queryResult.getform("detail"));
		caseAddress.setText(queryResult.getform("address"));
		
		photoView.setImageDrawable(image);
		TextView tv = (TextView) findViewById(R.id.CaseViewer_NoPhotoMessege);
		if (image==null) tv.setVisibility(View.VISIBLE);
		else tv.setVisibility(View.INVISIBLE);
		
		Drawable marker = this.getResources().getDrawable(R.drawable.mapoverlay_greenpin);
		MapOverlay mapOverlay = new MapOverlay(marker);
		OverlayItem overlayItem = new OverlayItem(queryResult.getGeoPoint(), "....", "");
		mapOverlay.addOverlayItem(overlayItem);
		mapView.getOverlays().add(mapOverlay);
		mapView.getController().animateTo(queryResult.getGeoPoint());
	}
	
	private Drawable LoadImageFromWebOperations(String url)	{
		InputStream is;
		try {
			is = (InputStream) new URL(url).getContent();
			Drawable d = Drawable.createFromStream(is, "caseviewer photo");
			return d;
		} catch (MalformedURLException e) {
			e.printStackTrace();
			return null;
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		}
	}

	@Override
	protected boolean isRouteDisplayed() {
		return false;
	}
	
}
