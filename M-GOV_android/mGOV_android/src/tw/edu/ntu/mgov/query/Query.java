/**
 * 
 */
package tw.edu.ntu.mgov.query;

import java.util.ArrayList;
import java.util.Timer;
import java.util.TimerTask;

import de.android1.overlaymanager.ManagedOverlayItem;

import android.app.ProgressDialog;
import android.content.Intent;
import android.graphics.Typeface;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.ImageButton;
import android.widget.RelativeLayout;
import android.widget.RelativeLayout.LayoutParams;
import android.widget.TextView;
import tw.edu.ntu.mgov.CaseSelector;
import tw.edu.ntu.mgov.R;
import tw.edu.ntu.mgov.gae.GAEQuery;
import tw.edu.ntu.mgov.gae.GAEQuery.GAEQueryCondtionType;
import tw.edu.ntu.mgov.gae.GAEQuery.GAEQueryDatabase;
import tw.edu.ntu.mgov.typeselector.QidToDescription;
import tw.edu.ntu.mgov.typeselector.TypeSelector;

/**
 * @author sodas
 * 2010/10/4
 * @company NTU CSIE Mobile HCI Lab
 */
public class Query extends CaseSelector {
	// Constant
	protected static final int MENU_SetTypeCondition = Menu.FIRST+3;
	protected static final int MENU_AllTypeCondition = Menu.FIRST+4;
	private static final int REQUEST_CODE_typeSelector = 1630;
	private static final int CURRENT_CONDITION_LABEL = 2048;
	private static final int NEXT_BUTTON = 2049;
	private static final int RELOAD_BUTTON = 2050;
	
	// UI
	private TextView currentConditionLabel;
	private TextView currentRangeLabel;
	private ProgressDialog loadingView;
	// Lifecycle
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// Did not show noCase Image
		noCaseImageWillShow = false;
		qGAE = new GAEQuery();
		// Set Mode before super class execute its method
		this.defaultMode = CaseSelectorMode.CaseSelectorMapMode;
		// Render the list and map by super method
		super.onCreate(savedInstanceState);
		
		currentConditionLabel = new TextView(this);
		currentConditionLabel.setId(CURRENT_CONDITION_LABEL);
		currentConditionLabel.setText(getResources().getString(R.string.query_currentConditionLabel_alltype));
		currentConditionLabel.setPadding(2, 0, 2, 0);
		currentConditionLabel.setTextSize(16.0f);
		currentConditionLabel.setTypeface(Typeface.DEFAULT_BOLD);
		LayoutParams param1 = new RelativeLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
		param1.addRule(RelativeLayout.ALIGN_PARENT_LEFT, RelativeLayout.ALIGN_PARENT_TOP);
		currentConditionLabel.setLayoutParams(param1);
		infoBar.addView(currentConditionLabel);
		param1=null;
		
		currentRangeLabel = new TextView(this);
		currentRangeLabel.setText(getResources().getString(R.string.query_currentRangeLabel_emptyCase));
		currentRangeLabel.setPadding(2, 0, 2, 0);
		currentRangeLabel.setTextSize(14.0f);
		LayoutParams param2 = new RelativeLayout.LayoutParams(LayoutParams.FILL_PARENT, LayoutParams.WRAP_CONTENT);
		param2.addRule(RelativeLayout.BELOW, CURRENT_CONDITION_LABEL);
		param2.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
		currentRangeLabel.setLayoutParams(param2);
		infoBar.addView(currentRangeLabel);
		param2=null;
		
