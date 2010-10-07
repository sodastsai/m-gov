/**
 * 
 */
package tw.edu.ntu.mgov.query;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import tw.edu.ntu.mgov.CaseSelector;
import tw.edu.ntu.mgov.R;
import tw.edu.ntu.mgov.typeselector.TypeSelector;

/**
 * @author sodas
 * 2010/10/4
 * @company NTU CSIE Mobile HCI Lab
 */
public class Query extends CaseSelector {
	// Constant
	protected static final int MENU_SetTypeCondition = Menu.FIRST+3;
	protected static final int MENU_AllTypeCondition = Menu.FIRST+4;
	private static final int REQUEST_CODE_typeSelector = 1630;
	// Lifecycle
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		this.defaultMode = CaseSelectorMode.CaseSelectorMapMode;
		super.onCreate(savedInstanceState);
	}
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		menu.add(0, MENU_SetTypeCondition, 0, getResources().getString(R.string.menu_query_setTypeCondition)).setIcon(android.R.drawable.ic_menu_search);
		menu.add(0, MENU_AllTypeCondition, 0, getResources().getString(R.string.menu_query_setAllType)).setIcon(android.R.drawable.ic_menu_search);
		return super.onCreateOptionsMenu(menu);
	}
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (requestCode == REQUEST_CODE_typeSelector) {
			if (resultCode == RESULT_OK) {
				Log.d("Result",  Integer.toString(data.getExtras().getInt("qid")));
			} else if (resultCode == RESULT_CANCELED) {
				Log.d("Result", "Canceled");
			}
		}
		super.onActivityResult(requestCode, resultCode, data);
	}
	// Menu
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		if (item.getItemId() == MENU_SetTypeCondition || item.getItemId() == MENU_AllTypeCondition)
			this.menuActionToTake(item);
		return super.onOptionsItemSelected(item);
	}
	@Override
	public void menuActionToTake(MenuItem item) {
		super.menuActionToTake(item);
		if (item.getItemId()==MENU_SetTypeCondition) {
			// Call Type Selector
			Intent intent = new Intent();
			intent.setClass(Query.this, TypeSelector.class);
			startActivityForResult(intent, REQUEST_CODE_typeSelector);
		}
		else if (item.getItemId()==MENU_AllTypeCondition) Log.d("Menu", "All Type");
	}
	
}
