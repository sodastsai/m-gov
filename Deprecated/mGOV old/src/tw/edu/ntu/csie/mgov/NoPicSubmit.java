package tw.edu.ntu.csie.mgov;

import android.app.Activity;
import android.graphics.Color;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;

public class NoPicSubmit extends Activity {

	TextView sec1_title, sec1_1, sec1_2, sec1_3;
	TextView sec2_title, sec2_1, sec2_2;
	TextView sec3_title, sec3_1, sec3_2, sec3_3;
	TextView sec4_title, sec4_1, sec4_2;
	TextView sec5_title, sec5_1, sec5_2, sec5_3;
	TextView sec6_title, sec6_1, sec6_2, sec6_3;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.nopicsubmit);

		sec1_title = (TextView) findViewById(R.id.sec1_title);
		sec1_1 = (TextView) findViewById(R.id.sec1_1);
		sec1_2 = (TextView) findViewById(R.id.sec1_2);
		sec1_3 = (TextView) findViewById(R.id.sec1_3);

		sec2_title = (TextView) findViewById(R.id.sec2_title);
		sec2_1 = (TextView) findViewById(R.id.sec2_1);
		sec2_2 = (TextView) findViewById(R.id.sec2_2);

		sec3_title = (TextView) findViewById(R.id.sec3_title);
		sec3_1 = (TextView) findViewById(R.id.sec3_1);
		sec3_2 = (TextView) findViewById(R.id.sec3_2);
		sec3_3 = (TextView) findViewById(R.id.sec3_3);

		sec4_title = (TextView) findViewById(R.id.sec4_title);
		sec4_1 = (TextView) findViewById(R.id.sec4_1);
		sec4_2 = (TextView) findViewById(R.id.sec4_2);

		sec5_title = (TextView) findViewById(R.id.sec5_title);
		sec5_1 = (TextView) findViewById(R.id.sec5_1);
		sec5_2 = (TextView) findViewById(R.id.sec5_2);
		sec5_3 = (TextView) findViewById(R.id.sec5_3);

		sec6_title = (TextView) findViewById(R.id.sec6_title);
		sec6_1 = (TextView) findViewById(R.id.sec6_1);
		sec6_2 = (TextView) findViewById(R.id.sec6_2);
		sec6_3 = (TextView) findViewById(R.id.sec6_3);

		sec1_title.setText(NoPicSubmit.this.getResources().getString(
				R.string.sec1_title));
		sec1_title.setTextColor(Color.BLACK);
		sec1_1.setText(NoPicSubmit.this.getResources().getString(
				R.string.sec1_1));
		sec1_2.setText(NoPicSubmit.this.getResources().getString(
				R.string.sec1_2));
		sec1_3.setText(NoPicSubmit.this.getResources().getString(
				R.string.sec1_3));

		sec2_title.setText(NoPicSubmit.this.getResources().getString(
				R.string.sec2_title));
		sec2_title.setTextColor(Color.BLACK);
		sec2_1.setText(NoPicSubmit.this.getResources().getString(
				R.string.sec2_1));
		sec2_2.setText(NoPicSubmit.this.getResources().getString(
				R.string.sec2_2));

		sec3_title.setText(NoPicSubmit.this.getResources().getString(
				R.string.sec3_title));
		sec3_title.setTextColor(Color.BLACK);
		sec3_1.setText(NoPicSubmit.this.getResources().getString(
				R.string.sec3_1));
		sec3_2.setText(NoPicSubmit.this.getResources().getString(
				R.string.sec3_2));
		sec3_3.setText(NoPicSubmit.this.getResources().getString(
				R.string.sec3_3));

		sec4_title.setText(NoPicSubmit.this.getResources().getString(
				R.string.sec4_title));
		sec4_title.setTextColor(Color.BLACK);
		sec4_1.setText(NoPicSubmit.this.getResources().getString(
				R.string.sec4_1));
		sec4_2.setText(NoPicSubmit.this.getResources().getString(
				R.string.sec4_2));

		sec5_title.setText(NoPicSubmit.this.getResources().getString(
				R.string.sec5_title));
		sec5_title.setTextColor(Color.BLACK);
		sec5_1.setText(NoPicSubmit.this.getResources().getString(
				R.string.sec5_1));
		sec5_2.setText(NoPicSubmit.this.getResources().getString(
				R.string.sec5_2));
		sec5_3.setText(NoPicSubmit.this.getResources().getString(
				R.string.sec5_3));

		sec6_title.setText(NoPicSubmit.this.getResources().getString(
				R.string.sec6_title));
		sec6_title.setTextColor(Color.BLACK);
		sec6_1.setText(NoPicSubmit.this.getResources().getString(
				R.string.sec6_1));
		sec6_2.setText(NoPicSubmit.this.getResources().getString(
				R.string.sec6_2));
		sec6_3.setText(NoPicSubmit.this.getResources().getString(
				R.string.sec6_3));

		sec1_1.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub

			}
		});
		sec1_2.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub

			}
		});
		sec1_3.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub

			}
		});

		sec2_1.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub

			}
		});
		sec2_2.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub

			}
		});

		sec3_1.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub

			}
		});
		sec3_2.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub

			}
		});
		sec3_3.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub

			}
		});

		sec4_1.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub

			}
		});
		sec4_2.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub

			}
		});

		sec5_1.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub

			}
		});
		sec5_2.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub

			}
		});
		sec5_3.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub

			}
		});

		sec6_1.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub

			}
		});
		sec6_2.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub

			}
		});
		sec6_3.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub

			}
		});

	}
}
