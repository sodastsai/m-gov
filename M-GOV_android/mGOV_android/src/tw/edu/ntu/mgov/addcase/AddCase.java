/**
 * 
 */
package tw.edu.ntu.mgov.addcase;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.prefs.Preferences;

import com.google.android.maps.GeoPoint;
import com.google.android.maps.MapActivity;
import com.google.android.maps.MapView;

import tw.edu.ntu.mgov.R;
import tw.edu.ntu.mgov.typeselector.TypeSelector;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.location.Criteria;
import android.location.Location;
import android.location.LocationManager;
import android.net.Uri;
import android.os.Bundle;
import android.os.ParcelFileDescriptor;
import android.preference.Preference;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

/**
 * 
 * 
 * @author vagrants
 * 2010/10/5
 * @company NTU CSIE Mobile HCI Lab
 */
public class AddCase extends MapActivity {

	private static final String LOGTAG = "MGOV-AddCase";
	
	// request codes, used for startActivityForResult() and onActivityResult() 
	private static final int REQUEST_CODE_SELECT_TYPE = 376123;
	private static final int REQUEST_CODE_TAKE_PICTURE = 376124;
	private static final int REQUEST_CODE_SELECT_PICTURE = 376125;
	private static final int REQUEST_CODE_SELECT_LOCATION = 376126;
	
	// vars for Case Attributes
	private int typeId = -1;
	private GeoPoint locationGeoPoint;
	private Uri pictureUri;
	
	// Views 
	private ImageView pictureImageView;
	private MapView mapView;
	private Button typeButton;
	private EditText nameEditText;
	private EditText descriptionEditText;
	private Button resetButton;
	private Button submitButton;
	
	// shared preference to save some information 
	private static String SHARED_PREFERENCES_NAME = LOGTAG; 
	private SharedPreferences preferences;
	private static final String SP_HAVE_UNFINISHED_EDIT = "sp_have_unfinished_edit";
	private static final String SP_PICTURE_URI = "sp_picture_uri";
	private static final String SP_LOCATION_LONE6 = "sp_picture_lon_e6";
	private static final String SP_LOCATION_LATE6 = "sp_picture_lat_e6";
	private static final String SP_TYPE_ID = "sp_type_id";
	private static final String SP_TYPE_DETAIL = "sp_type_detail";
	private static final String SP_NAME = "sp_name";
	private static final String SP_DESCRIPTION = "sp_description";
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		preferences = getSharedPreferences(SHARED_PREFERENCES_NAME, MODE_PRIVATE);
		
