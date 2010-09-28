package tw.edu.ntu.csie.mgov.gae;

import java.util.HashMap;
import tw.edu.ntu.csie.mgov.net.ReadUrlByPOST;

public class GAESubmit {

	private GAECase czone;
	private String defualtURL = "http://ntu-ecoliving.appspot.com/case?method=upload";
	
	public GAESubmit(GAECase czone){
		this.czone = czone;
	}

	public boolean doSubmit(){
		try {
			HashMap<String,String> data = czone.toMap();
			ReadUrlByPOST.doSubmit(defualtURL, data);

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
	
		return true;
	}
}
