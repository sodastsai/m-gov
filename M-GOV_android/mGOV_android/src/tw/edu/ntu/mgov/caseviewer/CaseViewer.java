/**
 * 
 */
package tw.edu.ntu.mgov.caseviewer;

import tw.edu.ntu.mgov.R;
import tw.edu.ntu.mgov.gae.GAECase;
import tw.edu.ntu.mgov.gae.GAEQuery;
import tw.edu.ntu.mgov.gae.GAEQuery.GAEQueryCondtionType;

import com.google.android.maps.GeoPoint;
import com.google.android.maps.MapView;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

/**
 * @author shou
 * 2010/10/13
 * @company NTU CSIE Mobile HCI Lab
 */
public class CaseViewer extends Activity {

	// Views 
	private ImageView photoView;
	private MapView mapView;
	private TextView caseID;
	private TextView date;
	private TextView caseStatus;
	private TextView caseType;
	private TextView description;
	
	// vars for Case Attributes
	private int typeId = -1;
	private GeoPoint locationGeoPoint;
	private Uri pictureUri;
	
	GAEQuery qGAE;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		qGAE = new GAEQuery();
		qGAE.addQuery(GAEQueryCondtionType.GAEQueryByID, "");
		super.onCreate(savedInstanceState);
		
		setTitle("案件資料");
		setContentView(R.layout.caseviewer);
		findAllViews();
		
		
	}
	
	private void findAllViews() {
		photoView = (ImageView) findViewById(R.id.CaseViewer_Photo);
		//mapView = (MapView) findViewById(R.id.CaseViewer_Map);
		caseID = (TextView) findViewById(R.id.CaseViewer_CaseID);
		date = (TextView) findViewById(R.id.CaseViewer_Date);
		caseStatus = (TextView) findViewById(R.id.CaseViewer_CaseStatus);
		caseType = (TextView) findViewById(R.id.CaseViewer_CaseType);
		description = (TextView) findViewById(R.id.CaseViewer_Description);
	}

}
