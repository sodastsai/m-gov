/*
 * 
 * CaseSelector.java
 * 2010/10/04
 * sodas
 * 
 * This class is set for data source.
 * Unlike iPhone, Android do not have to put all views with same data source in view controller,
 * so there's no Hybrid activity.
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

package tw.edu.ntu.mgov;

import java.util.ArrayList;
import java.util.Date;

import com.google.android.maps.GeoPoint;
import com.google.android.maps.MapActivity;
import com.google.android.maps.MapView;
import com.google.android.maps.Overlay;
import com.google.android.maps.OverlayItem;
import com.readystatesoftware.mapviewballoons.BalloonItemizedOverlay;

import tw.edu.ntu.mgov.caseviewer.CaseViewer;
import tw.edu.ntu.mgov.gae.GAECase;
import tw.edu.ntu.mgov.gae.GAEQuery;
import tw.edu.ntu.mgov.gae.GAEQuery.GAEQueryDatabase;
import tw.edu.ntu.mgov.option.Option;
import tw.edu.ntu.mgov.typeselector.QidToDescription;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.ZoomControls;
import android.widget.RelativeLayout.LayoutParams;

public abstract class CaseSelector extends MapActivity {
	protected Context selfContext = this;
	// Constant Identifier for Menu
	protected static final int MENU_Option = Menu.FIRST;
	protected static final int MENU_ListMode = Menu.FIRST+1;
	protected static final int MENU_MapMode = Menu.FIRST+2;
	// Selector Mode
	protected static enum CaseSelectorMode {
		CaseSelectorListMode,
		CaseSelectorMapMode
	}
	public CaseSelectorMode currentMode;
	// Default Mode is List Mode
	protected CaseSelectorMode defaultMode = CaseSelectorMode.CaseSelectorListMode;
	protected Boolean noCaseImageWillShow = true;
	// Views
	protected RelativeLayout infoBar;
	protected ListView listMode;
	protected MapView mapMode;
	// Map Query
	protected GeoPoint currentLocationPoint;
	protected int currentLatSpan;
	protected int currentLonSpan;
	// Query Google App Engine
	protected GAEQuery qGAE;
	protected GAECase caseSource[];
	protected GAEQueryDatabase db = GAEQueryDatabase.GAEQueryDatabaseCase;
	protected int rangeStart = 0;
	protected int rangeEnd = 9;
	protected int sourceLength;
	protected boolean firstQuery = true;
	// Map Overlay
	protected PopoutItemizedOverlay okOverlay;
	protected PopoutItemizedOverlay unknownOverlay;
	protected PopoutItemizedOverlay failOverlay;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.caseselector);

		// Network connector
		qGAE = new GAEQuery();
		
		// Call Info bar from Layout XML
		infoBar = (RelativeLayout)findViewById(R.id.infoBar);
		
		// Call List View From Layout XML
		listMode = (ListView)findViewById(R.id.listMode);
		listMode.setAdapter(new caseListAdapter(this));
		listMode.setOnItemClickListener(new AdapterView.OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				if (caseSource!=null) {
					Intent caseViewerIntent = new Intent().setClass(selfContext, CaseViewer.class);
					caseViewerIntent.putExtra("caseID", caseSource[position].getform("key"));
					startActivity(caseViewerIntent);
				}
			}
		});
		
		// New Map by Java code for separate maps.
		mapMode = new MapView(this, getResources().getString(R.string.google_mapview_api_key)) {
			@Override
			public boolean onTouchEvent(MotionEvent ev) {
				if (ev.getAction()==MotionEvent.ACTION_UP) {
					boolean centerChanged = (Math.abs(mapMode.getMapCenter().getLatitudeE6()-currentLocationPoint.getLatitudeE6()) > mapMode.getLatitudeSpan()/3)||
											(Math.abs(mapMode.getMapCenter().getLongitudeE6()-currentLocationPoint.getLongitudeE6()) > mapMode.getLongitudeSpan()/3);
					boolean spanChanged = (Math.abs(mapMode.getLatitudeSpan()-currentLatSpan)>200)||(Math.abs(mapMode.getLongitudeSpan()-currentLonSpan)>200);
					
					if (centerChanged||spanChanged) {
						// Don't disturb user, so don't always not reload. Only reload while change is too big
						mapChangeRegionOrZoom();
					}
				}
				try {
					return super.onTouchEvent(ev);
				} catch (Exception e) {
					return true;
				}
			}
			
		};
		LayoutParams param1 = new RelativeLayout.LayoutParams(LayoutParams.FILL_PARENT, LayoutParams.FILL_PARENT);
		param1.addRule(RelativeLayout.ALIGN_PARENT_LEFT, RelativeLayout.ALIGN_PARENT_TOP);
		RelativeLayout mapModeFrame = (RelativeLayout)findViewById(R.id.mapModeFrame);
		mapModeFrame.addView(mapMode, 0, param1);
		// Set Map
		mapMode.setEnabled(true);
		mapMode.setClickable(true);
		mapMode.preLoad();
		mapMode.setBuiltInZoomControls(false); // Use custom Map Control instead
		mapMode.getController().setZoom(17);
		// Call Zoom Controll for Map Mode, since we want to show it automaticlly
		ZoomControls mapModeZoomControl = (ZoomControls)findViewById(R.id.mapModeZoomControl);
		mapModeZoomControl.setOnZoomInClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) { 
            	mapMode.getController().zoomIn();
            	mapChangeRegionOrZoom();
            }
		});
		mapModeZoomControl.setOnZoomOutClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
            	mapMode.getController().zoomOut();
            	mapChangeRegionOrZoom();
            }
		});
		
		// Get Current User Location
		LocationManager locationManager = (LocationManager) this.getSystemService(Context.LOCATION_SERVICE);
		LocationListener locationListener = new LocationListener() {
			@Override
			public void onLocationChanged(Location location) {
				currentLocationPoint = new GeoPoint((int)(location.getLatitude()*Math.pow(10, 6)), (int)(location.getLongitude()*Math.pow(10, 6)));
				mapMode.getController().animateTo(currentLocationPoint);
				currentLocationPoint=mapMode.getMapCenter();
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
			currentLocationPoint = new GeoPoint((int)(lastKnownLocation.getLatitude()*Math.pow(10, 6)), (int)(lastKnownLocation.getLongitude()*Math.pow(10, 6)));
			mapMode.getController().animateTo(currentLocationPoint);
			currentLocationPoint=mapMode.getMapCenter();
		}
		locationManager.removeUpdates(locationListener);
		locationListener = null;
		currentLocationPoint = mapMode.getMapCenter();
		currentLatSpan = 5873;
		currentLonSpan = 6436;
		
		// Set Overlay
		okOverlay = new PopoutItemizedOverlay(getResources().getDrawable(R.drawable.okspot), mapMode);
		unknownOverlay = new PopoutItemizedOverlay(getResources().getDrawable(R.drawable.unknownspot), mapMode);
		failOverlay = new PopoutItemizedOverlay(getResources().getDrawable(R.drawable.failspot), mapMode);
		
		// Change to Default Mode
		if (defaultMode==CaseSelectorMode.CaseSelectorListMode) {
			currentMode = CaseSelectorMode.CaseSelectorListMode;
			findViewById(R.id.mapModeFrame).setVisibility(View.GONE);
			findViewById(R.id.listModeFrame).setVisibility(View.VISIBLE);
		} else {
			currentMode = CaseSelectorMode.CaseSelectorMapMode;
			findViewById(R.id.listModeFrame).setVisibility(View.GONE);
			findViewById(R.id.mapModeFrame).setVisibility(View.VISIBLE);
		}
	}
	
	@Override
	protected void onResume() {
		super.onResume();
		startFetchDataSource();
	}

	protected void changCaseSelectorMode(CaseSelectorMode targetMode) {
		if (targetMode == CaseSelectorMode.CaseSelectorListMode) {
			findViewById(R.id.mapModeFrame).setVisibility(View.GONE);
			findViewById(R.id.listModeFrame).setVisibility(View.VISIBLE);
		} else {
			findViewById(R.id.mapModeFrame).setVisibility(View.VISIBLE);
			findViewById(R.id.listModeFrame).setVisibility(View.GONE);
		}
		currentMode = targetMode;
	}
	
	/**
	 * @category Menu
	 * 
	 */
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		menu.add(0, MENU_Option, 0, getResources().getString(R.string.menu_option)).setIcon(android.R.drawable.ic_menu_preferences);
		menu.add(0, MENU_ListMode, 0, getResources().getString(R.string.menu_ListMode)).setIcon(R.drawable.menu_list);
		menu.add(0, MENU_MapMode, 0, getResources().getString(R.string.menu_mapMode)).setIcon(android.R.drawable.ic_menu_mapmode);
		return super.onCreateOptionsMenu(menu);
	}
	
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		switch(item.getItemId()) {
			case MENU_ListMode:
				// Change Mode
				this.changCaseSelectorMode(CaseSelectorMode.CaseSelectorListMode);
				break;
			case MENU_MapMode:
				// Change Mode
				this.changCaseSelectorMode(CaseSelectorMode.CaseSelectorMapMode);
				break;
			case MENU_Option:
				// Go to Option Activity
				Intent intent = new Intent();
				intent.setClass(this, Option.class);
				startActivity(intent);
				break;
		}
		return super.onOptionsItemSelected(item);
	}
	
	// Set action for new action defined by subclasses.
	public abstract void menuActionToTake(MenuItem item);
	
	/**
	 * @category method 
	 *
	 */
	protected int convertStatusStringToStatusCode(String status) {
		if (status.equals("完工")||status.equals("結案")||status.equals("轉府外單位")) return 1;
		else if (status.equals("無法辦理")||status.equals("退回區公所")||status.equals("查驗未通過")) return 2;
		else return 0;
	}
	/**
	 * @category DataSource Method
	 */
	protected void startFetchDataSource() {
		ArrayList<Overlay> allOverlays = new ArrayList<Overlay>();
		allOverlays.add(okOverlay);
		allOverlays.add(unknownOverlay);
		allOverlays.add(failOverlay);
		BalloonItemizedOverlay.hideBallons(allOverlays);
		allOverlays.clear();
		allOverlays = null;
		
		// LoadingView
		final ProgressDialog loadingView = new ProgressDialog(selfContext);
		loadingView.setMessage(getResources().getString(R.string.loading_message));
		loadingView.show();
		
		// After Thread end
		final Handler loadingViewhandler = new Handler() {
			public void handleMessage(Message msg) {
				qGAEReturned();
				loadingView.cancel();
			}
		};
		
		// Fetch Data in another thread
		Thread qGAEThread = new Thread(new Runnable() {
			@Override
			public void run() {
				// A sputid way to solve the delay of map span
				try {
					Thread.sleep(800);
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
				// Set Query Condition and Start Query
				if(!setQGAECondition()) {
					loadingViewhandler.sendEmptyMessage(0);
					return;
				}
				caseSource = qGAE.doQuery(db, rangeStart, rangeEnd);
				sourceLength = qGAE.getSourceTotalLength();
				qGAE.resetCondition();
				loadingViewhandler.sendEmptyMessage(0);
			}
		});
		qGAEThread.start();
	}
	
	protected void qGAEReturned() {
		// Dummy check for slow app engine
		if ((caseSource == null || sourceLength==0)&&firstQuery) {
			firstQuery = false;
			startFetchDataSource();
			return;
		} else {
			firstQuery=true;
		}
		
		// Clear Overlay
		okOverlay.clearOverLayList();
		unknownOverlay.clearOverLayList();
		failOverlay.clearOverLayList();
		// Process data
		if (caseSource==null) {
			mapMode.getOverlays().clear();
			// Refresh Map
			mapMode.invalidate();
			// Refresh List
			((caseListAdapter) listMode.getAdapter()).notifyDataSetChanged();
			
			qGAEReturnNull();
		} else {
			// Set Overlay
			for (int i=0; i<caseSource.length; i++) {
				String typeName = QidToDescription.getDetailByQID(selfContext, Integer.parseInt(caseSource[i].getform("typeid")));
				int status = convertStatusStringToStatusCode(caseSource[i].getform("status"));
				OverlayItem overlayItem = new OverlayItem(caseSource[i].getGeoPoint(), typeName, caseSource[i].getform("key")); 
				// Add
				if (status==1)
					okOverlay.addOverlay(overlayItem);
				else if (status==2)
					failOverlay.addOverlay(overlayItem);
				else 
					unknownOverlay.addOverlay(overlayItem);
			}
			
			mapMode.getOverlays().clear();
			if (okOverlay.size()!=0)
				mapMode.getOverlays().add(okOverlay);
			if (failOverlay.size()!=0)
				mapMode.getOverlays().add(failOverlay);
			if (unknownOverlay.size()!=0)
				mapMode.getOverlays().add(unknownOverlay);
			
			// Refresh Map
			mapMode.invalidate();
			// Refresh List
			((caseListAdapter) listMode.getAdapter()).notifyDataSetChanged();
			
			qGAEReturnData();
	    }
	}
	protected abstract boolean setQGAECondition();
	protected abstract void qGAEReturnNull();
	protected abstract void qGAEReturnData();
	/**
	 * @category Custom List 
	 *
	 */
	class ListCellContainer {
		TextView caseID;
		TextView caseType;
		TextView caseAddress;
		TextView caseDate;
		ImageView caseStatus;
	}
	
	protected class caseListAdapter extends BaseAdapter {
		LayoutInflater myInflater;
		// Constructor
		public caseListAdapter(Context c) {
			myInflater = LayoutInflater.from(c);
		}
		
		@Override
		public int getCount() {
			//return stringData.length;
			ImageView noCaseImage;
			noCaseImage = (ImageView) findViewById(R.id.CaseSelector_NoCaseImage);
			if (caseSource == null) {
				if (noCaseImageWillShow == true) noCaseImage.setVisibility(View.VISIBLE);
				else noCaseImage.setVisibility(View.GONE);
				return 0;
			} else {
				noCaseImage.setVisibility(View.GONE);
				return caseSource.length;
			}
		}

		@Override
		public Object getItem(int position) {
			// Get the data item associated with the specified position in the data set.
			return position;
		}

		@Override
		public long getItemId(int position) {
			// Get the row id associated with the specified position in the list.
			return position;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			// Get a View that displays the data at the specified position in the data set.
			ListCellContainer cellContent = new ListCellContainer();
			// Reuse Cell
			if (convertView==null) {
				convertView = myInflater.inflate(R.layout.listcell, parent, false);
				// Mapping To XML
				cellContent.caseID = (TextView)convertView.findViewById(R.id.listCell_CaseID);
				cellContent.caseType = (TextView)convertView.findViewById(R.id.listCell_CaseType);
				cellContent.caseAddress = (TextView)convertView.findViewById(R.id.listCell_CaseAddress);
				cellContent.caseDate = (TextView)convertView.findViewById(R.id.listCell_CaseDate);
				cellContent.caseStatus = (ImageView)convertView.findViewById(R.id.listCell_StatusImage);
				convertView.setTag(cellContent);
			} else {
				cellContent = (ListCellContainer)convertView.getTag();
			}
			// Set Cell Content
			cellContent.caseStatus.setImageResource(R.drawable.ok);
			if (caseSource!=null) {
				if (convertStatusStringToStatusCode(caseSource[position].getform("status"))==1)
					cellContent.caseStatus.setImageResource(R.drawable.ok);
				else if (convertStatusStringToStatusCode(caseSource[position].getform("status"))==2)
					cellContent.caseStatus.setImageResource(R.drawable.fail);
				else
					cellContent.caseStatus.setImageResource(R.drawable.unknown);
				cellContent.caseID.setText(caseSource[position].getform("key"));
				cellContent.caseType.setText(QidToDescription.getDetailByQID(selfContext, Integer.parseInt(caseSource[position].getform("typeid"))));

				String d = caseSource[position].getform("date");
				String tmp[]=d.split("年|月|日");
				Date tmpdate = new Date(Integer.parseInt(tmp[0])+11,Integer.parseInt(tmp[1])-1,Integer.parseInt(tmp[2]));
				Date nowdate = new Date();
				nowdate = new Date(nowdate.getYear(),nowdate.getMonth(),nowdate.getDate());
				long timeInterval= nowdate.getTime()-tmpdate.getTime();
				if (timeInterval < 86400*1000) cellContent.caseDate.setText("今天");
				else if (timeInterval < 2*86400*1000) cellContent.caseDate.setText("昨天");
				else if (timeInterval < 3*86400*1000) cellContent.caseDate.setText("兩天前");
				else cellContent.caseDate.setText(tmp[0]+"/"+tmp[1]+"/"+tmp[2]);
				
				cellContent.caseAddress.setText(caseSource[position].getform("address"));
			}
			return convertView;
		}
	}
	
	/**
	 * @category MapActivity and Overlay
	 * 
	 */
	protected void mapChangeRegionOrZoom() {
		currentLocationPoint = mapMode.getMapCenter();
		if (mapMode.getLatitudeSpan()!=0)
			currentLatSpan = mapMode.getLatitudeSpan();
		if (mapMode.getLongitudeSpan()!=0)
			currentLonSpan = mapMode.getLongitudeSpan();
	}
	@Override
	protected boolean isRouteDisplayed() {
		// We do not use route service, so return false.
		return false;
	}
}
