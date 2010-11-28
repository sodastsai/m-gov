/*
 * 
 * GoogleAnalytics.java
 * 2010/11/05
 * sodas
 * 
 * Google Analytics tracker
 *
 * Copyright 2010 NTU CSIE Mobile & HCI Lab
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */
package tw.edu.ntu.mgov1999;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.google.android.apps.analytics.GoogleAnalyticsTracker;

import android.os.Build;
import android.util.Log;

public class GoogleAnalytics {
	
	private static final String AppLifecycle = "AppLifecycle";
	private static final String CaseAdder = "CaseAdderEvent";
	private static final String MyCase = "MyCaseEvent";
	private static final String QueryCase = "QueryCaseEvent";
	private static final String Option = "OptionEvent";
	private static final String AppTab = "AppTabEvent";
	
	public static enum GANAction {
		// App Lifecycle
		GANActionAppOnCreate,
		GANActionAppOnStop,
		GANActionAppOnStart,
		GANActionAppOnDestroy,
		// App Tab Event
		GANActionAppTabIsMyCase,
		GANActionAppTabIsQueryCase,
		GANActionAppTabIsOption,
		// Case Adder event
		GANActionAddCaseSuccess,
		GANActionAddCaseFailed,
		GANActionAddCaseWithName,
		GANActionAddCaseWithDescription,
		GANActionAddCaseWithPhoto,
		GANActionAddCaseWithoutPhoto,
		GANActionAddCaseWithType,
		GANActionAddCaseLocationSelectorChanged,
		// My Case Event
		GANActionMyCaseFilterAll,
		GANActionMyCaseFilterOK,
		GANActionMyCaseFilterUnknown,
		GANActionMyCaseFilterFailed,
		GANActionMyCaseMapMode,
		GANActionMyCaseListMode,
		// Query Case Event
		GANActionQueryCaseMapMode,
		GANActionQueryCaseListMode,
		GANActionQueryCaseAllType,
		GANActionQueryCaseWithType,
		// Option Event
		GANActionOptionUserChangeEmail,
		GANActionOptionUserChangeName
	}
	
	static public void startTrack(GANAction action, String label, boolean timeStamp, String udid) {
		String eventString = "";
		String actionString = "";
		
		if (action==GANAction.GANActionAppOnStop) {
			eventString = AppLifecycle;
			actionString = "AppEnterBackground";
		} else if (action==GANAction.GANActionAppOnStart) {
			eventString = AppLifecycle;
			actionString = "AppEnterForeground";
		} else if (action==GANAction.GANActionAppOnDestroy) {
			eventString = AppLifecycle;
			// Android Event is so strange
			//actionString = "AppWillTerminate";
			actionString = "AppEnterBackground";
		} else if (action==GANAction.GANActionAppOnCreate) {
			eventString = AppLifecycle;
			// Android Event is so strange
			//actionString = "AppDidStartup";
			actionString = "AppEnterForeground";
		} else if (action==GANAction.GANActionAddCaseSuccess) {
			eventString = CaseAdder;
			actionString = "AddCaseSuccess";
		} else if (action==GANAction.GANActionAddCaseFailed) {
			eventString = CaseAdder;
			actionString = "AddCaseFailed";
		} else if (action==GANAction.GANActionAddCaseWithPhoto) {
			eventString = CaseAdder;
			actionString= "AddCaseWithPhoto";
		} else if (action==GANAction.GANActionAddCaseWithoutPhoto) {
			eventString = CaseAdder;
			actionString= "AddCaseWithoutPhoto";
		} else if (action==GANAction.GANActionAddCaseWithName) {
			eventString = CaseAdder;
			actionString = "AddCaseWithName";
		} else if (action==GANAction.GANActionAddCaseWithDescription) {
			eventString = CaseAdder;
			actionString = "AddCaseWithDescription";
		} else if (action==GANAction.GANActionAddCaseWithType) {
			eventString = CaseAdder;
			actionString = "AddCaseWithType";
		} else if (action==GANAction.GANActionAddCaseLocationSelectorChanged) {
			eventString = CaseAdder;
			actionString = "AddCaseWithLocationSelectorChanged";
		} else if (action==GANAction.GANActionMyCaseFilterAll) {
			eventString = MyCase;
			actionString = "MyCaseWithAllFilter";
		} else if (action==GANAction.GANActionMyCaseFilterOK) {
			eventString = MyCase;
			actionString = "MyCaseWithOKFilter";
		} else if (action==GANAction.GANActionMyCaseFilterUnknown) {
			eventString = MyCase;
			actionString = "MyCaseWithUnknownFilter";
		} else if (action==GANAction.GANActionMyCaseFilterFailed) {
			eventString = MyCase;
			actionString = "MyCaseWithFailedFilter";
		} else if (action==GANAction.GANActionMyCaseListMode) {
			eventString = MyCase;
			actionString = "MyCaseWithListMode";
		} else if (action==GANAction.GANActionMyCaseMapMode) {
			eventString = MyCase;
			actionString = "MyCaseWithMapMode";
		} else if (action==GANAction.GANActionQueryCaseMapMode) {
			eventString = QueryCase;
			actionString = "QueryCaseWithMapMode";
		} else if (action==GANAction.GANActionQueryCaseListMode) {
			eventString = QueryCase;
			actionString = "QueryCaseWithListMode";
		} else if (action==GANAction.GANActionQueryCaseAllType) {
			eventString = QueryCase;
			actionString = "QueryCaseWithAllType";
		} else if (action==GANAction.GANActionQueryCaseWithType) {
			eventString = QueryCase;
			actionString = "QueryCaseWithType";
		} else if (action==GANAction.GANActionOptionUserChangeEmail) {
			eventString = Option;
			actionString = "UserChangeEmail";
		} else if (action==GANAction.GANActionOptionUserChangeName) {
			eventString = Option;
			actionString = "UserChangeName";
		} else if (action==GANAction.GANActionAppTabIsMyCase) {
			eventString = AppTab;
			actionString = "TabMyCase";
		} else if (action==GANAction.GANActionAppTabIsQueryCase) {
			eventString = AppTab;
			actionString = "TabQueryCase";
		} else if (action==GANAction.GANActionAppTabIsOption) {
			eventString = AppTab;
			actionString = "TabOption";
		}
		
		
		if (eventString=="" || actionString=="")
			return;
		
		String labelString = "[Android]["+Build.VERSION.RELEASE+"]";
		
		if (mgov.DEBUG_MODE)
			labelString += "[Debug Mode]";
		
		if (timeStamp) {
			DateFormat dateFormatter = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss ZZZZ");
			labelString += "["+dateFormatter.format(new Date())+"]";
		}
		
		if (udid!=null)
			labelString += "["+udid+"]";
		
		if (label!=null)
			labelString += " "+label;
		
		if (mgov.DEBUG_MODE)
			Log.d("GAN", actionString+" - "+labelString);
		
		GoogleAnalyticsTracker.getInstance().trackEvent(eventString, actionString, labelString, -1);
	}
}
