/*
 * 
 * DetailSelectoe.java
 * vagrants
 * 
 * Second level type selector
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
package tw.edu.ntu.mgov.typeselector;

import java.util.ArrayList;

import tw.edu.ntu.mgov.R;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.preference.Preference;
import android.preference.PreferenceActivity;
import android.preference.PreferenceCategory;
import android.preference.PreferenceScreen;
import android.util.Log;

public class DetailSelector extends PreferenceActivity{

	private int[] des;
	private int[] qid;
	private int tid;	// the id given by the caller 
	
	private final static String LOGTAG = "MGOV-SubCaseFilter";
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		setTitle(R.string.case_filter_select_title);
		
		setUpRefData();
		setPreferenceScreen(createPreferenceHierarchy());
		setResult(RESULT_CANCELED, null);
	}
	
	/**
	 * setup the content (eg. each name of pref, each qid of pref, ...)  
	 */
	private void setUpRefData() {
		
		Bundle bundle = this.getIntent().getExtras();
		tid = bundle.getInt("tid", -1);
		
		// close this activity if no argument is given to this activity 
		if (tid == -1) {
			Log.e(LOGTAG, "With wrong input tid = " + tid);
			this.finish();
		}
		
		switch(tid) {
		case R.string.sec1_1:
			des = des1_1;
			qid = qid1_1;
			break;
		case R.string.sec1_2:
			des = des1_2;
			qid = qid1_2;
			break;
		case R.string.sec2_1:
			des = des2_1;
			qid = qid2_1;
			break;
		case R.string.sec2_2:
			des = des2_2;
			qid = qid2_2;
			break;
		case R.string.sec3_1:
			des = des3_1;
			qid = qid3_1;
			break;
		case R.string.sec3_2:
			des = des3_2;
			qid = qid3_2;
			break;
		case R.string.sec3_3:
			des = des3_3;
			qid = qid3_3;
			break;
		case R.string.sec4_1:
			des = des4_1;
			qid = qid4_1;
			break;
		case R.string.sec4_2:
			des = des4_2;
			qid = qid4_2;
			break;
		case R.string.sec4_3:
			des = des4_3;
			qid = qid4_3;
			break;
		case R.string.sec4_4:
			des = des4_4;
			qid = qid4_4;
			break;
		case R.string.sec5_1:
			des = des5_1;
			qid = qid5_1;
			break;
		case R.string.sec5_3:
			des = des5_3;
			qid = qid5_3;
			break;	
		case R.string.sec5_4:
			des = des5_4;
			qid = qid5_4;
			break;
		case R.string.sec5_5:
			des = des5_5;
			qid = qid5_5;
			break;
		case R.string.sec6_1:
			des = des6_1;
			qid = qid6_1;
			break;
		case R.string.sec6_2:
			des = des6_2;
			qid = qid6_2;
			break;
		case R.string.sec6_3:
			des = des6_3;
			qid = qid6_3;
			break;
		case R.string.sec6_4:
			des = des6_4;
			qid = qid6_4;
			break;
		}
	}
	
	/**
	 * setup content view of this activity.
	 * 
	 * @return PreferenceScreen
	 */
	private PreferenceScreen createPreferenceHierarchy() {
		// Root
        PreferenceScreen root = getPreferenceManager().createPreferenceScreen(this);
        PreferenceCategory cat = new PreferenceCategory(this);
        cat.setTitle(tid);
        root.addPreference(cat);
        
        for (int i = 0; i < des.length; i++) {
        	Preference subSecPref = new Preference(this);
       		subSecPref.setTitle(des[i]);
       		setClickListenerOn(subSecPref, i);	// setOnClickListener 
       		cat.addPreference(subSecPref);
        }
        
        return root;
	}
	
	
	/**
	 * setOnClickListener
	 * 
	 * @param pref
	 * @param index
	 */
	private void setClickListenerOn (Preference pref, final int index) {
		
		@SuppressWarnings("unused")
		final Context context = this;
		
		if (qid[index] != -1) {	
			// if can get the qid in this level, returns the qid 
			pref.setOnPreferenceClickListener(new Preference.OnPreferenceClickListener() {
				@Override
				public boolean onPreferenceClick(Preference preference) {
					Bundle bundle = new Bundle();
					bundle.putInt("qid", qid[index]);
					bundle.putString("detail", getString(des[index]));
					Intent intent = new Intent();
					intent.putExtras(bundle);
					setResult(RESULT_OK, intent);
//					Toast.makeText(context, "qid=" + qid[index] +"\ndetail=" + getString(des[index]) , Toast.LENGTH_SHORT).show();
					finish();
					return false;
				}
			});
		} else {
			// can't get the qid in this level, start a Dialog to get more detail information 
			pref.setOnPreferenceClickListener(new Preference.OnPreferenceClickListener() {
				@Override
				public boolean onPreferenceClick(Preference preference) {
					selectForMoreDetial(preference, index);
					return false;
				}
			});
		}
	}
	
	/**
	 * setup the third level of choices  
	 * 
	 * @param preference
	 * @param index
	 */
	private void selectForMoreDetial(Preference preference, final int index) {
		final MoreDetailHolder holder = getHolder(index);
		
		@SuppressWarnings("unused")
		final Context mContext = this;
		
		ArrayList<String> dess = new ArrayList<String>();
		String[] dessArray = new String[holder.dess.length];
		
		for(int i = 0; i < holder.dess.length; i++) {
			dess.add(getString(holder.dess[i]));
		}
		dessArray = dess.toArray(dessArray);
		
		AlertDialog.Builder builder = new AlertDialog.Builder(this);
		builder.setTitle(holder.title)
			.setItems(dessArray, new DialogInterface.OnClickListener() {
				@Override
				public void onClick(DialogInterface dialog, int which) {
					Log.d(LOGTAG , "onClick DialogInterface which = " + which );
					Bundle bundle = new Bundle();
					bundle.putInt("qid", holder.qid[which]);
					bundle.putString("detail", getString(holder.des[which]));
					Intent intent = new Intent();
					intent.putExtras(bundle);
					setResult(RESULT_OK, intent);
//					Toast.makeText(mContext, "qid=" + holder.qid[which] +"\ndetail=" + getString(holder.des[which]) , Toast.LENGTH_SHORT).show();
					finish();
				}
			})
			.create()
			.show();
	}
	
	// just used as a type of a set of some attributes  
	private class MoreDetailHolder {
		int title;
		int[] des;
		int[] dess;
		int[] qid;
	}
	
	private MoreDetailHolder getHolder(int index) {
		MoreDetailHolder holder = new MoreDetailHolder();
		
		switch(tid) {
		case R.string.sec1_1:
			if (index == 9) {
				holder.title = des1_1_10t;
				holder.des = des1_1_10;
				holder.dess = des1_1_10s;
				holder.qid = qid1_1_10;
			} else { // index == 10
				holder.title = des1_1_11t;
				holder.des = des1_1_11;
				holder.dess = des1_1_11s;
				holder.qid = qid1_1_11;
			}
			break;
		case R.string.sec1_2:
			if (index == 2) {
				holder.title = des1_2_3t;
				holder.des = des1_2_3;
				holder.dess = des1_2_3s;
				holder.qid = qid1_2_3;
			} else { // index == 3
				holder.title = des1_2_4t;
				holder.des = des1_2_4;
				holder.dess = des1_2_4s;
				holder.qid = qid1_2_4;
			}
			break;
		case R.string.sec2_1:
			if (index == 0) {
				holder.title = des2_1_1t;
				holder.des = des2_1_1;
				holder.dess = des2_1_1s;
				holder.qid = qid2_1_1;
			} else { // index == 1
				holder.title = des2_1_2t;
				holder.des = des2_1_2;
				holder.dess = des2_1_2s;
				holder.qid = qid2_1_2;
			}
			break;
		case R.string.sec5_4:
			if (index == 6) {
				holder.title = des5_4_7t;
				holder.des = des5_4_7;
				holder.dess = des5_4_7s;
				holder.qid = qid5_4_7;
			} else { // index == 7
				holder.title = des5_4_8t;
				holder.des = des5_4_8;
				holder.dess = des5_4_8s;
				holder.qid = qid5_4_8;
			}
			break;
		case R.string.sec6_1:
			// index == 0
			holder.title = des6_1_1t;
			holder.des = des6_1_1;
			holder.dess = des6_1_1s;
			holder.qid = qid6_1_1;
			break;
		case R.string.sec6_3:
			if (index == 2) {
				holder.title = des6_3_3t;
				holder.des = des6_3_3;
				holder.dess = des6_3_3s;
				holder.qid = qid6_3_3;
			} else if (index == 3) {
				holder.title = des6_3_4t;
				holder.des = des6_3_4;
				holder.dess = des6_3_4s;
				holder.qid = qid6_3_4;
			} else { // index == 4
				holder.title = des6_3_5t;
				holder.des = des6_3_5;
				holder.dess = des6_3_5s;
				holder.qid = qid6_3_5;
			}
			break;
		}
		return holder;
	}
	
	private static final int[] des1_1 = {
		R.string.sec1_1_1,
		R.string.sec1_1_2,
		R.string.sec1_1_3,
		R.string.sec1_1_4,
		R.string.sec1_1_5,
		R.string.sec1_1_6,
		R.string.sec1_1_7,
		R.string.sec1_1_8,
		R.string.sec1_1_9,
		R.string.sec1_1_10,
		R.string.sec1_1_11
	};
	private static final int[] des1_2 = {
		R.string.sec1_1_1,
		R.string.sec1_2_2,
		R.string.sec1_2_3,
		R.string.sec1_2_4
	};
	
	private static final int[] des2_1 = {
		R.string.sec2_1_1,
		R.string.sec2_1_2,
		R.string.sec2_1_3,
		R.string.sec2_1_4,
		R.string.sec2_1_5,
		R.string.sec2_1_6,
		R.string.sec2_1_7,
		R.string.sec2_1_8,
		R.string.sec2_1_9
	};
	
	private static final int[] des2_2 = {
		R.string.sec2_2_1,
		R.string.sec2_2_2,
		R.string.sec2_2_3,
		R.string.sec2_2_4,
		R.string.sec2_2_5
	};
	
	private static final int[] des3_1 = {
		R.string.sec3_1_1,
		R.string.sec3_1_2,
		R.string.sec3_1_3,
		R.string.sec3_1_4
	};
	
	private static final int[] des3_2 = {
		R.string.sec3_2_1,
		R.string.sec3_2_2,
		R.string.sec3_2_3,
		R.string.sec3_2_4,
		R.string.sec3_2_5
	};
	
	private static final int[] des3_3 = {
		R.string.sec3_3_1,
		R.string.sec3_3_2,
		R.string.sec3_3_3,
		R.string.sec3_3_4,
		R.string.sec3_3_5
	};
	
	private static final int[] des4_1 = {
		R.string.sec4_1_1,
		R.string.sec4_1_2,
		R.string.sec4_1_3,
		R.string.sec4_1_4,
		R.string.sec4_1_5,
		R.string.sec4_1_6,
		R.string.sec4_1_7,
		R.string.sec4_1_8,
		R.string.sec4_1_9
	};
	
	private static final int[] des4_2 = {
		R.string.sec4_2_1,
		R.string.sec4_2_2,
		R.string.sec4_2_3,
		R.string.sec4_2_4,
		R.string.sec4_2_5,
		R.string.sec4_2_6,
		R.string.sec4_2_7,
		R.string.sec4_2_8,
		R.string.sec4_2_9,
		R.string.sec4_2_10
	};
	
	private static final int[] des4_3 = {
		R.string.sec4_3_1,
		R.string.sec4_3_2,
		R.string.sec4_3_3,
		R.string.sec4_3_4,
		R.string.sec4_3_5,
		R.string.sec4_3_6,
		R.string.sec4_3_7,
		R.string.sec4_3_8,
		R.string.sec4_3_9,
		R.string.sec4_3_10
	};
	
	private static final int[] des4_4 = {
		R.string.sec4_4_1,
		R.string.sec4_4_2,
		R.string.sec4_4_3,
		R.string.sec4_4_4,
		R.string.sec4_4_5,
		R.string.sec4_4_6,
		R.string.sec4_4_7,
		R.string.sec4_4_8,
		R.string.sec4_4_9,
		R.string.sec4_4_10,
		R.string.sec4_4_11,
		R.string.sec4_4_12
	};
	
	private static final int[] des5_1 = {
		R.string.sec5_1_1,
		R.string.sec5_1_2,
		R.string.sec5_1_3,
		R.string.sec5_1_4,
		R.string.sec5_1_5,
		R.string.sec5_1_6,
		R.string.sec5_1_7,
		R.string.sec5_1_8,
		R.string.sec5_1_9,
		R.string.sec5_1_10,
		R.string.sec5_1_11,
		R.string.sec5_1_12,
		R.string.sec5_1_13
	};
	
	private static final int[] des5_3 = {
		R.string.sec5_3_1,
		R.string.sec5_3_2,
		R.string.sec5_3_3,
		R.string.sec5_3_4,
		R.string.sec5_3_5,
		R.string.sec5_3_6
	};
	
	private static final int[] des5_4 = {
		R.string.sec5_4_1,
		R.string.sec5_4_2,
		R.string.sec5_4_3,
		R.string.sec5_4_4,
		R.string.sec5_4_5,
		R.string.sec5_4_6,
		R.string.sec5_4_7,
		R.string.sec5_4_8
	};
	
	private static final int[] des5_5 = {
		R.string.sec5_5_1,
		R.string.sec5_5_2,
		R.string.sec5_5_3,
		R.string.sec5_5_4
	};
	
	private static final int[] des6_1 = {
		R.string.sec6_1_1,
		R.string.sec6_1_2
	};
	
	private static final int[] des6_2 = {
		R.string.sec6_2_1,
		R.string.sec6_2_2
	};
	
	private static final int[] des6_3 = {
		R.string.sec6_3_1,
		R.string.sec6_3_2,
		R.string.sec6_3_3,
		R.string.sec6_3_4,
		R.string.sec6_3_5,
		R.string.sec6_3_6,
		R.string.sec6_3_7
	};
	
	private static final int[] des6_4 = {
		R.string.sec6_4_1,
		R.string.sec6_4_2,
		R.string.sec6_4_3,
		R.string.sec6_4_4,
		R.string.sec6_4_5,
		R.string.sec6_4_6
	};
	
	private static final int[] qid1_1 = {
		1101,
		1102,
		1103,
		1104,
		1105,
		1106,
		1107,
		1108,
		1109,
		-1,
		-1
	};
	
	private static final int[] qid1_2 = {
		1201,
		1202,
		-1,
		-1
	};
	
	private static final int[] qid2_1 = {
		-1,
		-1,
		2105,
		2106,
		2107,
		2108,
		2109,
		2110,
		2111
	};
	
	private static final int[] qid2_2 = {
		2201,
		2202,
		2203,
		2204,
		2205
	};
	
	private static final int[] qid3_1 = {
		3101,
		3102,
		3103,
		3104
	};
	
	private static final int[] qid3_2 = {
		3201,
		3202,
		3203,
		3204,
		3205
	};
	
	private static final int[] qid3_3 = {
		3301,
		3302,
		3303,
		3304,
		3305
	};
	
	private static final int[] qid4_1 = {
		4101,
		4102,
		4103,
		4104,
		4104,
		4105,
		4105,
		4106,
		4107
	};
	
	private static final int[] qid4_2 = {
		4201,
		4202,
		4203,
		4204,
		4205,
		4206,
		4207,
		4208,
		4209,
		4210
	};
	
	private static final int[] qid4_3 = {
		4301,
		4302,
		4303,
		4304,
		4304,
		4305,
		4306,
		4307,
		4308,
		4309
	};
	
	private static final int[] qid4_4 = {
		4401,
		4402,
		4403,
		4404,
		4405,
		4406,
		4407,
		4408,
		4409,
		4409,
		4410,
		4410,
	};
	
	private static final int[] qid5_1 = {
		5101,
		5102,
		5103,
		5104,
		5105,
		5106,
		5107,
		5108,
		5109,
		5110,
		5111,
		5112,
		5113
	};
	
	private static final int[] qid5_3 = {
		5301,
		5302,
		5303,
		5304,
		5305,
		5306
	};
	
	private static final int[] qid5_4 = {
		5401,
		5402,
		5403,
		5404,
		5405,
		5406,
		-1,
		-1
	};
	
	private static final int[] qid5_5 = {
		5501,
		5502,
		5503,
		5504
	};
	
	private static final int[] qid6_1 = {
		-1,
		6103
	};
	
	private static final int[] qid6_2 = {
		6201,
		6202
	};
	
	private static final int[] qid6_3 = {
		6301,
		6302,
		-1,
		-1,
		-1,
		6310,
		6311
	};
	
	private static final int[] qid6_4 = {
		6401,
		6401, 
		6402,
		6403,
		6404,
		6405
	};
	private static final int des1_1_10t = R.string.case_filter_road_width_title;
	private static final int[] des1_1_10s ={
		R.string.case_filter_read_width_large,
		R.string.case_filter_read_width_normal
	};
	private static final int[] des1_1_10 ={
		R.string.sec1_1_10_1,
		R.string.sec1_1_10_2
	};
	private static final int[] qid1_1_10 = {
		1110, 
		1111
	};
	private static final int des1_1_11t = R.string.case_filter_road_width_title;
	private static final int[] des1_1_11s ={
		R.string.case_filter_read_width_large,
		R.string.case_filter_read_width_normal
	};
	private static final int[] des1_1_11 ={
		R.string.sec1_1_11_1,
		R.string.sec1_1_11_2
	};
	private static final int[] qid1_1_11 = {
		1112, 
		1113
	};
	private static final int des1_2_3t = R.string.case_filter_road_width_title;
	private static final int[] des1_2_3s ={
		R.string.case_filter_read_width_large,
		R.string.case_filter_read_width_normal
	};
	private static final int[] des1_2_3 ={
		R.string.sec1_2_3_1,
		R.string.sec1_2_3_2
	};
	private static final int[] qid1_2_3 = {
		1203, 
		1204
	};
	private static final int des1_2_4t = R.string.case_filter_road_width_title;
	private static final int[] des1_2_4s ={
		R.string.case_filter_read_width_large,
		R.string.case_filter_read_width_normal
	};
	private static final int[] des1_2_4 ={
		R.string.sec1_2_4_1,
		R.string.sec1_2_4_2
	};
	private static final int[] qid1_2_4 = {
		1205, 
		1206
	};
	private static final int des2_1_1t = R.string.case_filter_park_size_title;
	private static final int[] des2_1_1s ={
		R.string.case_filter_park_size_large,
		R.string.case_filter_park_size_normal
	};
	private static final int[] des2_1_1 ={
		R.string.sec2_1_1_1,
		R.string.sec2_1_1_2
	};
	private static final int[] qid2_1_1 = {
		2101, 
		2102
	};
	private static final int des2_1_2t = R.string.case_filter_park_size_title;
	private static final int[] des2_1_2s ={
		R.string.case_filter_park_size_large,
		R.string.case_filter_park_size_normal
	};
	private static final int[] des2_1_2 ={
		R.string.sec2_1_2_1,
		R.string.sec2_1_2_2
	};
	private static final int[] qid2_1_2 = {
		2103, 
		2104
	};
	private static final int des5_4_7t = R.string.case_filter_manhole_cover_title;
	private static final int[] des5_4_7s ={
		R.string.case_filter_manhole_cover_tpower,
		R.string.case_filter_manhole_cover_tran,
		R.string.case_filter_manhole_cover_cht
	};
	private static final int[] des5_4_7 ={
		R.string.sec5_4_7_1,
		R.string.sec5_4_7_2,
		R.string.sec5_4_7_3
	};
	private static final int[] qid5_4_7 = {
		5407, 
		5408,
		5409
	};
	private static final int des5_4_8t = R.string.case_filter_sewer_title;
	private static final int[] des5_4_8s ={
		R.string.case_filter_sewer_rain,
		R.string.case_filter_sewer_health
	};
	private static final int[] des5_4_8 ={
		R.string.sec5_4_8_1,
		R.string.sec5_4_8_2
	};
	private static final int[] qid5_4_8 = {
		5410,
		5411
	};
	private static final int des6_1_1t = R.string.case_filter_parking_title;
	private static final int[] des6_1_1s ={
		R.string.case_filter_parking_new,
		R.string.case_filter_parking_again
	};
	private static final int[] des6_1_1 ={
		R.string.sec6_1_1_1,
		R.string.sec6_1_1_2
	};
	private static final int[] qid6_1_1 = {
		6101,
		6102
	};
	private static final int des6_3_3t = R.string.case_filter_wifi_title;
	private static final int[] des6_3_3s ={
		R.string.case_filter_wifi_1,
		R.string.case_filter_wifi_2,
		R.string.case_filter_wifi_3
	};
	private static final int[] des6_3_3 ={
		R.string.sec6_3_3_1,
		R.string.sec6_3_3_2,
		R.string.sec6_3_3_3
	};
	private static final int[] qid6_3_3 = {
		6303,
		6304,
		6305
	};
	private static final int des6_3_4t = R.string.case_filter_artwork_title;
	private static final int[] des6_3_4s ={
		R.string.case_filter_artwork_1,
		R.string.case_filter_artwork_2
	};
	private static final int[] des6_3_4 ={
		R.string.sec6_3_4_1,
		R.string.sec6_3_4_2
	};
	private static final int[] qid6_3_4 = {
		6306,
		6307
	};
	private static final int des6_3_5t = R.string.case_filter_cable_tv_title;
	private static final int[] des6_3_5s ={
		R.string.case_filter_cable_tv_1,
		R.string.case_filter_cable_tv_2
	};
	private static final int[] des6_3_5 ={
		R.string.sec6_3_5_1,
		R.string.sec6_3_5_2
	};
	private static final int[] qid6_3_5 = {
		6308,
		6309
	};
}
