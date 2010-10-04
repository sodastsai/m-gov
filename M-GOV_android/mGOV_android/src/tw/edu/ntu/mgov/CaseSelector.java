/**
 * 
 */
package tw.edu.ntu.mgov;

import android.app.Activity;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;

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
	public boolean onCreateOptionsMenu(Menu menu) {
		menu.add(0, MENU_Option, 0, "偏好設定").setIcon(android.R.drawable.ic_menu_preferences);
		menu.add(0, MENU_ListMode, 0, "列表模式").setIcon(android.R.drawable.ic_menu_info_details);
		menu.add(0, MENU_MapMode, 0, "地圖模式").setIcon(android.R.drawable.ic_menu_mapmode);
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
				Log.d("Menu", "Option");
				break;
		}
		return super.onOptionsItemSelected(item);
	}

	public void menuActionToTake(MenuItem item) {
		// Wait For Overriding.
	}
	
}
