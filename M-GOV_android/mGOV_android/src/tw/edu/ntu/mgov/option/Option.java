/**
 * 
 */
package tw.edu.ntu.mgov.option;

import tw.edu.ntu.mgov.R;
import android.os.Bundle;
import android.preference.EditTextPreference;
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
		this.setTitle(getResources().getString(R.string.option_ActivityName));
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
        prefCategory[0].setTitle(getResources().getString(R.string.option_personalInformation));
        prefCategory[1] = new PreferenceCategory(this);
        prefCategory[1].setTitle(getResources().getString(R.string.option_applicationInformation));
        root.addPreference(prefCategory[0]);
        root.addPreference(prefCategory[1]);
        
        // Preference Content
        EditTextPreference personalEMail = new EditTextPreference(this);
		personalEMail.setTitle(getResources().getString(R.string.option_personalInfo_Email));
        personalEMail.setSummary("sodas@gmail.com");
        personalEMail.setDialogTitle(getResources().getString(R.string.option_personalInfo_Email));
        personalEMail.setDialogMessage(getResources().getString(R.string.option_personalInfo_Email_prompt));
        personalEMail.getEditText().setInputType(android.view.inputmethod.EditorInfo.TYPE_TEXT_VARIATION_EMAIL_ADDRESS);
        prefCategory[0].addPreference(personalEMail);
		
		Preference appInformation = new Preference(this);
		appInformation.setTitle(getResources().getString(R.string.app_name));
		appInformation.setSummary(getResources().getString(R.string.option_appInfo_version)+getResources().getString(R.string.app_version));
		appInformation.setSelectable(false);
		prefCategory[1].addPreference(appInformation);
		
        return root;
	}
	
}
