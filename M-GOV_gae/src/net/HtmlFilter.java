package net;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.util.regex.Pattern;

import org.htmlparser.Parser;
import org.htmlparser.filters.NodeClassFilter;
import org.htmlparser.tags.BodyTag;
import org.htmlparser.util.NodeList;
import org.htmlparser.visitors.TextExtractingVisitor;

public class HtmlFilter {
	
	public static String process(String stringUrl)
	{
		URL url;
		URLConnection connection = null;
		try {
			url = new URL(stringUrl);
			try {
				connection = url.openConnection();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return process(connection);
	}
	
	public static String process(URLConnection connection) {
		String str = "";
		try {
			Parser parser = new Parser(connection);
			NodeList nodeList = parser
					.parse(new NodeClassFilter(BodyTag.class));
			str = nodeList.toHtml();
			str = Pattern.compile("<(script)[^>]*>(.*?)</script>",
					Pattern.MULTILINE + Pattern.DOTALL).matcher(str)
					.replaceAll("");
			str = Pattern.compile("(<!--.{0,}?-->)",
					Pattern.MULTILINE + Pattern.DOTALL).matcher(str)
					.replaceAll("");
			parser.setInputHTML(str);
			TextExtractingVisitor visitor = new TextExtractingVisitor();
			parser.visitAllNodesWith(visitor);
//			System.out.print("go"+str);
			str = delTrash(visitor.getExtractedText());
		} catch (Exception e) {
			e.printStackTrace();
			// eat it
		}
		return str;
	}

	private static String delTrash(String textInPage) {

		textInPage = textInPage.replace("\u0009", "");
		textInPage = textInPage.replace("\r", "");
		textInPage = textInPage.replace(" ", "");

		textInPage = Pattern.compile("\n{2,}",
				Pattern.MULTILINE + Pattern.DOTALL).matcher(textInPage)
				.replaceAll("\n");
		return textInPage;
	}

}
