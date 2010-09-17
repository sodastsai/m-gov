package tw.edu.ntu.csie.mgov;

import android.app.Activity;
import android.os.Bundle;
import android.widget.ArrayAdapter;
import android.widget.ListView;

public class problem_list extends Activity {

	private ListView lv1;  

	private String lv_arr1[]= null; 

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.problem_list);
		
		lv1=(ListView)findViewById(R.id.ListView01);  

		lv_arr1 = getIntent().getStringArrayExtra("data");

		lv1.setAdapter(new ArrayAdapter<String>(this,android.R.layout.simple_list_item_1 , lv_arr1));  


	}
}
