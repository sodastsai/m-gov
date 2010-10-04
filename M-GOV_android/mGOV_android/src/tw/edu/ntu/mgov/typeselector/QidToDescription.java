package tw.edu.ntu.mgov.typeselector;

import java.util.HashMap;

import tw.edu.ntu.mgov.R;

import android.content.Context;

/**
 * This class provides two static methods, which is used to provide the 
 * corresponding "description" of a specific qid. 
 * 
 * @author vagrants
 */
public class QidToDescription {

	private static HashMap<Integer, Integer> qidMap;
	
	/**
	 * Get the description of a type of query using qid.<br>
	 * The return value of this method is in type of int, which represents the corresponding
	 * string Resource ID.
	 * 
	 * @param qid
	 * @return a string ResourseID corresponding to a type of query, or -1 not found
	 */
	public static int getResIDByQID (int qid) {
		
		if (qidMap == null) {
			setUpMap();
		}
		
		Integer result = qidMap.get(qid);
		
		if (result == null) {
			return -1;	//	couldn't find the corresponding resID for this qid, return -1
		}
		
		return result;
	}
	
	/**
	 * Get the description of a type of query using qid.
	 * 
	 * @param context for this method to access the Resources of the App 
	 * @param qid
	 * @return the detail description of a type query, or null if not found
	 */
	public static String getDetailByQID (Context context, int qid) {
		
		int resID = getResIDByQID(qid);
		
		if (resID == -1) {
			return null;	// couldn't find the corresponding String for this gid, return null 
		}
		
		return context.getResources().getString( resID );
	}
	
