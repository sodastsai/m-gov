package tw.edu.ntu.csie.mgov;


//import android.app.Activity;
import android.app.TabActivity;
import android.content.Intent;
import android.content.res.Resources;
import android.os.Bundle;
import android.widget.TabHost;

public class mgov extends TabActivity {
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
        Resources res = getResources();
        TabHost tabHost = getTabHost();
        TabHost.TabSpec spec;
        Intent intent;
        
        intent = new Intent().setClass(this, AskActivity.class);
        spec = tabHost.newTabSpec("ask").setIndicator("Ask").setContent(intent);
        tabHost.addTab(spec);
        
        intent = new Intent().setClass(this, CameraActivity.class);
        spec = tabHost.newTabSpec("camera").setIndicator("Camera").setContent(intent);
        tabHost.addTab(spec);
        
        tabHost.setCurrentTab(1);

    }
}