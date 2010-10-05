/**
 * 
 */
package tw.edu.ntu.mgov.option;

import tw.edu.ntu.mgov.R;
import android.os.Build;
import android.os.Bundle;
import android.preference.Preference;
import android.preference.PreferenceActivity;
import android.preference.PreferenceCategory;
import android.preference.PreferenceScreen;

/**
 * @author sodas
 * 2010/10/4
 * @company NTU CSIE Mobile HCI Lab
 */
public class Option extends PreferenceActivity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		this.setTitle("偏好設定");
		setPreferenceScreen(createPreferenceHierarchy());	
	}
	
	/**
	 * create the content View of this Activity.
	 * 
	 * @return the content Screen 
	 */
	private PreferenceScreen createPreferenceHierarchy() {
		
		PreferenceCategory[] prefCategory = new PreferenceCategory[2];
		
		// Root
        PreferenceScreen root = getPreferenceManager().createPreferenceScreen(this);
        
        // Section titles (Categories)
        prefCategory[0] = new PreferenceCategory(this);
        prefCategory[0].setTitle("個人資訊");
        prefCategory[1] = new PreferenceCategory(this);
        prefCategory[1].setTitle("應用程式資訊");
        root.addPreference(prefCategory[0]);
        root.addPreference(prefCategory[1]);
        
        // Preference Content
        Preference personalEMail = new Preference(this);
		personalEMail.setTitle("E-Mail");
        personalEMail.setSummary("sodas@gmail.com");
		prefCategory[0].addPreference(personalEMail);
		
		Preference appInformation = new Preference(this);
		appInformation.setTitle(getResources().getString(R.string.app_name));
		appInformation.setSummary("版本 "+getResources().getString(R.string.app_version));
		prefCategory[1].addPreference(appInformation);
		
        return root;
	}
	
}
