package tw.edu.ntu.csie.mgov.photo;
//package com.example;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

import tw.edu.ntu.csie.mgov.R;
import tw.edu.ntu.csie.mgov.mgov;
import tw.edu.ntu.csie.mgov.R.id;
import tw.edu.ntu.csie.mgov.R.layout;

import android.app.Activity;
import android.content.Intent;
import android.hardware.Camera;
import android.hardware.Camera.PictureCallback;
import android.hardware.Camera.ShutterCallback;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.FrameLayout;

public class CameraActivity extends Activity {
	private static final String TAG = "Camera";
	Camera camera;
	preview preview;
	Button buttonClick;
	double count = 1.0;
	String currentPic = null;
	
	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.camera);

		findview();
		setlistener();

	}

	void findview(){
		
		preview = new preview(this);
		((FrameLayout) findViewById(R.id.preview)).addView(preview);

		buttonClick = (Button) findViewById(R.id.buttonClick);
	}
	
	void setlistener(){
		
		buttonClick.setOnClickListener(new OnClickListener() {
			public void onClick(View v) {
				
				preview.mCamera.takePicture(shutterCallback, rawCallback,
						jpegCallback);
								
			}
		});
	}
	
	ShutterCallback shutterCallback = new ShutterCallback() {
		public void onShutter() {
			Log.d(TAG, "onShutter'd");
		}
	};

	/** Handles data for raw picture */
	PictureCallback rawCallback = new PictureCallback() {
		public void onPictureTaken(byte[] data, Camera camera) {
			Log.d(TAG, "onPictureTaken - raw");
		}
	};

	/** Handles data for jpeg picture */
	PictureCallback jpegCallback = new PictureCallback() {
		public void onPictureTaken(byte[] data, Camera camera) {
			FileOutputStream outStream = null;
			try {
//				 outStream = CameraActivity.this.openFileOutput(String.format("%d.jpg",System.currentTimeMillis()), 0);
				currentPic = String.format("/sdcard/%d.jpg", System.currentTimeMillis());
				outStream = new FileOutputStream(currentPic);
				outStream.write(data);
				outStream.close();
				Log.d(TAG, "onPictureTaken - wrote bytes: " + data.length);
				
				Intent intent = new Intent();
				intent.putExtra("tab", 2);
				intent.putExtra("currentPic", currentPic);
				intent.setClass(CameraActivity.this, mgov.class);
				startActivity(intent);
				
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			} finally {
			}
			Log.d(TAG, "onPictureTaken - jpeg");
		}
	};
}