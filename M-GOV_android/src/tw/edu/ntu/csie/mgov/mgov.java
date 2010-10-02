package tw.edu.ntu.csie.mgov;

import java.util.Random;

import android.content.Intent;
import android.content.res.Resources;
import android.os.Bundle;
import android.widget.TabHost;
import tw.edu.ntu.csie.mgov.R;

public class mgov extends baseActivity {
    /** Called when the activity is first created. */
	
	Class cls = null;
	Resources res;
//	TabHost tabHost;
	TabHost.TabSpec spec;
    Intent intent;
    
    @Override
    public void onCreate(Bundle savedInstanceState) {
    	
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
        res = getResources();
        TabHost tabHost = getTabHost();

    	
        intent = new Intent().setClass(this, NoPicSubmit.class);
        spec = tabHost.newTabSpec(res.getString(R.string.querycase)).
        	setIndicator(res.getString(R.string.querycase)).setContent(intent);
        tabHost.addTab(spec);
        
        if(savedInstanceState == null)
        {
        	intent = new Intent().setClass(this, caseListview.class);
        	
        }
        	
		else{
			try {
				String s = savedInstanceState.getString("activity");
				intent = new Intent().setClass(this, Class.forName(savedInstanceState.getString("activity")));
			} catch (ClassNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
        
        Random r = new Random(); 
        intent.putExtra("currentPic", getIntent().getStringExtra("currentPic"));
        spec = tabHost.newTabSpec(new Random().nextInt()+"").
        	setIndicator(res.getString(R.string.mycase)).setContent(intent);
        tabHost.addTab(spec);
        
        tabHost.setCurrentTab(1);
        		
    }
}