		setTitle("報案");
		setContentView(R.layout.addcase);
		findAllViews();
		setAllOnClickListeners();
	}
	
	@Override
	protected void onStop() {
		saveContentToPreferences();
		super.onStop();
	}
	
	
	@Override
	protected void onStart() {
		super.onStart();
		
		locationGeoPoint = getDefaultGeoPoint();
		mapView.getController().animateTo(locationGeoPoint);
		
		showContentByPreferences();
	}
	
	/**
	 * save the contents which user have edited. 
	 */
	void saveContentToPreferences() {
		SharedPreferences.Editor editor = preferences.edit();
		
		editor.putBoolean(SP_HAVE_UNFINISHED_EDIT, true);
		if (pictureUri != null) {
			editor.putString(SP_PICTURE_URI, pictureUri.toString());
		}
		editor.putInt(SP_TYPE_ID, typeId);
		editor.putString(SP_TYPE_DETAIL, typeButton.getText().toString());
		editor.putString(SP_NAME, nameEditText.getText().toString());
		editor.putString(SP_DESCRIPTION, descriptionEditText.getText().toString());
		
		editor.commit();
	}
	
	/**
	 * re-display the contents which is save in last onStop() in saveContentToPreferences() 
	 * ** note that picture may not be handle here for that onActivityResult() is called before
	 *    onStart(), but picture is set in onActivityResult(). 
	 */
	void showContentByPreferences() {
		
		if (!preferences.getBoolean(SP_HAVE_UNFINISHED_EDIT, false)) {
			return; 	// no contents was saved in last time, return. 
		}
		
		// reset the content in pictureImageView
		// ** note that picture may not be handle here for that onActivityResult() is called before
		//    onStart(), but picture is set in onActivityResult().
		// 
		if (pictureUri == null && preferences.contains(SP_PICTURE_URI) ) {
			String uriStr = preferences.getString(SP_PICTURE_URI, null);
			if (uriStr != null) {
				pictureUri = Uri.parse(preferences.getString(SP_PICTURE_URI, null));
				try {
					InputStream is = getContentResolver().openInputStream(pictureUri);
					Bitmap bmp = BitmapFactory.decodeStream(is);
					pictureImageView.setImageBitmap(bmp);
					
					// hide the text of "add picture" 
					TextView tv = (TextView) findViewById(R.id.AddCase_TextView_AddPhoto);
					tv.setVisibility(View.GONE);
				} catch (FileNotFoundException e) {
					Log.d(LOGTAG, "Fail to open inputStream for imageFile Uri : " + pictureUri, e);
				}
			}
		}
		
		// MapView
		
		
		// typeSelectBtn
		if (preferences.contains(SP_TYPE_ID)) {
			typeId = preferences.getInt(SP_TYPE_ID, -1);
			typeButton.setText(preferences.getString(SP_TYPE_DETAIL, ""));
		}
		
		// nameEditText
		if (preferences.contains(SP_NAME)) {
			nameEditText.setText(preferences.getString(SP_NAME, ""));
		}
		
		// descriptionEditText 
		if (preferences.contains(SP_DESCRIPTION)) {
			descriptionEditText.setText(preferences.getString(SP_DESCRIPTION, ""));
		}
	}

	private void findAllViews() {
		pictureImageView = (ImageView) findViewById(R.id.AddCase_ImageView_Picture);
		mapView = (MapView) findViewById(R.id.AddCase_Map);
		typeButton = (Button) findViewById(R.id.AddCase_Btn_SelectType);
		nameEditText = (EditText) findViewById(R.id.AddCase_EditText_Name);
		descriptionEditText = (EditText) findViewById(R.id.AddCase_EditText_Detail);
		resetButton = (Button) findViewById(R.id.AddCase_Btn_Reset);
		submitButton = (Button) findViewById(R.id.AddCase_Btn_Submit);
	}
	
	private void setAllOnClickListeners() {
		
		final Context mContext = this;	// used for new intent 
		
		// set SelectPicture ImageView
		pictureImageView.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				requestForPicture();
			}
		});
		
		// set SelectLicationMapView
		// ** setOnClickListener is not work for MapView, thus using onTouchListener 
		mapView.setOnTouchListener(new View.OnTouchListener() {
			@Override
			public boolean onTouch(View v, MotionEvent event) {
				switch(event.getAction()) {
				case MotionEvent.ACTION_UP:
					if (v.equals(mapView)) {
						Intent intent = new Intent(mContext, SelectLocationMap.class);
						startActivity(intent);
					}
				}
				return true;
			}
		});
		
		// set TypeSelector Button
		typeButton.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				Intent intent = new Intent(mContext, TypeSelector.class);
				startActivityForResult(intent, REQUEST_CODE_SELECT_TYPE);
			}
		});
		
		// set Reset Button
		resetButton.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				requestResetContent();
			}
		});
	}
	
	/**
	 * This method is used for Picture ImageView is Clicked. 
	 * When this method is called, a dialog will be show to ask user to
	 * choose "take picture" or "select picture from storage".
	 * Each choice has the corresponding Intent, which will be thrown as 
	 * the choice is clicked.
	 */
	private void requestForPicture() {
		// build the dialog
		AlertDialog.Builder builder = new AlertDialog.Builder(this);
		
		builder.setCancelable(true);
		builder.setTitle("請選擇照片來源");
		builder.setItems(new String[] {"拍攝新照片", "選擇現有照片"} , new DialogInterface.OnClickListener() {
			@Override
			public void onClick(DialogInterface dialog, int which) {
				if (which == 0) {
					// Intent to take new picture
					Intent intent = new Intent(android.provider.MediaStore.ACTION_IMAGE_CAPTURE);
					startActivityForResult(intent, REQUEST_CODE_TAKE_PICTURE);
				} else {
					// Intent to select picture from device
					Intent intent = new Intent(Intent.ACTION_GET_CONTENT);
					intent.setType("image/*");
					startActivityForResult(intent, REQUEST_CODE_SELECT_PICTURE);
				}
			}
		});
		builder.create().show();
	}

	/**
	 * resetBtn is clicked.
	 * Show a AlertDialog to ensure that user do want to reset the current content.
	 */
	private void requestResetContent() {
		AlertDialog.Builder builder = new AlertDialog.Builder(this);
		builder.setTitle("確定要重設所有欄位？")
			.setMessage("此動作會清除所有欄位的資料。")
			.setPositiveButton("確定", new DialogInterface.OnClickListener() {
				@Override
				public void onClick(DialogInterface dialog, int which) {
					resetContent();
				}
			})
			.setNegativeButton("取消", null)
			.create().show();
	}
	
	private GeoPoint getDefaultGeoPoint() {
		
		LocationManager lm = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
		Criteria mCriteria = new Criteria();
		mCriteria.setAccuracy(Criteria.ACCURACY_COARSE);
		mCriteria.setAltitudeRequired(false);
		mCriteria.setBearingRequired(false);
		mCriteria.setCostAllowed(true);
		mCriteria.setPowerRequirement(Criteria.POWER_LOW);
		String strLocationProvider = lm.getBestProvider(mCriteria, true);
		Location retLocation = lm.getLastKnownLocation(strLocationProvider);
		GeoPoint gpoint = new GeoPoint((int) (retLocation.getLatitude() * 1e6),(int) (retLocation.getLongitude() * 1e6));
		
		return gpoint;
	}
	
	/**
	 * Do reset the content.
	 */
	private void resetContent() {
		
		// handle sharedPreference
		SharedPreferences.Editor editor = preferences.edit();
		editor.clear();
		editor.putBoolean(SP_HAVE_UNFINISHED_EDIT, false);
		editor.commit();
		
		// 
		pictureImageView.setImageDrawable(null);
		pictureUri = null;
		
		typeButton.setText("");
		typeId = -1;
		nameEditText.setText("");
		descriptionEditText.setText("");
		
		// hide the text of "add picture" 
		TextView tv = (TextView) findViewById(R.id.AddCase_TextView_AddPhoto);
		tv.setVisibility(View.VISIBLE);
	}
	
	/**
	 * When user select a picture, the picture could be deleted before posting this case.<br>
	 * Thus, making a copy in m-GOV's private cache just as user selects picture.<br>
	 * Calling this method will copies the image in originalUri and store it as "addcase_picture.jpg"
	 * in cache. Returns the Uri representing the copy.
	 * 
	 * @param originalUri Uri of original picture 
	 * @return the bitmap of duplicated file
	 * @throws IOException 
	 * @throws URISyntaxException 
	 */
	private Bitmap makeDuplicatePicture(Uri originalUri) throws IOException, URISyntaxException {
		
		File cacheDir = getCacheDir();	// get cache dir
		File picture = new File(cacheDir.getAbsolutePath() + File.separator + "addcase_picture.jpg"); 	// new file 
		
		// check if the new-taking Image is too large 
		ParcelFileDescriptor pdf = getContentResolver().openFileDescriptor(originalUri, "r");
		if (pdf != null) {
			Log.d(LOGTAG, "  originalUri file size = " + (pdf.getStatSize() / 1024)  + " KBs");
		}
		
		BitmapFactory.Options options = new BitmapFactory.Options();
		if (pdf.getStatSize() < 500*1024) {
			// do nothing change with options
		} else if (pdf.getStatSize() < 1*1024*1024) {
			options.inSampleSize = 2;
		} else if (pdf.getStatSize() < 4*1024*1024) {
			options.inSampleSize = 4;
		} else if (pdf.getStatSize() < 16*1024*1024) {
			options.inSampleSize = 8;
		} else {
			options.inSampleSize = 16;	// not a good solution, to be fixed!!
		}
		
		
		InputStream is = this.getContentResolver().openInputStream(originalUri);
		Bitmap bmp = BitmapFactory.decodeStream(is, null, options);

		if (picture.exists()) {	// delete old file in cache
			picture.delete();
		}
		
		// open file streams 
		FileOutputStream fos = new FileOutputStream(picture);
		
		// compress bmp into file 
		bmp.compress(Bitmap.CompressFormat.JPEG, 85, fos);
		
		// close 
		is.close();
		fos.close();
		
		// save the Uri of new file & display some information 
		pictureUri = Uri.fromFile(picture);
		Log.d(LOGTAG, "  new saved picture file size = " + (this.getContentResolver().openFileDescriptor(pictureUri, "r").getStatSize() / 1024) + "KBs" );
		
		return bmp;
	}
	
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		
		switch(requestCode) {
		
		case REQUEST_CODE_SELECT_TYPE:
			if (resultCode == Activity.RESULT_OK) {
				Bundle bundle = data.getExtras();
				
				// save the result onto sharePreferences, to be display in onStart() 
				SharedPreferences.Editor editor = preferences.edit();
				editor.putInt(SP_TYPE_ID, bundle.getInt("qid"));
				editor.putString(SP_TYPE_DETAIL, bundle.getString("detail"));
				editor.commit();
			}
			break;
			
		case REQUEST_CODE_TAKE_PICTURE:
			if (resultCode == Activity.RESULT_OK) {
				Log.d(LOGTAG, "Take Picture");
				Log.d(LOGTAG, "\t data.toURI() = " + data.toURI());
				Log.d(LOGTAG, "\t data.getData() = " + data.getData());
				
				System.gc();	// run gc for sure that there's enough memory to open the picture 
				ImageView iv = (ImageView) findViewById(R.id.AddCase_ImageView_Picture);
				try {
					iv.setImageBitmap(makeDuplicatePicture(data.getData()));
				} catch (IOException e) {
					Log.e(LOGTAG, "iv.setImageBitmap(makeDuplicatePicture(data.getData())); fail!!!", e);
					break;
				} catch (URISyntaxException e) {
					Log.e(LOGTAG, "iv.setImageBitmap(makeDuplicatePicture(data.getData())); fail!!!", e);
					break;
				}
				
				// hide the text of "add picture" 
				TextView tv = (TextView) findViewById(R.id.AddCase_TextView_AddPhoto);
				tv.setVisibility(View.GONE);
			}
			break;
			
		case REQUEST_CODE_SELECT_PICTURE:
			if (resultCode == Activity.RESULT_OK){
				Log.d(LOGTAG, "Select Picture");
				Log.d(LOGTAG, "\t data.toURI() = " + data.toURI());
				Log.d(LOGTAG, "\t data.getData() = " + data.getData());
				
				System.gc();	// run gc for sure that there's enough memory to open the picture 
				ImageView iv = (ImageView) findViewById(R.id.AddCase_ImageView_Picture);
				try {
					iv.setImageBitmap(makeDuplicatePicture(data.getData()));
				} catch (IOException e) {
					Log.e(LOGTAG, "iv.setImageBitmap(makeDuplicatePicture(data.getData())); fail!!!", e);
					break;
				} catch (URISyntaxException e) {
					Log.e(LOGTAG, "iv.setImageBitmap(makeDuplicatePicture(data.getData())); fail!!!", e);
					break;
				}
				
				// hide the text of "add picture" 
				TextView tv = (TextView) findViewById(R.id.AddCase_TextView_AddPhoto);
				tv.setVisibility(View.GONE);
			}
			break;
			
		default:
			super.onActivityResult(requestCode, resultCode, data);
		}
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
