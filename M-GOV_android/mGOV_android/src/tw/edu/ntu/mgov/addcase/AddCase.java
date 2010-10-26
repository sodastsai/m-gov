/**
 * 
 */
package tw.edu.ntu.mgov.addcase;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URISyntaxException;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.Locale;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.google.android.maps.GeoPoint;
import com.google.android.maps.ItemizedOverlay;
import com.google.android.maps.MapActivity;
import com.google.android.maps.MapView;
import com.google.android.maps.OverlayItem;

import tw.edu.ntu.mgov.R;
import tw.edu.ntu.mgov.gae.GAECase;
import tw.edu.ntu.mgov.gae.GAESubmit;
import tw.edu.ntu.mgov.option.Option;
import tw.edu.ntu.mgov.typeselector.TypeSelector;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.ContentResolver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.SumPathEffect;
import android.graphics.drawable.Drawable;
import android.location.Address;
import android.location.Criteria;
import android.location.Geocoder;
import android.location.Location;
import android.location.LocationManager;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.os.ParcelFileDescriptor;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

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
	private String address;
	private Uri pictureUri;
	
	// Views 
	private ImageView pictureImageView;
	private MapView mapView;
	private MyOverlay mapOverlay;
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
	private static final String SP_LOCATION_ADDRESS = "sp_location_address";
	private static final String SP_TYPE_ID = "sp_type_id";
	private static final String SP_TYPE_DETAIL = "sp_type_detail";
	private static final String SP_NAME = "sp_name";
	private static final String SP_DESCRIPTION = "sp_description";
	private static final String SP_MAPZOOM = "sp_mapzoom";
	
	// sharedPreference of user info
	private SharedPreferences userPreferences;
	
	// others 
	private int preferedMapViewZoom = 16;
	private Uri imageUri;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		preferences = getSharedPreferences(SHARED_PREFERENCES_NAME, MODE_PRIVATE);
		userPreferences = getSharedPreferences(Option.PREFERENCE_NAME, MODE_PRIVATE);
		
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
		editor.putInt(SP_LOCATION_LONE6, locationGeoPoint.getLongitudeE6());
		editor.putInt(SP_LOCATION_LATE6, locationGeoPoint.getLatitudeE6());
		editor.putString(SP_LOCATION_ADDRESS, address);
		editor.putInt(SP_TYPE_ID, typeId);
		editor.putString(SP_TYPE_DETAIL, typeButton.getText().toString());
		editor.putString(SP_NAME, nameEditText.getText().toString());
		editor.putString(SP_DESCRIPTION, descriptionEditText.getText().toString());
		editor.putInt(SP_MAPZOOM, preferedMapViewZoom);
		
		editor.commit();
	}
	
	/**
	 * re-display the contents which is save in last onStop() in saveContentToPreferences() 
	 * ** note that picture may not be handle here for that onActivityResult() is called before
	 *    onStart(), but picture is set in onActivityResult(). 
	 */
	private void showContentByPreferences() {
		
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
					pictureImageView.setImageDrawable(null);
					pictureUri = null;
					
					// the text of "add picture" 
					TextView tv = (TextView) findViewById(R.id.AddCase_TextView_AddPhoto);
					tv.setVisibility(View.VISIBLE);
				}
			}
		}
		
		// MapView & address 
		if (preferences.contains(SP_LOCATION_LONE6) && preferences.contains(SP_LOCATION_LATE6)) {
			int latitudeE6  = preferences.getInt(SP_LOCATION_LATE6, -1);
			int longitudeE6 = preferences.getInt(SP_LOCATION_LONE6, -1);
			if (latitudeE6 != -1 && longitudeE6 != -1) {
				locationGeoPoint = new GeoPoint(latitudeE6, longitudeE6);
			} else {
				locationGeoPoint = getDefaultGeoPoint();
			}
			
			address = preferences.getString(SP_LOCATION_ADDRESS, "");
		} else {
			locationGeoPoint = getDefaultGeoPoint();
		}
		if (address == null || address.equals("")) {
			address = getAddress(locationGeoPoint);
		}
		if (mapOverlay.size() > 0) {
			mapOverlay.clearAllOverlayItem();
		}
		mapOverlay.addOverlayItem(new OverlayItem(locationGeoPoint, "", ""));
		mapView.getController().setZoom(preferences.getInt(SP_MAPZOOM, 16));
		mapView.getController().animateTo(locationGeoPoint);
		
		// typeSelectBtn
		if (preferences.contains(SP_TYPE_ID)) {
			typeId = preferences.getInt(SP_TYPE_ID, -1);
			typeButton.setText(preferences.getString(SP_TYPE_DETAIL, ""));
		} else {
			typeButton.setText("");
			typeId = -1;
		}
		
		// nameEditText
		if (preferences.contains(SP_NAME)) {
			nameEditText.setText(preferences.getString(SP_NAME, ""));
		} else {
			nameEditText.setText(userPreferences.getString(Option.KEY_USER_NAME, ""));
		}
		
		// descriptionEditText 
		if (preferences.contains(SP_DESCRIPTION)) {
			descriptionEditText.setText(preferences.getString(SP_DESCRIPTION, ""));
		} else {
			descriptionEditText.setText("");
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
		// set up overlay 
		mapOverlay = new MyOverlay(this.getResources().getDrawable(R.drawable.mapoverlay_greenpin));
		mapView.getOverlays().add(mapOverlay);
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
						Bundle bundle = new Bundle();	// bundle for bring the information of current locationGeoPoint
						bundle.putInt(SelectLocationMap.BUNDLE_LATE6, locationGeoPoint.getLatitudeE6());
						bundle.putInt(SelectLocationMap.BUNDLE_LONE6, locationGeoPoint.getLongitudeE6());
						
						Intent intent = new Intent(mContext, SelectLocationMap.class);
						intent.putExtras(bundle);
						startActivityForResult(intent, REQUEST_CODE_SELECT_LOCATION);
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
		
		// set Submit Button
		submitButton.setOnClickListener(new View.OnClickListener() {			
			@Override
			public void onClick(View v) {
				doSubmit();
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
	File tmpPhoto;
	
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
					tmpPhoto = new File(Environment.getExternalStorageDirectory(),  "pictemp937942.jpg");
				    intent.putExtra(android.provider.MediaStore.EXTRA_OUTPUT, Uri.fromFile(tmpPhoto));
				    imageUri = Uri.fromFile(tmpPhoto);
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
		
		// do showContentByPreferences() with no data in sharedPreference
		showContentByPreferences();
		
		// photoImageView should be deal with specially  
		pictureImageView.setImageDrawable(null);
		pictureUri = null;
		
		// the text of "add picture" 
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
	
	
	private String getAddress (GeoPoint geoPoint) {
		
		double latitude = ((double)geoPoint.getLatitudeE6() /1e6) ;
		double longitude = ((double)geoPoint.getLongitudeE6() /1e6) ;
		
		Address a = null;
		
		try {
			a = new Geocoder(this, Locale.getDefault()).getFromLocation(latitude, longitude, 1).get(0);
		} catch (IOException e) {
			Log.e(LOGTAG, "fail to get form location ", e);
			return "";
		}
		
		return a.getAddressLine(0);
	}
	
	private class AddressSet {
		String fullAddress;
		String hAdmitName;
		String hAdmivName;
	}
	
	
	private AddressSet getAddressSet(GeoPoint geoPoint) {
	
		double latDouble = ((double)geoPoint.getLatitudeE6() / 1e6);
		double lonDouble = ((double)geoPoint.getLongitudeE6() / 1e6);
		
		String requestURL = "http://maps.google.com/maps/api/geocode/json?latlng=" + latDouble + "," + lonDouble + "&sensor=true&language=zh-TW";
		String returnValue = "";
		JSONObject jObject = null;
		
		try {
			URLConnection urlc = (new URL(requestURL)).openConnection();
			BufferedReader br = new BufferedReader(new InputStreamReader(urlc.getInputStream(), "utf8"));
			String tmp;
			while((tmp = br.readLine()) != null ) {
				returnValue = returnValue.concat(tmp);
			}
			jObject = new JSONObject(returnValue);

			if (jObject == null || !jObject.has("status") || !jObject.getString("status").equals("OK")) {
				return null;
			}
			
			JSONArray results = jObject.getJSONArray("results");
			JSONObject address = results.getJSONObject(0);
			
			AddressSet aSet = new AddressSet();
			aSet.fullAddress = address.getString("formatted_address");
			
			JSONArray address_components = address.getJSONArray("address_components");
			for (int i = 0 ; i < address_components.length(); i++) {
				JSONObject tmpObject = address_components.getJSONObject(i);
				JSONArray types = tmpObject.getJSONArray("types");
				
				if (types.length() == 2) {
					if (types.getString(0).equals("sublocality") && types.getString(1).equals("political")) {
						aSet.hAdmivName = tmpObject.getString("long_name");
					} else if (types.getString(0).equals("locality") && types.getString(1).equals("political")) {
						aSet.hAdmitName = tmpObject.getString("long_name");
					}
				}
			}
			
			return aSet;
			
		} catch (Exception e) {
			Log.d(LOGTAG, "Fail to get more infomation from GeoPoint : " + geoPoint.toString(), e);
			return null;
		}
		
	}
	
	private boolean submitFlag = false;
	
	private void doSubmit() {
		
		submitFlag = true;
		
		if (!checkNetworkStatus(this)) {
			showNoNetworkAlertDialog(this);
			return;
		}
		
		if (!checkType()) {
			return;
		}
		
		if (!checkEmail()) {
			return;
		}	
		
		// get Address 
		AddressSet addressSet;
		
		addressSet = getAddressSet(locationGeoPoint);

		// create GAECase and add the attributes to submit 
		
		final GAECase newcase = new GAECase();
		
		newcase.addform("address", addressSet.fullAddress);
		newcase.addform("h_admiv_name", addressSet.hAdmivName);
		newcase.addform("h_admit_name", addressSet.hAdmitName);
		
		
		if (pictureUri != null) {
			newcase.addImage(pictureUri.toString());
		}
		newcase.addform("email", userPreferences.getString(Option.KEY_USER_EMAIL, "a@a.a"));
		newcase.addform("name", nameEditText.getText().toString());
		newcase.addform("typeid", ""+typeId);
		newcase.addform("coordx", "" + ( ((double)locationGeoPoint.getLongitudeE6()) /1e6));
		newcase.addform("coordy", "" + ( ((double)locationGeoPoint.getLatitudeE6()) /1e6));
		newcase.addform("h_summary", descriptionEditText.getText().toString() );
		
		AlertDialog.Builder builder = new AlertDialog.Builder(this);
		builder.setTitle("即將送出案件")
			.setMessage("您確定要送出此案件到1999嗎？")
			.setPositiveButton("確定", new DialogInterface.OnClickListener() {
				@Override
				public void onClick(DialogInterface dialog, int which) {
					new GAESubmit(newcase, AddCase.this).doSubmit();
					Toast.makeText(AddCase.this, "案件已送出。", Toast.LENGTH_LONG).show();
					resetContent();
					finish();					
				}
			})
			.setNegativeButton("取消", new DialogInterface.OnClickListener() {
				@Override
				public void onClick(DialogInterface dialog, int which) {
					dialog.dismiss();
				}
			})
			.create().show();
	}
	
	
	void showNoNetworkAlertDialog(Context context) {

		AlertDialog.Builder builder = new AlertDialog.Builder(context);
		builder.setTitle("沒有網路連線")
				.setMessage("此功能需要雲端服務，請開啟網路服務以使用此功能。")
				.setCancelable(false)
				.setPositiveButton("設定網路",
						new DialogInterface.OnClickListener() {
							public void onClick(DialogInterface dialog, int id) {
								Intent intent = new Intent(android.provider.Settings.ACTION_WIRELESS_SETTINGS);
								startActivity(intent);
							}
						})
				.setNegativeButton("取消", new DialogInterface.OnClickListener() {
					@Override
					public void onClick(DialogInterface dialog, int which) {
						dialog.cancel();
					}
				}).create().show();

	}
	

	private boolean checkNetworkStatus(Context context) {
		ConnectivityManager manager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
		NetworkInfo networkInfo = manager.getActiveNetworkInfo();
		if (networkInfo == null || !networkInfo.isAvailable()) {
			return false;
		}
		return true;
	}
	
	private boolean checkEmail() {
		
		String email = userPreferences.getString(Option.KEY_USER_EMAIL, "");
		
		if (!checkEmailFormat(email)) {
			
			final EditText et = new EditText(this);
			et.setHint("請在此輸入您的 E-mail");
			et.setInputType(android.view.inputmethod.EditorInfo.TYPE_TEXT_VARIATION_EMAIL_ADDRESS);
			et.setText(email);
			
			final AlertDialog.Builder builder = new AlertDialog.Builder(this);
			builder.setTitle("請設定您的 E-mail")
				.setMessage(getResources().getString(R.string.app_name) + "會使用您的 E-mail 來辨認您的案件。")
				.setView(et)
				.setPositiveButton("確定", new DialogInterface.OnClickListener() {
					@Override
					public void onClick(DialogInterface dialog, int which) {
						String editEmail = et.getText().toString();
						if (checkEmailFormat(editEmail)) {
							userPreferences.edit().putString(Option.KEY_USER_EMAIL, editEmail).commit();
						} else {
							Toast.makeText(AddCase.this, "E-mail 格式錯誤\n請輸入正確的 E-mail 。", Toast.LENGTH_LONG).show();
							doSubmit();
						}
					}
				})
				.setNegativeButton("取消", new DialogInterface.OnClickListener() {
					@Override
					public void onClick(DialogInterface dialog, int which) {
						submitFlag = false;
						Toast.makeText(AddCase.this, "案件沒有送出 :(", Toast.LENGTH_SHORT);
					}
				})
				.create()
				.show();
			return false;
		} else {
			return true;
		}
	}
	
	static public boolean checkEmailFormat(String emailAddress) {
		
		if (emailAddress == null) {
			return false;
		}
		
		return emailAddress.matches("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z0-9.-]+");
	}
	
	private boolean checkType() {
		
		if (typeId < 0) {
			AlertDialog.Builder builder = new AlertDialog.Builder(this);
			builder.setTitle("尚未選擇案件種類")
				.setMessage("案件種類為必填項目，麻煩請選擇案件種類。")
				.setPositiveButton("好", new DialogInterface.OnClickListener() {
					@Override
					public void onClick(DialogInterface dialog, int which) {
						Intent intent = new Intent(AddCase.this, TypeSelector.class);
						startActivityForResult(intent, REQUEST_CODE_SELECT_TYPE);
					}
				})
				.create()
				.show();
			
			return false;
			
		} else {
			return true;
		}
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
				typeId = preferences.getInt(SP_TYPE_ID, -1);
				
				if (submitFlag) {
					doSubmit();
				}
			} else if (resultCode == Activity.RESULT_CANCELED) {
				submitFlag = false;
			}
			break;
			
		case REQUEST_CODE_TAKE_PICTURE:
			if (resultCode == Activity.RESULT_OK) {

				Uri selectedImage = imageUri;
	            getContentResolver().notifyChange(selectedImage, null);
	            

				System.gc();	// run gc for sure that there's enough memory to open the picture
	            
	            try {
	            	if (tmpPhoto.length() > 0l) {
	            		pictureImageView.setImageBitmap(makeDuplicatePicture(imageUri));
	            		tmpPhoto.delete();
		            } else {
		            	pictureImageView.setImageBitmap(makeDuplicatePicture(data.getData()));
		            }
	            } catch (Exception e) {
	                Toast.makeText(this, "Failed to load", Toast.LENGTH_SHORT).show();
	                Log.e("Camera", e.toString());
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
			
		case REQUEST_CODE_SELECT_LOCATION:
			if (resultCode == Activity.RESULT_OK) {
				Bundle bundle = data.getExtras();
				int latitudeE6  = bundle.getInt(SelectLocationMap.BUNDLE_LATE6, -1);
				int longitudeE6 = bundle.getInt(SelectLocationMap.BUNDLE_LONE6, -1);
				
				if (latitudeE6 != -1 && longitudeE6 != -1) {

					// save the result onto sharePreferences, to be display in onStart() 
					SharedPreferences.Editor editor = preferences.edit();
					editor.putInt(SP_LOCATION_LATE6, latitudeE6);
					editor.putInt(SP_LOCATION_LONE6, longitudeE6);
					editor.putString(SP_LOCATION_ADDRESS, bundle.getString(SelectLocationMap.BUNDLE_ADDRESS));
					editor.putInt(SP_MAPZOOM, bundle.getInt("zoomLevel", preferedMapViewZoom));
					editor.commit();
				}
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
	
	private class MyOverlay extends ItemizedOverlay<OverlayItem> {

		private ArrayList<OverlayItem> items = new ArrayList<OverlayItem>();
		private Drawable defaultMarker;
		
		/**
		 * @param defaultMarker
		 */
		public MyOverlay(Drawable defaultMarker) {
			super(defaultMarker);
			this.defaultMarker = defaultMarker;
		}
		
		protected void clearAllOverlayItem() {
			items.clear();
		}

		protected void addOverlayItem(OverlayItem oItem) {
			items.add(oItem);
			populate();
		}
		
		@Override
		public void draw(Canvas canvas, MapView mapView, boolean shadow) {
			// TODO Auto-generated method stub
			super.draw(canvas, mapView, false);
			boundCenterBottom(defaultMarker);
		}
		
		/* (non-Javadoc)
		 * @see com.google.android.maps.ItemizedOverlay#createItem(int)
		 */
		@Override
		protected OverlayItem createItem(int i) {
			// TODO Auto-generated method stub
			return items.get(i);
		}

		/* (non-Javadoc)
		 * @see com.google.android.maps.ItemizedOverlay#size()
		 */
		@Override
		public int size() {
			// TODO Auto-generated method stub
			return items.size();
		}
	}
}
