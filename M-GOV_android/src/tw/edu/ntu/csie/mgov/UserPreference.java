/**
 * 
 */
package tw.edu.ntu.csie.mgov;

import android.app.ActivityGroup;
import android.os.Bundle;

/**
 * @author sodas
 *
 */
public class UserPreference extends ActivityGroup {
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.userpreference);
	}
}
