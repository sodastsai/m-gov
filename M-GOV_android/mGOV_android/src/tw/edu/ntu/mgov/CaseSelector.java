/**
 * 
 */
package tw.edu.ntu.mgov;

import com.google.android.maps.GeoPoint;
import com.google.android.maps.MapActivity;
import com.google.android.maps.MapView;

import de.android1.overlaymanager.ManagedOverlay;
import de.android1.overlaymanager.ManagedOverlayGestureDetector;
import de.android1.overlaymanager.ManagedOverlayItem;
import de.android1.overlaymanager.OverlayManager;
import de.android1.overlaymanager.ZoomEvent;

import tw.edu.ntu.mgov.option.Option;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

/**
 * @author sodas
 * 2010/10/4
 * @company NTU CSIE Mobile HCI Lab
 * 
 * This class is set for data source.
 * Unlike iPhone, Android do not have to put all views with same data source in view controller,
 * so there's no Hybrid activity.
 * 
 * We use another open-source tool:
 * mapview-overlay-manager, Extension for Overlayer in the Android Maps-API
 * http://code.google.com/p/mapview-overlay-manager/
 * 
 */
public abstract class CaseSelector extends MapActivity {

	GeoPoint mapStartPoint = new GeoPoint(25046180, 121517330);
	
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
	// Views
	protected ListView listMode;
	protected MapView mapMode;
	OverlayManager overlayManager;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.caseselector);
		// Call List View From Layout XML
		listMode = (ListView)findViewById(R.id.listMode);
		listMode.setAdapter(new caseListAdapter(this));
		// Call Map View From Layout XML
		// TODO Make Two Maps Independently or not
		mapMode = (MapView)findViewById(R.id.mapMode);
		mapMode.setBuiltInZoomControls(true);
		mapMode.getController().setZoom(15);
		mapMode.getController().animateTo(mapStartPoint);
		overlayManager = new OverlayManager(getApplication(), mapMode);
		// Change to Default Mode
		if (defaultMode==CaseSelectorMode.CaseSelectorListMode) {
			currentMode = CaseSelectorMode.CaseSelectorListMode;
			mapMode.setVisibility(View.GONE);
			listMode.setVisibility(View.VISIBLE);
		} else {
			currentMode = CaseSelectorMode.CaseSelectorMapMode;
			mapMode.setVisibility(View.VISIBLE);
			listMode.setVisibility(View.GONE);
		}
	}
	@Override
	public void onWindowFocusChanged(boolean bool) {
		 createOverlayWithListener();
	}
	
	protected void changCaseSelectorMode(CaseSelectorMode targetMode) {
		if (targetMode == CaseSelectorMode.CaseSelectorListMode) {
			mapMode.setVisibility(View.GONE);
			listMode.setVisibility(View.VISIBLE);
		} else {
			listMode.setVisibility(View.GONE);
			mapMode.setVisibility(View.VISIBLE);
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
		menu.add(0, MENU_ListMode, 0, getResources().getString(R.string.menu_ListMode)).setIcon(android.R.drawable.ic_menu_info_details);
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
	
	class caseListAdapter extends BaseAdapter {
		LayoutInflater myInflater;
		// Constructor
		public caseListAdapter(Context c) {
			myInflater = LayoutInflater.from(c);
		}
		
		@Override
		public int getCount() {
			// TODO Return Data Count
			//return stringData.length;
			return 10;
		}

		@Override
		public Object getItem(int position) {
			// Get the data item associated with the specified position in the data set.
			Log.d("List", "getItem:"+Integer.toString(position));
			return position;
		}

		@Override
		public long getItemId(int position) {
			// Get the row id associated with the specified position in the list.
			Log.d("List", "getItemId:"+Integer.toString(position));
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
			
			return convertView;
		}
	}
	
	/**
	 * @category MapActivity and Overlay
	 * 
	 */
	@Override
	protected boolean isRouteDisplayed() {
		// We do not use route service, so return false.
		return false;
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
				mapMode.getController().animateTo(point);
				mapMode.getController().zoomIn();
				return true;
			}
	
			@Override
			public void onLongPress(MotionEvent e, ManagedOverlay overlay) {
				Toast.makeText(getApplicationContext(), "LongPress incoming...!", Toast.LENGTH_SHORT).show();
			}
	
			@Override
			public void onLongPressFinished(MotionEvent e, ManagedOverlay overlay, GeoPoint point, ManagedOverlayItem item) {
				
				AlertDialog.Builder builder = new AlertDialog.Builder(CaseSelector.this);
				builder.setIcon(R.drawable.icon);
				builder.setTitle("Test Title");
				
				builder.setMessage(String.valueOf(point.getLatitudeE6())+" "+String.valueOf(point.getLongitudeE6()));
				builder.setPositiveButton("OK",
					new DialogInterface.OnClickListener() {
						public void onClick(DialogInterface dialog, int whichButton) {
							
						}
					});
				builder.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
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
}