		ImageButton nextButton = new ImageButton(this);
		nextButton.setImageResource(R.drawable.next);
		nextButton.setBackgroundResource(R.color.transparentColor);
		nextButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) { Log.d("mapMode", "next"); }
        });
		nextButton.setId(NEXT_BUTTON);
		LayoutParams param3 = new RelativeLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
		param3.addRule(RelativeLayout.ALIGN_PARENT_RIGHT, RelativeLayout.CENTER_VERTICAL);
		nextButton.setLayoutParams(param3);
		infoBar.addView(nextButton);
		param3=null;
		
		ImageButton reloadButton = new ImageButton(this);
		reloadButton.setImageResource(R.drawable.reload);
		reloadButton.setBackgroundResource(R.color.transparentColor);
		reloadButton.setId(RELOAD_BUTTON);
		reloadButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) { Log.d("mapMode", "reload"); }
        });
		LayoutParams param4 = new RelativeLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
		param4.addRule(RelativeLayout.LEFT_OF, NEXT_BUTTON);
		param4.addRule(RelativeLayout.CENTER_VERTICAL);
		reloadButton.setLayoutParams(param4);
		infoBar.addView(reloadButton);
		param4=null;
		
		ImageButton prevButton = new ImageButton(this);
		prevButton.setImageResource(R.drawable.prev);
		prevButton.setBackgroundResource(R.color.transparentColor);
		prevButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) { Log.d("mapMode", "prev"); }
        });
		LayoutParams param5 = new RelativeLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
		param5.addRule(RelativeLayout.LEFT_OF, RELOAD_BUTTON);
		param5.addRule(RelativeLayout.CENTER_VERTICAL);
		prevButton.setLayoutParams(param5);
		infoBar.addView(prevButton);
		param5=null;
		
		nextButton=null;
		reloadButton=null;
		prevButton=null;
		
		this.startQueryWithMap();
	}
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (requestCode == REQUEST_CODE_typeSelector) {
			// Get the result from Type Selector
			if (resultCode == RESULT_OK) {
				int typeId = data.getExtras().getInt("qid");
				String typeName = QidToDescription.getDetailByQID(this,typeId);
				this.startQueryWithMap(typeId);
				currentConditionLabel.setText(typeName);
			} else if (resultCode == RESULT_CANCELED) {
			}
		}
		super.onActivityResult(requestCode, resultCode, data);
	}
	/**
	 * @category DataSource Method
	 */
	protected void startQueryWithMap() { this.startQueryWithMap(0); }
	protected void startQueryWithMap(int typeId) {
		final int tempTypeId = typeId;
		loadingView = ProgressDialog.show(this, "", getResources().getString(R.string.loading_message), false);
		// A sputid way to solve the delay of map span
		TimerTask sendQuery = new TimerTask() {
			private int typeId = tempTypeId;
			@Override
			public void run () {
				int rangeStart = 0;
				int rangeEnd = 9;
				// Set Query Condition and Start Query
				qGAE.addQuery(GAEQueryCondtionType.GAEQueryByCoordinate, currentLocationPoint, mapMode.getLatitudeSpan(), mapMode.getLongitudeSpan());
				if (typeId!=0)
					qGAE.addQuery(GAEQueryCondtionType.GAEQueryByType, Integer.toString(typeId));
				caseSource = qGAE.doQuery(GAEQueryDatabase.GAEQueryDatabaseCzone, rangeStart, rangeEnd);
				int sourceLength = qGAE.getSourceTotalLength();
				qGAE.resetCondition();
				loadingView.cancel();
				if (caseSource==null) {
					currentRangeLabel.setText(getResources().getString(R.string.query_currentRangeLabel_emptyCase));
				} else {
					// Set Overlay
					ArrayList<ManagedOverlayItem> overlayList = new ArrayList<ManagedOverlayItem>();
					for (int i=0; i<caseSource.length; i++) {
						String typeName = QidToDescription.getDetailByQID(selfContext, Integer.parseInt(caseSource[i].getform("typeid")));
						String info = caseSource[i].getform("key")+","+Integer.toString(convertStatusStringToStatusCode(caseSource[i].getform("status")));
						ManagedOverlayItem item = new ManagedOverlayItem(caseSource[i].getGeoPoint(), typeName, info);
						overlayList.add(item);
					}
					try {
						managedOverlay.addAll(overlayList);
					} catch (Exception e) {
						e.printStackTrace();
					}
					// Set Label
					if (sourceLength==0) currentRangeLabel.setText(getResources().getString(R.string.query_currentRangeLabel_emptyCase));
					else currentRangeLabel.setText(Integer.toString(rangeStart+1)+"-"+Integer.toString(rangeEnd+1)+" 筆，共 "+Integer.toString(sourceLength)+" 筆");
				}
			}
		};
		Timer timer = new Timer();
		timer.schedule(sendQuery, 600);
	}
	/**
	 * @category Menu
	 */
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		menu.add(0, MENU_SetTypeCondition, 0, getResources().getString(R.string.menu_query_setTypeCondition)).setIcon(android.R.drawable.ic_menu_search);
		menu.add(0, MENU_AllTypeCondition, 0, getResources().getString(R.string.menu_query_setAllType)).setIcon(android.R.drawable.ic_menu_search);
		return super.onCreateOptionsMenu(menu);
	}
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		if (item.getItemId() == MENU_SetTypeCondition || item.getItemId() == MENU_AllTypeCondition)
			this.menuActionToTake(item);
		return super.onOptionsItemSelected(item);
	}
	@Override
	public void menuActionToTake(MenuItem item) {
		if (item.getItemId()==MENU_SetTypeCondition) {
			// Call Type Selector
			Intent intent = new Intent();
			intent.setClass(Query.this, TypeSelector.class);
			startActivityForResult(intent, REQUEST_CODE_typeSelector);
		} else if (item.getItemId()==MENU_AllTypeCondition) {
			this.startQueryWithMap();
			currentConditionLabel.setText(getResources().getString(R.string.query_currentConditionLabel_alltype));
			
		}
	}
}
