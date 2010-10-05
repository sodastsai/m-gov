/**
 * 
 */
package tw.edu.ntu.mgov.addcase;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

/**
 * 
 * 
 * @author vagrants
 * 2010/10/5
 * @company NTU CSIE Mobile HCI Lab
 */
public class AddCase extends Activity {

	private static final String LOGTAG = "MGOV-AddCase";

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		/** 
		 * For now, this Activity is under construct.
		 * I just writing this for others can port to this Activity. 
		 * Thus, the current functionality is to print a log and message, then return to the 
		 * caller Activity.
		 *  -- by vagrants
		 */
		
		Log.d(LOGTAG, "AddCase Activity has been called, then finished!!!");
		
		Toast.makeText(this, "AddCase is called, then finished.", Toast.LENGTH_SHORT);
		
		finish();
	}
}
