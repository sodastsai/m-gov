package gae;

import javax.jdo.annotations.IdentityType;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;
@PersistenceCapable(identityType = IdentityType.APPLICATION)

public class GAENodeCookie {
	@SuppressWarnings("unused")
	@PrimaryKey
	@Persistent
	private String key;
	@Persistent
	private String value;

	public GAENodeCookie(String key, String value) {
		this.key = key;
		this.value = value;
	}

	public String getValue() {
		return value;
	}

	public String toString() {
		return key + "  " + value;
	}
}
