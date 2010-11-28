/*
 * 
 * CaseViewer.java
 * 2010/10/13
 * shou
 * 
 * Case Viewer
 *
 * Copyright 2010 NTU CSIE Mobile & HCI Lab
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */
package tw.edu.ntu.mgov1999.caseviewer;

import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;

import org.json.JSONException;

import tw.edu.ntu.mgov1999.R;
import tw.edu.ntu.mgov1999.gae.GAECase;
import tw.edu.ntu.mgov1999.gae.GAEQuery;
import tw.edu.ntu.mgov1999.typeselector.QidToDescription;

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
	
	private GAEQuery qGAE;
	private GAECase queryResult;
	private ProgressDialog loadingView;
	protected Drawable image;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		loadingView = ProgressDialog.show(this, "", getResources().getString(R.string.loading_message), false);
		Thread thread = new Thread(this);
		thread.start();
		super.onCreate(savedInstanceState);
		setTitle(getResources().getString(R.string.caseviewer_activity_title));
		setContentView(R.layout.caseviewer);
		findAllViews();
	}
	// Load Data in another thread
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
		if (imageURL!=null && imageURL.length!=0)
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
		
		Drawable marker = this.getResources().getDrawable(R.drawable.okspot);
		MapOverlay mapOverlay = new MapOverlay(marker);
		OverlayItem overlayItem = new OverlayItem(queryResult.getGeoPoint(), "", "");
		mapOverlay.addOverlayItem(overlayItem);
		mapView.getOverlays().add(mapOverlay);
		mapView.getController().animateTo(queryResult.getGeoPoint());
		mapView.getController().setZoom(17);
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
