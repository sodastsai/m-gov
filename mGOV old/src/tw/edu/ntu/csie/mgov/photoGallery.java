package tw.edu.ntu.csie.mgov;


import java.io.File;
import java.io.FilenameFilter;
import java.util.ArrayList;
import java.util.List;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.res.TypedArray;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.Gallery;
import android.widget.ImageView;
import android.widget.AdapterView.OnItemClickListener;

public class photoGallery extends Activity {

    private Gallery gallery;
    private ImageView imgView;
    private String[] children;
    Bitmap myBitmap;
    List<Bitmap> myBitmapArray = new ArrayList<Bitmap>();
    Button ok, cancel;
    int currentPic = 0;
    FilenameFilter filter;
    File file;
    
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.photo);

		findview();
		setlistener();
		
		children = file.list(filter);
		for (int i = 0; i < children.length; i++)
			myBitmapArray.add(BitmapFactory
					.decodeFile("/sdcard/" + children[i]));

		imgView.setImageBitmap(myBitmapArray.get(0));
		gallery.setAdapter(new AddImgAdp(this));

	}
	
	void findview(){
		
		imgView = (ImageView) findViewById(R.id.ImageView01);
		gallery = (Gallery) findViewById(R.id.photoGallery);
		ok = (Button)findViewById(R.id.ok);
		cancel = (Button)findViewById(R.id.cancel);
		file = new File(getResources().getString(R.string.sdcard));
		
		filter = new FilenameFilter() {
			public boolean accept(File dir, String name) {
				return name.endsWith(".jpg");
			}
		};
		
	}
    
	void setlistener() {

		ok.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {

				Intent intent = new Intent();
				intent
						.putExtra("currentPic", "/sdcard/"
								+ children[currentPic]);
				intent.setClass(photoGallery.this, mgov.class);
				startActivity(intent);
			}
		});
		cancel.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				Intent intent = new Intent();
				intent.setClass(photoGallery.this, mgov.class);
				startActivity(intent);
			}
		});

		gallery.setOnItemClickListener(new OnItemClickListener() {
			public void onItemClick(AdapterView parent, View v, int position,
					long id) {
				imgView.setImageBitmap(myBitmapArray.get(position));
				currentPic = position;
			}
		});
	}
	
	public class AddImgAdp extends BaseAdapter {
        int GalItemBg;
        private Context cont;

        public AddImgAdp(Context c) {
            cont = c;
            TypedArray typArray = obtainStyledAttributes(R.styleable.GalleryTheme);
            GalItemBg = typArray.getResourceId(R.styleable.GalleryTheme_android_galleryItemBackground, 0);
            typArray.recycle();
        }

        public int getCount() {
            return myBitmapArray.size();
        }

        public Object getItem(int position) {
            return position;
        }

        public long getItemId(int position) {
            return position;
        }

        public View getView(int position, View convertView, ViewGroup parent) {
            ImageView imgView = new ImageView(cont);

            imgView.setImageBitmap(myBitmapArray.get(position));
            imgView.setLayoutParams(new Gallery.LayoutParams(230, 200));
            imgView.setScaleType(ImageView.ScaleType.FIT_XY);
            imgView.setBackgroundResource(GalItemBg);

            return imgView;
        }
    }

}
