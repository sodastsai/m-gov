package tw.edu.ntu.mgov;

/**
 * @author sodas
 * 2010/10/4
 * @company NTU CSIE Mobile HCI Lab
 */

import android.app.TabActivity;
import android.content.Intent;
import android.content.res.Resources;
import android.os.Bundle;
import android.widget.TabHost;

import tw.edu.ntu.mgov.mycase.MyCase;
import tw.edu.ntu.mgov.query.Query;

public class mgov extends TabActivity {
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);

        Resources res = getResources(); // Resource object to get Drawables
        TabHost tabHost = getTabHost();  // The activity TabHost
        TabHost.TabSpec spec;  // Reusable TabSpec for each tab
        Intent intent;  // Reusable Intent for each tab

        // Add MyCase Tab
        intent = new Intent().setClass(this, MyCase.class);
        spec = tabHost.newTabSpec("myCaseTab").setIndicator(res.getString(R.string.tabName_myCase), res.getDrawable(R.drawable.ic_tab_mycase)).setContent(intent);
        tabHost.addTab(spec);
        intent = null;

        // Add QueryCase Tab
        intent = new Intent().setClass(this, Query.class);
        spec = tabHost.newTabSpec("queryCaseTab").setIndicator(res.getString(R.string.tabName_query), res.getDrawable(R.drawable.ic_tab_query)).setContent(intent);
        tabHost.addTab(spec);
        intent = null;
        
        tabHost.setCurrentTab(0);
    }
}