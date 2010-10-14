package tw.edu.ntu.mgov.typeselector;

import tw.edu.ntu.mgov.R;

import android.content.Intent;
import android.os.Bundle;
import android.preference.Preference;
import android.preference.PreferenceActivity;
import android.preference.PreferenceCategory;
import android.preference.PreferenceScreen;
import android.util.Log;

/**
 * This Activity is call for request the user to choose a type of query.<br>
 * returns the qid and detail description of the type of query to the caller Activity.
 * 
 * @author vagrants
 */
public class TypeSelector extends PreferenceActivity {
	
	private final static int REQUEST_CODE = 1630;	// used for startActivityForResult(), onActivityResult() 
	
	// used for decide which action todo on each Preference 
	private final static int TODO_QID = 0;	// return the result and qid
	private final static int TODO_INTENT = 1;	// start SubCaseFilter Activity 
	
	private final static String LOGTAG = "MGOV-TypeSelector";
	
	private final static int[][] todo = {
		{TODO_INTENT, TODO_INTENT, TODO_QID} ,
		{TODO_INTENT, TODO_INTENT} ,
		{TODO_INTENT, TODO_INTENT, TODO_INTENT} ,
		{TODO_INTENT, TODO_INTENT, TODO_INTENT, TODO_INTENT} ,
		{TODO_INTENT, TODO_QID, TODO_INTENT, TODO_INTENT, TODO_INTENT} ,
		{TODO_INTENT, TODO_INTENT, TODO_INTENT, TODO_INTENT}
	};
	
	// string ResourceID for Categories 
	private final int[] title = { 
			R.string.sec1_title, 
			R.string.sec2_title,
			R.string.sec3_title,
			R.string.sec4_title,
			R.string.sec5_title,
			R.string.sec6_title };

	// string ResourceID for each Preference to show 
	private final int[][] subTitles =  {	
					{ R.string.sec1_1, R.string.sec1_2, R.string.sec1_3 },
					{ R.string.sec2_1, R.string.sec2_2 }, 
					{ R.string.sec3_1, R.string.sec3_2, R.string.sec3_3 }, 
					{ R.string.sec4_1, R.string.sec4_2, R.string.sec4_3, R.string.sec4_4 },
					{ R.string.sec5_1, R.string.sec5_2, R.string.sec5_3, R.string.sec5_4, R.string.sec5_5 },
					{ R.string.sec6_1, R.string.sec6_2, R.string.sec6_3, R.string.sec6_4 } };
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		setTitle(R.string.title_TypeSelector);
		setPreferenceScreen(createPreferenceHierarchy());	// something like setContentView 
		setResult(RESULT_CANCELED, null);
	}

	/**
	 * create the content View of this Activity.
	 * 
	 * @return the content Screen 
	 */
	private PreferenceScreen createPreferenceHierarchy() {
		
		PreferenceCategory[] secPrefCat = new PreferenceCategory[6];
		
		// Root
        PreferenceScreen root = getPreferenceManager().createPreferenceScreen(this);
        
        // sec titles (Categories)
        for (int i = 0; i < 6; i++) {
        	secPrefCat[i] = new PreferenceCategory(this);
        	secPrefCat[i].setTitle(title[i]);
        	root.addPreference(secPrefCat[i]);
        	
        	// set the contents of a Category
        	for (int j = 0; j < subTitles[i].length; j++) {
        		Preference subSecPref = new Preference(this);
        		subSecPref.setTitle(subTitles[i][j]);
        		setClickListenerOn(subSecPref, i, j);
        		secPrefCat[i].addPreference(subSecPref);
        	}
        }
        
        return root;
	}
	
	/**
	 * Set the OnClickListener on each Preference.
	 * 
	 * 
	 * @param subSecPref the Preference to click
	 * @param i just an index
	 * @param j just an index
	 */
	private void setClickListenerOn (Preference subSecPref, final int i, final int j) {
		
		if (todo[i][j] == TODO_INTENT) {
			// can't decide which type user wants, start subCaseFilter for users further choose 
			subSecPref.setOnPreferenceClickListener(new Preference.OnPreferenceClickListener() {
				@Override
				public boolean onPreferenceClick(Preference preference) {
					Intent intent = new Intent();
					intent.setClass(TypeSelector.this, DetailSelector.class);
					Bundle bundle = new Bundle();
					bundle.putInt("tid", subTitles[i][j]);
					intent.putExtras(bundle);
					startActivityForResult(intent, TypeSelector.REQUEST_CODE);
					return false;
				}
			});
		} else if (todo[i][j] == TODO_QID) {
			// return the result (qid, detail) to previous Activity and this.finish() 
			subSecPref.setOnPreferenceClickListener(new Preference.OnPreferenceClickListener() {
				@Override
				public boolean onPreferenceClick(Preference preference) {
					if (i == 0 && j == 2) {
						Bundle bundle = new Bundle();
						bundle.putInt("qid", 1301);
						bundle.putString("detail", getString(R.string.sec1_3));
						Intent mIntent = new Intent();
						mIntent.putExtras(bundle);
						setResult(RESULT_OK, mIntent);
						TypeSelector.this.finish();
						return false;
					} else if (i == 4 && j == 1) {
						Bundle bundle = new Bundle();
						bundle.putInt("qid", 5201);
						bundle.putString("detail", getString(R.string.sec5_2));
						Intent mIntent = new Intent();
						mIntent.putExtras(bundle);
						setResult(RESULT_OK, mIntent);
						TypeSelector.this.finish();
						return false;
					}
					return false;
				}
			});
		}
	}
	
	
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		
		if (requestCode == REQUEST_CODE) {
			if (resultCode == RESULT_CANCELED) {
				// subFilter didn't choose a type, keep staying in this Activity 
			} else if (resultCode == RESULT_OK ) {
				// subFilter returns the result 
				setResult(RESULT_OK, data);
				this.finish();
			} else {
				// subFilter didn't return the previous result, this should not happen 
				Log.e( LOGTAG, "SubFilter returns an exceptional result, plz check!!");
			}
		} else {
			super.onActivityResult(requestCode, resultCode, data);
		}
	}
}
