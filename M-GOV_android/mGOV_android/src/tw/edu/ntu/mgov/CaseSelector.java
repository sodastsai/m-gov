/**
 * 
 */
package tw.edu.ntu.mgov;

import tw.edu.ntu.mgov.option.Option;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.BaseAdapter;
import android.widget.ListView;

/**
 * @author sodas
 * 2010/10/4
 * @company NTU CSIE Mobile HCI Lab
 * 
 * This class is set for data source.
 * Unlike iPhone, Android do not have to put all views with same data source in view controller,
 * so there's no Hybrid activity.
 */
public class CaseSelector extends Activity {

	// Constant Identifier for Menu
	protected static final int MENU_Option = Menu.FIRST;
	protected static final int MENU_ListMode = Menu.FIRST+1;
	protected static final int MENU_MapMode = Menu.FIRST+2;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.caseselector);
		// Call List View From Layout XML
		ListView listMode = (ListView)findViewById(R.id.listMode);
		
		String[] Data = {"A","B","C"};
		listMode.setChoiceMode(ListView.CHOICE_MODE_SINGLE);
		ArrayAdapter<String> arrayData = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, Data);
		listMode.setAdapter(arrayData);
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
				// Change to List Mode
				Log.d("Menu", "ListMode");
				break;
			case MENU_MapMode:
				// Change Map Mode
				Log.d("Menu", "MapMode");
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
	class caseListAdapter extends BaseAdapter {
		LayoutInflater myInflater;
		// Constructor
		caseListAdapter(Context c) {
			myInflater = LayoutInflater.from(c);
		}
		@Override
		public int getCount() {
			// TODO Return Data Count
			return 0;
		}

		@Override
		public Object getItem(int postiton) {
			// TODO Auto-generated method stub
			return null;
		}

		@Override
		public long getItemId(int position) {
			// TODO Auto-generated method stub
			return 0;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			// TODO Auto-generated method stub
			return null;
		}
		
	}
}
