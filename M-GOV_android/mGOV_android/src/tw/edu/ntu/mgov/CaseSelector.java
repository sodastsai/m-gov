/**
 * 
 */
package tw.edu.ntu.mgov;

import com.google.android.maps.MapActivity;
import com.google.android.maps.MapView;

import tw.edu.ntu.mgov.option.Option;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

/**
 * @author sodas
 * 2010/10/4
 * @company NTU CSIE Mobile HCI Lab
 * 
 * This class is set for data source.
 * Unlike iPhone, Android do not have to put all views with same data source in view controller,
 * so there's no Hybrid activity.
 * 
 */
public abstract class CaseSelector extends MapActivity {

	// Constant Identifier for Menu
	protected static final int MENU_Option = Menu.FIRST;
	protected static final int MENU_ListMode = Menu.FIRST+1;
	protected static final int MENU_MapMode = Menu.FIRST+2;
	// Selector Mode
	public static enum CaseSelectorMode {
		CaseSelectorListMode,
		CaseSelectorMapMode
	}
	protected CaseSelectorMode currentMode;
	// Default Mode is List Mode
	public CaseSelectorMode defaultMode = CaseSelectorMode.CaseSelectorListMode;
	// Views
	protected ListView listMode;
	protected MapView mapMode;
	
	String stringData[] = {"A","B","C"};
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.caseselector);
		// Call List View From Layout XML
		listMode = (ListView)findViewById(R.id.listMode);
		listMode.setAdapter(new caseListAdapter(this));
		// Call Map View From Layout XML
		mapMode = (MapView)findViewById(R.id.mapMode);
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
	
	public void menuActionToTake(MenuItem item) {
		// Wait For Overriding.
	}
	
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
		public Object getItem(int posititon) {
			// Get the data item associated with the specified position in the data set.s
			return posititon;
		}

		@Override
		public long getItemId(int position) {
			// Get the row id associated with the specified position in the list.
			return position;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			// Get a View that displays the data at the specified position in the data set.
			final int index = position;
			ListCellContainer cellContent = new ListCellContainer();
			// Reuse Cell
			if (convertView==null) {
				convertView = myInflater.inflate(R.layout.listcell, null);
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
			
			cellContent.caseStatus.setImageResource(R.drawable.ok);
			
			return convertView;
		}
		
	}
	/**
	 * @category MapActivity
	 * 
	 */
	@Override
	protected boolean isRouteDisplayed() {
		return false;
	}
}
