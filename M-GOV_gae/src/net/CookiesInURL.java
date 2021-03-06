//http://www.rgagnon.com/javadetails/java-0092.html

package net;

import gae.GAENodeCookie;
import gae.PMF;

import java.net.*;
import java.io.*;
import java.util.*;

import javax.jdo.PersistenceManager;

public class CookiesInURL {

	Hashtable<String, String> theCookies = new Hashtable<String, String>();
	public URLConnection connection;
	// test
	public static String CFID = "1122207";
	public static String CFTOKEN = "35573909";

	public static void main(String args[]) throws IOException, Exception {
		try {
			String stringUrl = "http://www.czone2.tcg.gov.tw/tp88-1/sys/query_memo_a.cfm?h_id=09907-010270";
			URL url = new URL(stringUrl);

			CookiesInURL cookurl = new CookiesInURL(url.openConnection());

			String r;
			r = net.ReadUrl.process(cookurl.connection,"big5");
			
			System.out.println(r);

		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	public CookiesInURL(String strurl) throws IOException {
		connection = new URL(strurl).openConnection();
		setDefaultCookie();
	}

	public CookiesInURL(URLConnection urlcon) {
		connection = urlcon;
		setDefaultCookie();
	}

	private void setDefaultCookie() {

		GAENodeCookie c1,c2;
		PersistenceManager pm = PMF.get().getPersistenceManager();
		c1 = pm.getObjectById(GAENodeCookie.class,"CFID");
		c2 = pm.getObjectById(GAENodeCookie.class,"CFTOKEN");
		
		CFID = c1.getValue();
		CFTOKEN = c2.getValue();
		
		addCookie("CFID", CFID, false);
		addCookie("CFTOKEN", CFTOKEN, false);
	}

	public URLConnection getConnection() {
		return connection;

	}

	/**
	 * Send the Hashtable (theCookies) as cookies, and write them to the
	 * specified URLconnection
	 * 
	 * @param urlConn
	 *            The connection to write the cookies to.
	 * @param printCookies
	 *            Print or not the action taken.
	 * 
	 * @return The urlConn with the all the cookies in it.
	 */

	public URLConnection writeCookies(boolean printCookies) {
		String cookieString = "";
		Enumeration<String> keys = theCookies.keys();
		while (keys.hasMoreElements()) {
			String key = (String) keys.nextElement();
			cookieString += key + "=" + theCookies.get(key);
			if (keys.hasMoreElements())
				cookieString += "; ";
		}
		connection.setRequestProperty("Cookie", cookieString);
		if (printCookies)
			System.out.println("Wrote cookies:\n   " + cookieString);
		return connection;
	}

	/**
	 * Read cookies from a specified URLConnection, and insert them to the
	 * Hashtable The hashtable represents the Cookies.
	 * 
	 * @param urlConn
	 *            the connection to read from
	 * @param printCookies
	 *            Print the cookies or not, for debugging
	 * @param reset
	 *            Clean the Hashtable or not
	 */
	public void readCookies(URLConnection urlConn, boolean printCookies,
			boolean reset) {
		if (reset)
			theCookies.clear();
		int i = 1;
		String hdrKey;
		String hdrString;
		String aCookie;
		while ((hdrKey = urlConn.getHeaderFieldKey(i)) != null) {
			if (hdrKey.equals("Set-Cookie")) {
				hdrString = urlConn.getHeaderField(i);
				StringTokenizer st = new StringTokenizer(hdrString, ",");
				while (st.hasMoreTokens()) {
					String s = st.nextToken();
					aCookie = s.substring(0, s.indexOf(";"));
					// aCookie = hdrString.substring(0, s.indexOf(";"));
					int j = aCookie.indexOf("=");
					if (j != -1) {
						if (!theCookies.containsKey(aCookie.substring(0, j))) {
							// if the Cookie do not already exist then when keep
							// it,
							// you may want to add some logic to update
							// the stored Cookie instead. thanks to rwhelan
							theCookies.put(aCookie.substring(0, j), aCookie
									.substring(j + 1));
							if (printCookies) {
								System.out.println("Reading Key: "
										+ aCookie.substring(0, j));
								System.out.println("        Val: "
										+ aCookie.substring(j + 1));
							}
						}
					}
				}
			}
			i++;
		}
	}

	/**
	 * Display all the cookies currently in the HashTable
	 * 
	 */
	public void viewAllCookies() {
		System.out.println("All Cookies are:");
		Enumeration<String> keys = theCookies.keys();
		String key;
		while (keys.hasMoreElements()) {
			key = (String) keys.nextElement();
			System.out.println("   " + key + "=" + theCookies.get(key));
		}
	}

	/**
	 * Display the current cookies in the URLConnection, searching for the:
	 * "Cookie" header
	 * 
	 * This is Valid only after a writeCookies operation.
	 * 
	 * @param urlConn
	 *            The URL to print the associates cookies in.
	 */
	public void viewURLCookies(URLConnection urlConn) {
		System.out.print("Cookies in this URLConnection are:\n   ");
		System.out.println(urlConn.getRequestProperty("Cookie"));
	}

	/**
	 * Add a specific cookie, by hand, to the HastTable of the Cookies
	 * 
	 * @param _key
	 *            The Key/Name of the Cookie
	 * @param _val
	 *            The Calue of the Cookie
	 * @param printCookies
	 *            Print or not the result
	 */
	public void addCookie(String _key, String _val, boolean printCookies) {
		if (!theCookies.containsKey(_key)) {
			theCookies.put(_key, _val);
			if (printCookies) {
				System.out.println("Adding Cookie: ");
				System.out.println("   " + _key + " = " + _val);
			}
		}
		writeCookies(true);
	}

}
