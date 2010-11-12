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
package tw.edu.ntu.mgov;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.google.android.apps.analytics.GoogleAnalyticsTracker;

import android.os.Build;
import android.util.Log;

public class GoogleAnalytics {
	
	private static final String AppLifecycle = "AppLifecycle";
	
	public static enum GANAction {
		GANActionAppOnCreate,
		GANActionAppOnStop,
		GANActionAppOnStart,
		GANActionAppOnDestroy
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
			actionString = "AppWillTerminate";
		} else if (action==GANAction.GANActionAppOnCreate) {
			eventString = AppLifecycle;
			actionString = "AppDidStartup";
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
