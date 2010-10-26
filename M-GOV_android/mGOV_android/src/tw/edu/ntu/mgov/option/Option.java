/**
 * 
 */
package tw.edu.ntu.mgov.option;

import tw.edu.ntu.mgov.R;
import tw.edu.ntu.mgov.mgov;
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

	public static final String PREFERENCE_NAME = "Option-Preferences";
	public static final String KEY_USER_EMAIL = "User Email";
	public static final String KEY_USER_NAME = "User Name";
	
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
        
        getPreferenceManager().setSharedPreferencesName(PREFERENCE_NAME);
        getPreferenceManager().setSharedPreferencesMode(MODE_WORLD_WRITEABLE);
        
        // Section titles (Categories)
        prefCategory[0] = new PreferenceCategory(this);
        prefCategory[0].setTitle(getResources().getString(R.string.option_personalInformation));
        prefCategory[1] = new PreferenceCategory(this);
        prefCategory[1].setTitle(getResources().getString(R.string.option_applicationInformation));
        root.addPreference(prefCategory[0]);
        root.addPreference(prefCategory[1]);
        
        // Preference Content
        EditTextPreference personalEMail = new EditTextPreference(this);
        personalEMail.setKey(KEY_USER_EMAIL);
		personalEMail.setTitle(getResources().getString(R.string.option_personalInfo_Email));
		personalEMail.setSummary(getPreferenceManager().getSharedPreferences().getString(KEY_USER_EMAIL, ""));
        personalEMail.setDialogTitle(getResources().getString(R.string.option_personalInfo_Email));
        personalEMail.setDialogMessage(getResources().getString(R.string.option_personalInfo_Email_prompt));
        personalEMail.getEditText().setInputType(android.view.inputmethod.EditorInfo.TYPE_TEXT_VARIATION_EMAIL_ADDRESS);
        personalEMail.setOnPreferenceChangeListener(new Preference.OnPreferenceChangeListener() {
			@Override
			public boolean onPreferenceChange(Preference preference, Object newValue) {
				preference.setSummary((String)newValue);
				return true;
			}
		});
        prefCategory[0].addPreference(personalEMail);
        
        EditTextPreference userRealName = new EditTextPreference(this);
        userRealName.setKey(KEY_USER_NAME);
        userRealName.setTitle(getResources().getString(R.string.option_personalInfo_Name));
        userRealName.setSummary(getPreferenceManager().getSharedPreferences().getString(KEY_USER_NAME, ""));
        userRealName.setDialogTitle(getResources().getString(R.string.option_personalInfo_Name));
        userRealName.setDialogMessage(getResources().getString(R.string.option_personalInfo_Name_prompt));
        userRealName.setOnPreferenceChangeListener(new Preference.OnPreferenceChangeListener() {
			@Override
			public boolean onPreferenceChange(Preference preference, Object newValue) {
				preference.setSummary((String)newValue);
				return true;
			}
		});
        prefCategory[0].addPreference(userRealName);
		
        String versionInfo = getResources().getString(R.string.option_appInfo_version)+getResources().getString(R.string.app_version);
        if (mgov.DEBUG_MODE)
        	versionInfo += " Debug Mode.";
        
		Preference appInformation = new Preference(this);
		appInformation.setTitle(getResources().getString(R.string.app_name));
		appInformation.setSummary(versionInfo);
		appInformation.setSelectable(false);
		prefCategory[1].addPreference(appInformation);
		
        return root;
	}
	
}
