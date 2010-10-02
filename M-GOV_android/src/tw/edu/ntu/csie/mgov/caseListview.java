package tw.edu.ntu.csie.mgov;

import android.app.ActivityGroup;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;

public class caseListview extends ActivityGroup {

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.caselistview);
		
//		View view = getLocalActivityManager().startActivity("ArchiveActivity",
//				new Intent(this, caseListview.class).addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();                
//		setContentView(view);
	}
}
