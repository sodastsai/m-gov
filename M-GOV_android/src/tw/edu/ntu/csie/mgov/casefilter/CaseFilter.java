package tw.edu.ntu.csie.mgov.casefilter;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

public class CaseFilter extends Activity {

	public final static int RESULT_OK = 0;
	public final static int RESULT_CANCEL = -1;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		this.finish();
	}

	@Override
	public void finish() {
		/** put temp result */
		Bundle bundle = new Bundle();
		bundle.putInt("qid", 1101);
		bundle.putString("detail", "遊動廣告物違規停放");
		Intent mIntent = new Intent();
		mIntent.putExtras(bundle);
		setResult(RESULT_OK, mIntent);
		
		super.finish();
	}
}
