/**
 * 
 */
package tw.edu.ntu.mgov.caseviewer;

import org.json.JSONException;

import tw.edu.ntu.mgov.R;
import tw.edu.ntu.mgov.gae.GAECase;
import tw.edu.ntu.mgov.gae.GAEQuery;
import tw.edu.ntu.mgov.gae.GAEQuery.GAEQueryCondtionType;
import tw.edu.ntu.mgov.gae.GAEQuery.GAEQueryDatabase;
import tw.edu.ntu.mgov.typeselector.QidToDescription;

import com.google.android.maps.GeoPoint;
import com.google.android.maps.MapActivity;
import com.google.android.maps.MapView;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

/**
 * @author shou
 * 2010/10/13
 * @company NTU CSIE Mobile HCI Lab
 */
public class CaseViewer extends MapActivity {

	// Views 
	private ImageView photoView;
	private MapView mapView;
	private TextView caseID;
	private TextView date;
	private TextView caseStatus;
	private TextView caseType;
	private TextView description;
	private TextView caseAddress;
	
	GAEQuery qGAE;
	GAECase queryResult;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		qGAE = new GAEQuery();
		try {
			queryResult = qGAE.getID(getIntent().getExtras().getString("caseID"));
		} catch (JSONException e) {
			e.printStackTrace();
		}
		super.onCreate(savedInstanceState);
		
		setTitle("案件資料");
		setContentView(R.layout.caseviewer);
		findAllViews();
		
		setAllAttributes();
	}
	
	private void findAllViews() {
		photoView = (ImageView) findViewById(R.id.CaseViewer_Photo);
		mapView = (MapView) findViewById(R.id.CaseViewer_Map);
		caseID = (TextView) findViewById(R.id.CaseViewer_CaseID);
		date = (TextView) findViewById(R.id.CaseViewer_Date);
		caseStatus = (TextView) findViewById(R.id.CaseViewer_CaseStatus);
		caseType = (TextView) findViewById(R.id.CaseViewer_CaseType);
		description = (TextView) findViewById(R.id.CaseViewer_Description);
		caseAddress = (TextView) findViewById(R.id.CaseViewer_Address);
		photoView.setFocusable(false);
	}
	
	private void setAllAttributes() {
		caseID.setText(queryResult.getform("key"));
		date.setText(queryResult.getform("date"));
		caseStatus.setText(queryResult.getform("status"));
		caseType.setText(QidToDescription.getDetailByQID(this, Integer.parseInt(queryResult.getform("typeid"))));
		description.setText(queryResult.getform("detail"));
		caseAddress.setText(queryResult.getform("address"));
		//String [] str = queryResult.getImage();
		//Log.d("hey", str[0]);
		mapView.getController().animateTo(queryResult.getGeoPoint());
	}

	/* (non-Javadoc)
	 * @see com.google.android.maps.MapActivity#isRouteDisplayed()
	 */
	@Override
	protected boolean isRouteDisplayed() {
		// TODO Auto-generated method stub
		return false;
	}
	
}
