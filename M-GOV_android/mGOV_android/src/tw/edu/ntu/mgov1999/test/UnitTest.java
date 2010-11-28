/*
 * 
 * UnitTest.java
 * 2010/10/13
 * ggm
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

package tw.edu.ntu.mgov1999.test;

import org.json.JSONException;

import android.util.Log;

import tw.edu.ntu.mgov1999.gae.GAECase;
import tw.edu.ntu.mgov1999.gae.GAEQuery;

public class UnitTest {

	public static void main(String args[]){
		
		System.out.println("done");
	}
	
	public static void test(){
		GAEQuery query = new GAEQuery();

		try {
			GAECase cases = query.getID("09909-508525");
			Log.d("Test",cases.toString());
		
		} catch (JSONException e) {
			e.printStackTrace();
		}
		Log.d("Test","done");
	}
	
}
