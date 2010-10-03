package tw.edu.ntu.csie.mgov.casefilter;

import tw.edu.ntu.csie.mgov.R;
import android.content.Intent;
import android.os.Bundle;
import android.preference.Preference;
import android.preference.PreferenceActivity;
import android.preference.PreferenceCategory;
import android.preference.PreferenceScreen;
import android.util.Log;
import android.widget.Toast;

public class CaseFilter extends PreferenceActivity {
	
	private final static int REQUEST_CODE = 1630;
	
	public final static int TODO_QID = 0;
	public final static int TODO_INTENT = 1;
	
	private final static String LOGTAG = "MGOV-CaseFilter";
	
	private final static int[][] todo = {
		{TODO_INTENT, TODO_INTENT, TODO_QID} ,
		{TODO_INTENT, TODO_INTENT} ,
		{TODO_INTENT, TODO_INTENT, TODO_INTENT} ,
		{TODO_INTENT, TODO_INTENT, TODO_INTENT, TODO_INTENT} ,
		{TODO_INTENT, TODO_QID, TODO_INTENT, TODO_INTENT, TODO_INTENT} ,
		{TODO_INTENT, TODO_INTENT, TODO_INTENT, TODO_INTENT}
	};
	
	private final int[] title = { 
			R.string.sec1_title, 
			R.string.sec2_title,
			R.string.sec3_title,
			R.string.sec4_title,
			R.string.sec5_title,
			R.string.sec6_title };

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
		
		setTitle(R.string.case_filter_select_title);
		setPreferenceScreen(createPreferenceHierarchy());
		setResult(RESULT_CANCELED, null);
	}

	private PreferenceScreen createPreferenceHierarchy() {
		
		PreferenceCategory[] secPrefCat = new PreferenceCategory[6];
		
		// Root
        PreferenceScreen root = getPreferenceManager().createPreferenceScreen(this);
        
        // sec titles (Categories)
        for (int i = 0; i < 6; i++) {
        	secPrefCat[i] = new PreferenceCategory(this);
        	secPrefCat[i].setTitle(title[i]);
        	root.addPreference(secPrefCat[i]);
        	
        	for (int j = 0; j < subTitles[i].length; j++) {
        		Preference subSecPref = new Preference(this);
        		subSecPref.setTitle(subTitles[i][j]);
        		setClickListenerOn(subSecPref, i, j);
        		secPrefCat[i].addPreference(subSecPref);
        	}
        }
        
        return root;
	}
	
	private void setClickListenerOn (Preference subSecPref, final int i, final int j) {
		
		if (todo[i][j] == TODO_INTENT) {
			subSecPref.setOnPreferenceClickListener(new Preference.OnPreferenceClickListener() {
				@Override
				public boolean onPreferenceClick(Preference preference) {
					Intent intent = new Intent();
					intent.setClass(CaseFilter.this, SubCaseFilter.class);
					Bundle bundle = new Bundle();
					bundle.putInt("tid", subTitles[i][j]);
					intent.putExtras(bundle);
					startActivityForResult(intent, CaseFilter.REQUEST_CODE);
					return false;
				}
			});
		} else if (todo[i][j] == TODO_QID) {
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
						Toast.makeText(CaseFilter.this, "qid=" + 1301 +"\ndetail=" + getString(R.string.sec1_3) , Toast.LENGTH_SHORT).show();
						CaseFilter.this.finish();
						return false;
					} else if (i == 4 && j == 1) {
						Bundle bundle = new Bundle();
						bundle.putInt("qid", 5201);
						bundle.putString("detail", getString(R.string.sec5_2));
						Intent mIntent = new Intent();
						mIntent.putExtras(bundle);
						setResult(RESULT_OK, mIntent);
						Toast.makeText(CaseFilter.this, "qid=" + 5201 +"\ndetail=" + getString(R.string.sec5_2) , Toast.LENGTH_SHORT).show();
						CaseFilter.this.finish();
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
