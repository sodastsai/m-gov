package tw.edu.ntu.csie.mgov;

import android.app.TabActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;

public class baseActivity extends TabActivity {
	
	public String TAG = this.getClass().getName();
	public static final int MENU_listView = Menu.FIRST;
	public static final int MENU_mapView = Menu.FIRST + 2;
	public static final int MENU_filter = Menu.FIRST + 3;
	public static final int MENU_submit = Menu.FIRST + 4;
	public String packageName = "tw.edu.ntu.csie.mgov.";
	public String currentAct = "";
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
	}
	
	@Override 
    public boolean onSearchRequested() { 

//        Intent intent = new Intent();
//        intent.setClass(this, Search.class);
//        startActivity(intent);
        return true; 
    }
	
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		super.onCreateOptionsMenu(menu);
		
		menu.add(0, MENU_listView, 0, getResources().getString(R.string.listView)).setIcon(R.drawable.icon);
		menu.add(1, MENU_mapView, 0, getResources().getString(R.string.mapView)).setIcon(R.drawable.icon);
		menu.add(2, MENU_filter, 0, getResources().getString(R.string.filter)).setIcon(R.drawable.icon);
		menu.add(3, MENU_submit, 0, getResources().getString(R.string.report)).setIcon(R.drawable.icon);
		
		if(this.getTabHost().getCurrentTab() == 0)
			menu.setGroupVisible(3, false);
		else
			menu.setGroupVisible(2, false);

		return true;
	}

	public boolean onOptionsItemSelected(MenuItem item) {

		switch (item.getItemId()) {
		case MENU_listView:
			forwardIntent("caseListview");
			break;
		case MENU_mapView:
//			forwardIntent(new Intent().setClass(baseActivity.this, mapView.class));
			break;
		case MENU_filter:
//			forwardIntent(new Intent().setClass(baseActivity.this, filter.class));
			break;
		case MENU_submit:
			forwardIntent("submit");
			break;
		}
		
		return true;
	}
	
	public void forwardIntent(String activity){

			currentAct = activity;
			Bundle bundle = new Bundle();
			bundle.putString("activity", packageName+activity);
			this.onCreate(bundle);
	}
}
	

