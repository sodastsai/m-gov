package tw.ntu.edu.mgov;

/**
 * @author sodas
 * @company NTU CSIE Mobile HCI Lab
 */

import android.app.TabActivity;
import android.content.Intent;
import android.content.res.Resources;
import android.os.Bundle;
import android.widget.TabHost;

import tw.ntu.edu.mgov.mycase.MyCase;
import tw.ntu.edu.mgov.option.Option;
import tw.ntu.edu.mgov.querycase.QueryCase;

public class mGOV extends TabActivity {
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
        spec = tabHost.newTabSpec("myCaseTab").setIndicator(res.getString(R.string.myCaseTabName), res.getDrawable(R.drawable.ic_tab_mycase)).setContent(intent);
        tabHost.addTab(spec);

        // Add QueryCase Tab
        intent = new Intent().setClass(this, QueryCase.class);
        spec = tabHost.newTabSpec("queryCaseTab").setIndicator(res.getString(R.string.queryCaseTabName), res.getDrawable(R.drawable.ic_tab_query)).setContent(intent);
        tabHost.addTab(spec);
        
        // Add Option Tab, Preference in iOS version
        intent = new Intent().setClass(this, Option.class);
        spec = tabHost.newTabSpec("optionTab").setIndicator(res.getString(R.string.optionTabName), res.getDrawable(R.drawable.ic_tab_option)).setContent(intent);
        tabHost.addTab(spec);

        tabHost.setCurrentTab(0);
    }
}