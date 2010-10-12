/**
 * 
 */
package tw.edu.ntu.mgov.test;

import org.json.JSONException;

import android.util.Log;

import tw.edu.ntu.mgov.gae.GAECase;
import tw.edu.ntu.mgov.gae.GAEQuery;

/**
 * @author ggm
 * 2010/10/13
 * @company NTU CSIE Mobile HCI Lab
 */
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
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Log.d("Test","done");
	}
	
}
