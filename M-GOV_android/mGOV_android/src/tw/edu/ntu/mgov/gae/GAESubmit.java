package tw.edu.ntu.mgov.gae;

import java.io.File;
import java.io.InputStream;

import android.content.Context;
import android.net.Uri;
import tw.edu.ntu.mgov.net.ReadUrlByPOST;
import tw.edu.ntu.mgov.net.SendImage;

public class GAESubmit {

	private GAECase czone;
	private String defualtURL = "http://ntu-ecoliving.appspot.com/case?method=upload";
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
			byte[] image_bytes = null;
			if(path!=null){
				String uri=path[0];
				
				InputStream is = context.getContentResolver().openInputStream(Uri.parse(uri));
				long size = context.getContentResolver().openFileDescriptor(Uri.parse(uri), "r").getStatSize();
				image_bytes = new byte[(int) size];
				is.read(image_bytes, 0, (int) size);
			}

			
			SendImage u = new SendImage(defualtURL);
			u.setTextMap(czone);
			u.addByteParameter("photo",image_bytes);
			
			byte[] b = u.send();
			String result = new String(b);
			System.out.println(result);
			
			String res;
			res = ReadUrlByPOST.doSubmit(defualtURL, czone,context);
			System.out.println(res);
		
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
	
		return true;
	}


	public boolean doSubmit2(){
		try {

			String res = ReadUrlByPOST.doSubmit(defualtURL, czone, context);
			System.out.println(res);
		
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
	
		return true;
	}

}
