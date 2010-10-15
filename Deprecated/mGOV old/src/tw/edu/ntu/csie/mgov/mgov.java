package tw.edu.ntu.csie.mgov;

import java.util.Random;

import android.content.Intent;
import android.content.res.Resources;
import android.os.Bundle;
import android.widget.TabHost;
import tw.edu.ntu.csie.mgov.R;

public class mgov extends baseActivity {
    
	Resources res;
	TabHost.TabSpec spec;
    Intent intent;
    
    @Override
    public void onCreate(Bundle savedInstanceState) {
    	
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
        res = getResources();
        TabHost tabHost = getTabHost();
        
        // Add MyCase Tab
        // sodas: why do this?
        if(savedInstanceState == null){
        	intent = new Intent().setClass(this, caseListview.class);
        } else{
			try {
				intent = new Intent().setClass(this, Class.forName(savedInstanceState.getString("activity")));
			} catch (ClassNotFoundException e) {
				e.printStackTrace();
			}
		}
        intent.putExtra("currentPic", getIntent().getStringExtra("currentPic"));
        spec = tabHost.newTabSpec(new Random().nextInt()+"").setIndicator(res.getString(R.string.mycase)).setContent(intent);
        tabHost.addTab(spec);
    	
        // Add Query Tab
        intent = new Intent().setClass(this, NoPicSubmit.class);
        spec = tabHost.newTabSpec(res.getString(R.string.querycase)).setIndicator(res.getString(R.string.querycase)).setContent(intent);
        tabHost.addTab(spec);
        
        // Add Pref Tab
        intent = new Intent().setClass(this, UserPreference.class);
        spec = tabHost.newTabSpec(res.getString(R.string.userpreference)).setIndicator(res.getString(R.string.userpreference)).setContent(intent);
        tabHost.addTab(spec);
        
        // Set Default tab to MyCase
        tabHost.setCurrentTab(0);
        		
    }
}