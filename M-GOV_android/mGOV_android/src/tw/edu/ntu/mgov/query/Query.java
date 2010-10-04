/**
 * 
 */
package tw.edu.ntu.mgov.query;

import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import tw.edu.ntu.mgov.CaseSelector;

/**
 * @author sodas
 * 2010/10/4
 * @company NTU CSIE Mobile HCI Lab
 */
public class Query extends CaseSelector {
	// Menu
	protected static final int MENU_SetTypeCondition = Menu.FIRST+3;
	protected static final int MENU_ResetCondition = Menu.FIRST+4;
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		menu.add(0, MENU_SetTypeCondition, 0, "依照案件種類搜尋").setIcon(android.R.drawable.ic_menu_search);
		menu.add(0, MENU_ResetCondition, 0, "重設搜尋條件").setIcon(android.R.drawable.ic_menu_close_clear_cancel);
		return super.onCreateOptionsMenu(menu);
	}
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		if (item.getItemId() == MENU_SetTypeCondition || item.getItemId() == MENU_ResetCondition)
			this.menuActionToTake(item);
		return super.onOptionsItemSelected(item);
	}
	@Override
	public void menuActionToTake(MenuItem item) {
		super.menuActionToTake(item);
		if (item.getItemId()==MENU_SetTypeCondition) Log.d("Menu", "Set Condition");
		else if (item.getItemId()==MENU_ResetCondition) Log.d("Menu", "Reset");
	}
	
}
