package tw.edu.ntu.csie.mgov.casefilter;

import java.util.HashMap;

import tw.edu.ntu.csie.mgov.R;

import android.content.Context;

public class QIDToDescription {

	private static HashMap<Integer, Integer> qidMap;
	
	public static int getResIDByQID (int qid) {
		
		if (qidMap == null) {
			setUpMap();
		}
		
		return qidMap.get(qid);
	}
	
	public static String getDetailByQID (Context context, int qid) {
		return context.getResources().getString( getResIDByQID(qid) );
	}
	
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
		qidMap.put(4104, R.string.sec4_1_4);
//		qidMap.put(4104, R.string.sec4_1_5); /** 多個種類對到一個 qid */
		qidMap.put(4105, R.string.sec4_1_6);
//		qidMap.put(4105, R.string.sec4_1_7); /** 多個種類對到一個 qid */
		qidMap.put(4106, R.string.sec4_1_8);
		qidMap.put(4107, R.string.sec4_1_9);
	}
}
