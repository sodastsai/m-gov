package net;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.htmlparser.Parser;
import org.htmlparser.util.ParserException;
import org.htmlparser.visitors.TextExtractingVisitor;

public class HtmlFilter {

	public static String praseCoordinates (String context)
	{
		String res = "";
		Matcher matcher = Pattern.compile("zoom_pt\\([0-9. ]+?,[0-9. ]+?,[0-9. ]+?\\)").matcher(context);

		while (matcher.find())
			res += matcher.group() + "\n";
		
		res=res.replaceAll("[a-z_\\(\\)]","");
		String tmp[]=res.split(",");
		return tmp[0].trim()+","+tmp[1].trim();
	}

	public static String parseHTMLStr(String htmlstr)
			throws ParserException {
		
		htmlstr = makeImageURL(htmlstr);
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

	public static String parseQueryResult(String htmlstr)
	{
		String res = "";
		Matcher matcher = Pattern.compile("[0-9]{5,5}-[0-9]{6,6}").matcher(htmlstr);

		while (matcher.find())
			res += matcher.group() + "\n";
		return res;
	}

	private static String makeImageURL(String str) {
		String res = "";
		Matcher matcher;
		matcher = Pattern.compile("案情補述相關照片.*?\n", Pattern.DOTALL).matcher(str);

		if (matcher.find())
			res = matcher.group();

		matcher = Pattern.compile("http://.*?((JPG)|(jpg))", Pattern.DOTALL).matcher(res);
		res = "案情補述相關照片：\n";

		while (matcher.find())
			res += matcher.group() + "\n";
		System.out.println(res);

		return Pattern.compile("案情補述相關照片.*?\n", Pattern.DOTALL).matcher(str)
				.replaceAll(res);
	}

	public static String delSpace(String textInPage) {

		textInPage = textInPage.replace("\u0009", "");
		textInPage = textInPage.replace("\r", "");
		textInPage = textInPage.replace(" ", "");

		textInPage = Pattern.compile("\n{2,}",
				Pattern.MULTILINE + Pattern.DOTALL).matcher(textInPage)
				.replaceAll("\n");
		return textInPage;
	}

}
