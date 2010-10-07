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

import tw.edu.ntu.mgov.R;
import tw.edu.ntu.mgov.typeselector.TypeSelector;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.os.ParcelFileDescriptor;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

/**
 * 
 * 
 * @author vagrants
 * 2010/10/5
 * @company NTU CSIE Mobile HCI Lab
 */
public class AddCase extends Activity {

	private static final String LOGTAG = "MGOV-AddCase";
	
	// request codes, used for startActivityForResult() and onActivityResult() 
	private static final int REQUEST_CODE_SELECT_TYPE = 376123;
	private static final int REQUEST_CODE_TAKE_PICTURE = 376124;
	private static final int REQUEST_CODE_SELECT_PICTURE = 376125;
	
	// vars for Case Attributes
	private int typeId = -1;
	private Uri pictureUri;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		setTitle("報案");
		setContentView(R.layout.addcase);
		setAllOnClickListeners();
	}
	
	private void setAllOnClickListeners() {
		
		ImageView iv;
		Button btn;
		final Context mContext = this;	// used for new intent 
		
		// set SelectPicture ImageView
		iv = (ImageView) findViewById(R.id.AddCase_ImageView_Picture);
		iv.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				requestForPicture();
			}
		});
		
		// set TypeSelector Button
		btn = (Button) findViewById(R.id.AddCase_Btn_SelectType);
		btn.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				Intent intent = new Intent(mContext, TypeSelector.class);
				startActivityForResult(intent, REQUEST_CODE_SELECT_TYPE);
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
		
		// display some information 
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
				typeId = bundle.getInt("qid");
				
				// display details on TypeSelectBtn
				Button btn = (Button) findViewById(R.id.AddCase_Btn_SelectType);
				btn.setText(bundle.getString("detail"));
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
}
