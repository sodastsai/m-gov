/*
 * 
 * GAESubmit.java
 * ggm
 * 
 * Submit case to Google App Engine
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
package tw.edu.ntu.mgov1999.gae;

import java.io.InputStream;

import android.content.Context;
import android.net.Uri;
import android.util.Log;
import tw.edu.ntu.mgov1999.mgov;
import tw.edu.ntu.mgov1999.net.ReadUrlByPOST;
import tw.edu.ntu.mgov1999.net.SendImage;

public class GAESubmit {

	private GAECase czone;
	private String defualtURL = "http://ntu-ecoliving.appspot.com/case/add";
	private Context context;
	
	public GAESubmit(GAECase czone, Context context){
		this.czone = czone;
		this.context = context;
	}

	public void setContext(Context context){
		this.context=context;
	}
	
	public boolean doSubmit(){
		try {

			String path[] = czone.getImage();
			SendImage u = new SendImage(defualtURL);
			byte[] image_bytes = null;
			if(path!=null){
				String uri=path[0];
				
				InputStream is = context.getContentResolver().openInputStream(Uri.parse(uri));
				long size = context.getContentResolver().openFileDescriptor(Uri.parse(uri), "r").getStatSize();
				image_bytes = new byte[(int) size];
				is.read(image_bytes, 0, (int) size);
				u.addByteParameter("photo",image_bytes);
			}
			
			u.setTextPatams(czone);
			
			byte[] b = u.send();
			String result = new String(b);
			System.out.println(result);
			if (mgov.DEBUG_MODE)
				Log.d("GAEQuery", result);
			
		} catch (Exception e) {
			e.printStackTrace();
		} 
	
		return true;
	}


	public boolean doSubmit2(){
		try {
			String res = ReadUrlByPOST.doSubmit(defualtURL, czone);
			System.out.println(res);
		
		} catch (Exception e) {
			e.printStackTrace();
		} 
	
		return true;
	}

}
