package tool;

public class StaticValue {
	// 0: Unsure state, 1: Done, 2: Reject
	public final static String[] region={"松山區","信義區","大安區","中山區","中正區","大同區","萬華區","文山區","南港區","內湖區","士林區","北投區"};
	public final static String[] status={"收件","查報","長期計畫","短期計畫","退回區公所","轉府外單位","無法辦理","完工","結案","查驗未通過"};
	public final static int statusv[]={0,0,0,0,2,1,2,1,1,0};

	public static int findStatusv(String s)
	{
		for(int i=0;i<status.length;i++){
			if(status[i].equals(s))
				return statusv[i];
		}
		return -1;
	}
}

