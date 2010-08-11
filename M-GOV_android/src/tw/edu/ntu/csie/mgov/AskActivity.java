package tw.edu.ntu.csie.mgov;

import android.app.Activity;
import android.os.Bundle;
//import android.widget.TextView;

public class AskActivity extends Activity{
	public void onCreate(Bundle savedInstanceState){
		super.onCreate(savedInstanceState);
		setContentView(R.layout.appinfo_tab1);
		
		/*
		TextView textview = new TextView(this);
		textview.setText("This is tab 1");
		setContentView(textview);
		*/
	}
}
