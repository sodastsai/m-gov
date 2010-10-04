package tw.edu.ntu.mgov.gae;

import tw.edu.ntu.mgov.net.ReadUrlByPOST;

public class GAESubmit {

	private GAECase czone;
	private String defualtURL = "http://ntu-ecoliving.appspot.com/case?method=upload";
	
	public GAESubmit(GAECase czone){
		this.czone = czone;
	}

	
	public boolean doSubmit(){
		try {
			String res;
			res = ReadUrlByPOST.doSubmit(defualtURL, czone);
			System.out.println(res);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
	
		return true;
	}
}
