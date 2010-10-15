package tw.edu.ntu.mgov.gae;

import android.content.Context;
import tw.edu.ntu.mgov.net.ReadUrlByPOST;

public class GAESubmit {

	private GAECase czone;
	private String defualtURL = "http://ntu-ecoliving.appspot.com/case?method=upload";
	private Context context;
	
	public GAESubmit(GAECase czone){
		this.czone = czone;
	}

	public void setContext(Context context){
		this.context=context;
	}
	
	public boolean doSubmit(){
		try {
			
			String res;
			res = ReadUrlByPOST.doSubmit(defualtURL, czone,context);
			System.out.println(res);
		
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
	
		return true;
	}
}