	/**
	 * Used for setup private map that mapping the qid to ResId
	 */
	private static void setUpMap() {
		qidMap = new HashMap<Integer, Integer>();
		
		qidMap.put(1101, R.string.sec1_1_1);
		qidMap.put(1102, R.string.sec1_1_2);
		qidMap.put(1103, R.string.sec1_1_3);
		qidMap.put(1104, R.string.sec1_1_4);
		qidMap.put(1105, R.string.sec1_1_5);
		qidMap.put(1106, R.string.sec1_1_6);
		qidMap.put(1107, R.string.sec1_1_7);
		qidMap.put(1108, R.string.sec1_1_8);
		qidMap.put(1109, R.string.sec1_1_9);
		qidMap.put(1110, R.string.sec1_1_10_1);
		qidMap.put(1111, R.string.sec1_1_10_2);
		qidMap.put(1112, R.string.sec1_1_11_1);
		qidMap.put(1113, R.string.sec1_1_11_2);
		
		qidMap.put(1201, R.string.sec1_2_1);
		qidMap.put(1202, R.string.sec1_2_2);
		qidMap.put(1203, R.string.sec1_2_3_1);
		qidMap.put(1204, R.string.sec1_2_3_2);
		qidMap.put(1205, R.string.sec1_2_4_1);
		qidMap.put(1206, R.string.sec1_2_4_2);
		
		qidMap.put(1301, R.string.sec1_3);
		
		
		qidMap.put(2101, R.string.sec2_1_1_1);
		qidMap.put(2102, R.string.sec2_1_1_2);
		qidMap.put(2103, R.string.sec2_1_2_1);
		qidMap.put(2104, R.string.sec2_1_2_2);
		qidMap.put(2105, R.string.sec2_1_3);
		qidMap.put(2106, R.string.sec2_1_4);
		qidMap.put(2107, R.string.sec2_1_5);
		qidMap.put(2108, R.string.sec2_1_6);
		qidMap.put(2109, R.string.sec2_1_7);
		qidMap.put(2110, R.string.sec2_1_8);
		qidMap.put(2111, R.string.sec2_1_9);
		
		qidMap.put(2201, R.string.sec2_2_1);
		qidMap.put(2202, R.string.sec2_2_2);
		qidMap.put(2203, R.string.sec2_2_3);
		qidMap.put(2204, R.string.sec2_2_4);
		qidMap.put(2205, R.string.sec2_2_5);
		
		
		qidMap.put(3101, R.string.sec3_1_1);
		qidMap.put(3102, R.string.sec3_1_2);
		qidMap.put(3103, R.string.sec3_1_3);
		qidMap.put(3104, R.string.sec3_1_4);
		
		qidMap.put(3201, R.string.sec3_2_1);
		qidMap.put(3202, R.string.sec3_2_2);
		qidMap.put(3203, R.string.sec3_2_3);
		qidMap.put(3204, R.string.sec3_2_4);
		qidMap.put(3205, R.string.sec3_2_5);
		
		qidMap.put(3301, R.string.sec3_3_1);
		qidMap.put(3302, R.string.sec3_3_2);
		qidMap.put(3303, R.string.sec3_3_3);
		qidMap.put(3304, R.string.sec3_3_4);
		qidMap.put(3305, R.string.sec3_3_5);
		
		qidMap.put(4101, R.string.sec4_1_1);
		qidMap.put(4102, R.string.sec4_1_2);
		qidMap.put(4103, R.string.sec4_1_3);
//		qidMap.put(4104, R.string.sec4_1_4);
//		qidMap.put(4104, R.string.sec4_1_5); /** 多個種類對到一個 qid */
		qidMap.put(4104, R.string.sec_s_qid4104);
//		qidMap.put(4105, R.string.sec4_1_6);
//		qidMap.put(4105, R.string.sec4_1_7); /** 多個種類對到一個 qid */
		qidMap.put(4105, R.string.sec_s_qid4105);
		qidMap.put(4106, R.string.sec4_1_8);
		qidMap.put(4107, R.string.sec4_1_9);
		
		qidMap.put(4201, R.string.sec4_2_1);
		qidMap.put(4202, R.string.sec4_2_2);
		qidMap.put(4203, R.string.sec4_2_3);
		qidMap.put(4204, R.string.sec4_2_4);
		qidMap.put(4205, R.string.sec4_2_5);
		qidMap.put(4206, R.string.sec4_2_6);
		qidMap.put(4207, R.string.sec4_2_7);
		qidMap.put(4208, R.string.sec4_2_8);
		qidMap.put(4209, R.string.sec4_2_9);
		qidMap.put(4210, R.string.sec4_2_10);

		qidMap.put(4301, R.string.sec4_3_1);
		qidMap.put(4302, R.string.sec4_3_2);
		qidMap.put(4303, R.string.sec4_3_3);
//		qidMap.put(4304, R.string.sec4_3_4);
//		qidMap.put(4304, R.string.sec4_3_5); /** 多個種類對到一個 qid */
		qidMap.put(4304, R.string.sec_s_qid4304);
		qidMap.put(4305, R.string.sec4_3_6);
		qidMap.put(4306, R.string.sec4_3_7);
		qidMap.put(4307, R.string.sec4_3_8);
		qidMap.put(4308, R.string.sec4_3_9);
		qidMap.put(4309, R.string.sec4_3_10);
		
		qidMap.put(4401, R.string.sec4_4_1);
		qidMap.put(4402, R.string.sec4_4_2);
		qidMap.put(4403, R.string.sec4_4_3);
		qidMap.put(4404, R.string.sec4_4_4);
		qidMap.put(4405, R.string.sec4_4_5);
		qidMap.put(4406, R.string.sec4_4_6);
		qidMap.put(4407, R.string.sec4_4_7);
		qidMap.put(4408, R.string.sec4_4_8);
//		qidMap.put(4409, R.string.sec4_4_9);
//		qidMap.put(4409, R.string.sec4_4_10); /** 多個種類對到一個 qid */
		qidMap.put(4409, R.string.sec_s_qid4409);
//		qidMap.put(4410, R.string.sec4_4_11);
//		qidMap.put(4410, R.string.sec4_4_12); /** 多個種類對到一個 qid */
		qidMap.put(4410, R.string.sec_s_qid4410);
		
		qidMap.put(5101, R.string.sec5_1_1);
		qidMap.put(5102, R.string.sec5_1_2);
		qidMap.put(5103, R.string.sec5_1_3);
		qidMap.put(5104, R.string.sec5_1_4);
		qidMap.put(5105, R.string.sec5_1_5);
		qidMap.put(5106, R.string.sec5_1_6);
		qidMap.put(5107, R.string.sec5_1_7);
		qidMap.put(5108, R.string.sec5_1_8);
		qidMap.put(5109, R.string.sec5_1_9);
		qidMap.put(5110, R.string.sec5_1_10);
		qidMap.put(5111, R.string.sec5_1_11);
		qidMap.put(5112, R.string.sec5_1_12);
		qidMap.put(5113, R.string.sec5_1_13);
		
		qidMap.put(5201, R.string.sec5_2);
		
		qidMap.put(5301, R.string.sec5_3_1);
		qidMap.put(5302, R.string.sec5_3_2);
		qidMap.put(5303, R.string.sec5_3_3);
		qidMap.put(5304, R.string.sec5_3_4);
		qidMap.put(5305, R.string.sec5_3_5);
		qidMap.put(5306, R.string.sec5_3_6);
		
		qidMap.put(5401, R.string.sec5_4_1);	
		qidMap.put(5402, R.string.sec5_4_2);
		qidMap.put(5403, R.string.sec5_4_3);
		qidMap.put(5404, R.string.sec5_4_4);
		qidMap.put(5405, R.string.sec5_4_5);
		qidMap.put(5406, R.string.sec5_4_6);
		qidMap.put(5407, R.string.sec5_4_7_1);
		qidMap.put(5408, R.string.sec5_4_7_2);
		qidMap.put(5409, R.string.sec5_4_7_3);
		qidMap.put(5410, R.string.sec5_4_8_1);
		qidMap.put(5411, R.string.sec5_4_8_2);
		
		qidMap.put(5501, R.string.sec5_5_1);
		qidMap.put(5502, R.string.sec5_5_2);
		qidMap.put(5503, R.string.sec5_5_3);
		qidMap.put(5504, R.string.sec5_5_4);
		
		qidMap.put(6101, R.string.sec6_1_1_1);
		qidMap.put(6101, R.string.sec6_1_1_2);
		qidMap.put(6101, R.string.sec6_1_2);
		
		qidMap.put(6201, R.string.sec6_2_1);
		qidMap.put(6202, R.string.sec6_2_2);
		
		qidMap.put(6301, R.string.sec6_3_1);
		qidMap.put(6302, R.string.sec6_3_2);
		qidMap.put(6303, R.string.sec6_3_3_1);
		qidMap.put(6304, R.string.sec6_3_3_2);
		qidMap.put(6305, R.string.sec6_3_3_3);
		qidMap.put(6306, R.string.sec6_3_4_1);
		qidMap.put(6307, R.string.sec6_3_4_2);
		qidMap.put(6308, R.string.sec6_3_5_1);
		qidMap.put(6309, R.string.sec6_3_5_2);
		qidMap.put(6310, R.string.sec6_3_6);
		qidMap.put(6311, R.string.sec6_3_7);
		
//		qidMap.put(6401, R.string.sec6_4_1);
//		qidMap.put(6401, R.string.sec6_4_2); /** 多個種類對到一個 qid */
		qidMap.put(6401, R.string.sec_s_qid6401);
		qidMap.put(6402, R.string.sec6_4_3);
		qidMap.put(6403, R.string.sec6_4_4);
		qidMap.put(6404, R.string.sec6_4_5);
		qidMap.put(6405, R.string.sec6_4_6);
	}
}
