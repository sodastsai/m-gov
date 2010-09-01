package net;

import java.io.IOException;
import java.net.URL;
import java.net.URLConnection;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.htmlparser.Parser;
import org.htmlparser.filters.NodeClassFilter;
import org.htmlparser.tags.BodyTag;
import org.htmlparser.util.NodeList;
import org.htmlparser.util.ParserException;
import org.htmlparser.visitors.TextExtractingVisitor;

import tool.ReadFile;

public class HtmlFilter {

	public static void main(String args[]) {

		String str, res = "";
		Matcher tmp;
		str = ReadFile.read("/Users/wildmind5/test.in");
		// System.out.print(str);
		tmp = Pattern.compile("案情補述相關照片.*?\n", Pattern.DOTALL).matcher(str);

		if (tmp.find())
			res = tmp.group();

		tmp = Pattern.compile("http://.*?JPG", Pattern.DOTALL).matcher(res);
		res = "案情補述相關照片：";

		while (tmp.find())
			res += tmp.group() + " ";
		System.out.println(res);

	}

	public static String process(String stringUrl) throws IOException {
		URL url;
		URLConnection connection = null;
		url = new URL(stringUrl);
		connection = url.openConnection();
		return processByURL(connection);
	}

	public static String processByHTMLStr(String htmlstr)
			throws ParserException {
		Parser parser = new Parser();
		htmlstr = Pattern.compile("<(script)[^>]*>(.*?)</script>",
				Pattern.MULTILINE + Pattern.DOTALL).matcher(htmlstr)
				.replaceAll("");
		htmlstr = Pattern.compile("(<!--.{0,}?-->)",
				Pattern.MULTILINE + Pattern.DOTALL).matcher(htmlstr)
				.replaceAll("");
		parser.setInputHTML(htmlstr);
		TextExtractingVisitor visitor = new TextExtractingVisitor();
		parser.visitAllNodesWith(visitor);
		// System.out.print("go"+str);

		return visitor.getExtractedText();
	}

	public static String processByURL(URLConnection connection) {
		String str = "";
		String tmp = "";
		try {
			Parser parser = new Parser(connection);
			NodeList nodeList = parser
					.parse(new NodeClassFilter(BodyTag.class));
			str = nodeList.toHtml();

			str = makeImageURL(str);

			str = Pattern.compile("<(script)[^>]*>(.*?)</script>",
					Pattern.MULTILINE + Pattern.DOTALL).matcher(str)
					.replaceAll("");
			str = Pattern.compile("(<!--.{0,}?-->)",
					Pattern.MULTILINE + Pattern.DOTALL).matcher(str)
					.replaceAll("");
			parser.setInputHTML(str);
			TextExtractingVisitor visitor = new TextExtractingVisitor();
			parser.visitAllNodesWith(visitor);
			// System.out.print("go"+str);
			str = visitor.getExtractedText();
		} catch (Exception e) {
			e.printStackTrace();
			// eat it
		}
		return str;
	}

	private static String makeImageURL(String str) {
		String res = "";
		Matcher matcher;
		matcher = Pattern.compile("案情補述相關照片.*?\n", Pattern.DOTALL).matcher(str);

		if (matcher.find())
			res = matcher.group();

		matcher = Pattern.compile("http://.*?JPG", Pattern.DOTALL).matcher(res);
		res = "案情補述相關照片：\n";

		while (matcher.find())
			res += matcher.group() + "\n";
		System.out.println(res);

		return Pattern.compile("案情補述相關照片.*?\n", Pattern.DOTALL).matcher(str)
				.replaceAll(res);
	}

	public static String delTrash(String textInPage) {

		textInPage = textInPage.replace("\u0009", "");
		textInPage = textInPage.replace("\r", "");
		textInPage = textInPage.replace(" ", "");

		textInPage = Pattern.compile("\n{2,}",
				Pattern.MULTILINE + Pattern.DOTALL).matcher(textInPage)
				.replaceAll("\n");
		return textInPage;
	}

}
