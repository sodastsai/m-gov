/**
 * 
 */
package tw.edu.ntu.mgov.mycase;

import android.content.Intent;
import android.view.Menu;
import android.view.MenuItem;
import tw.edu.ntu.mgov.CaseSelector;
import tw.edu.ntu.mgov.R;
import tw.edu.ntu.mgov.addcase.AddCase;

/**
 * @author sodas
 * 2010/10/4
 * @company NTU CSIE Mobile HCI Lab
 */
public class MyCase extends CaseSelector {
	// Menu
	protected static final int MENU_AddCase = Menu.FIRST+3;
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		menu.add(0, MENU_AddCase, 0, getResources().getString(R.string.menu_myCase_addCase)).setIcon(android.R.drawable.ic_menu_add);
		return super.onCreateOptionsMenu(menu);
	}
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		if (item.getItemId() == MENU_AddCase)
			this.menuActionToTake(item);
		return super.onOptionsItemSelected(item);
	}
	@Override
	public void menuActionToTake(MenuItem item) {
		if	(item.getItemId()==MENU_AddCase) {
			Intent caseAdderIntent = new Intent().setClass(this, AddCase.class);
			startActivity(caseAdderIntent);
		}
	}

}

