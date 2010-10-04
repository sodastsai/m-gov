/**
 * 
 */
package tw.edu.ntu.mgov.mycase;

import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import tw.edu.ntu.mgov.CaseSelector;

/**
 * @author sodas
 * 2010/10/4
 * @company NTU CSIE Mobile HCI Lab
 */
public class MyCase extends CaseSelector {
	// Menu
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		menu.add(0, MENU_Action, 0, "新增案件").setIcon(android.R.drawable.ic_menu_add);
		return super.onCreateOptionsMenu(menu);
	}
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		return super.onOptionsItemSelected(item);
	}
	@Override
	public void menuActionToTake(MenuItem item) {
		Log.d("Menu", "Add Case");
		super.menuActionToTake(item);
	}

}

