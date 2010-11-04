package gae;

import java.util.Date;

import javax.jdo.annotations.IdentityType;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

import com.google.appengine.api.datastore.Text;

@PersistenceCapable(identityType = IdentityType.APPLICATION)
public class GAENodeDebug {

	@PrimaryKey
	@Persistent
	private String key;
	@Persistent
	private Date date;
	@Persistent
	private String tag;
	@Persistent
	public Text text;

	
	public GAENodeDebug(String tag,String text){
		this.tag = tag;
		this.key = String.valueOf(text.hashCode());
		this.date = new Date();
		this.text = new Text(text);
	}

	public String getKey() {
		return key;
	};

	public Date getDate() {
		return date;
	};
}