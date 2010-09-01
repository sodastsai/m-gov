//http://www.rgagnon.com/javadetails/java-0092.html

package net;

import java.net.*;
import java.io.*;
import java.util.*;

public class CookiesInURL {

	Hashtable theCookies = new Hashtable();
	URLConnection connection;
	//test
	public static void main(String args[]) throws IOException, Exception {
		try {

			String stringUrl = "http://www.czone.tcg.gov.tw/tp88-1/sys/query_memo_a.cfm?h_id=09907-010244";
			URL url = new URL(stringUrl);

			CookiesInURL cookurl = new CookiesInURL();
			cookurl.setConnection(url);

			cookurl.addCookie("CFID", "280040", true);
			cookurl.addCookie("CFTOKEN", "27012071", true);

			String r = null;
			r = net.ReadUrl.process(cookurl.connection);
			r = net.HtmlFilter.processByHTMLStr(r);
			r = net.HtmlFilter.delTrash(r);
			
			System.out.println(r);
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	public void setConnection(URL url) throws IOException {
		connection = url.openConnection();
	}

	public void setConnection(String urlstring) throws IOException {
		URL url = new URL(urlstring);
		setConnection(url);
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
		Enumeration keys = theCookies.keys();
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
		Enumeration keys = theCookies.keys();
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
