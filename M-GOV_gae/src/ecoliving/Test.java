package ecoliving;

import gae.GAEDateBase;
import gae.GAENode;

import java.util.regex.Pattern;

import net.HtmlFilter;

import org.htmlparser.filters.NodeClassFilter;
import org.htmlparser.tags.BodyTag;
import org.htmlparser.util.NodeList;
import org.htmlparser.visitors.TextExtractingVisitor;
import org.htmlparser.Parser;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@Path("/test")
public class Test {
	@GET
	@Produces(MediaType.TEXT_PLAIN)
	@Path("{c1}")
	public static String go(@PathParam("c1") String cmd) {
		try {
			int n = Integer.parseInt(cmd);
			String all = "";
			String url,s;
			for (int i = 1; i <= n; i++) {
				url = String.format("http://w.csie.org/~b97115/query%d.htm", i);
				s = HtmlFilter.process(url);
				storeResult(s);
				all += s;
			}
			return all + "\ndone";
			// return Store(table);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return "failed" + e.toString();
		}
	}

	private static void storeResult(String res) {
		String line[] = res.split("\n");
		int i;
		for (i = 0; !"查報案件".equals(line[i]); i++);

		GAENode node = new GAENode(
				line[i + 1].substring(line[i + 1].indexOf("：") + 1),
				line[i + 2], 
				line[i + 3] + " "+ line[i + 4], 
				line[i + 5],
				line[i + 6], 
				res.substring(res.indexOf("案情摘要") ));

		// System.out.println(node.getKey());
		GAEDateBase.store(node);
	}
}