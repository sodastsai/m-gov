<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="org.dualr.lite.album.bean.Photo"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Photo List and Upload - LiteLog Album - A demo of Goolge Appengine Java</title>
<style type="text/css">
	body {
		font-size: 12px;
	}
	h1{
	background: #EBF4D8;
	line-height: 28px;
	padding: 4px 0 0 1em;
	border-bottom: 1px solid #87A34D;
	color: green;
	font-size: 14px;
}
p{
	background: #EBF4D8;
	line-height: 28px;
	padding: 4px 0 0 1em;
	border-bottom: 1px solid #87A34D;
	color: green;
	font-size: 14px;
}
.data-list td{
	border-bottom:1px solid #E3E6EB;
	border-collapse:collapse;
	padding: 6px 4px 6px 4px;
	valign: middle;
}
.data-list tr:hover{
	background-color: #F3F3F3
}
#page{
	border-bottom:1px solid #87A34D;
	border-collapse:collapse;
	padding: 6px;
	valign: middle;
	overflow: hidden;
	background: #BED393;
}
a{
	color:#333333;
	text-decoration:none;
}
a:hover{
	text-decoration: underline;
}
form{
	margin: 0 0 12px 0;
}
</style>
</head>

<body>
<h1>Photo List - A demo of Goolge Appengine Java</h1>
	<form action="photo?method=upload" method="post" enctype="multipart/form-data">
			photo file:<input type="file" name="photo" />
			<input type="submit" value="upload"></input>
	</form>
	<div>
	<table class="data-list" width="100%" cellspacing="0" cellpadding="0">
				<%
				List<Object[]> photoList = (List<Object[]>)request.getAttribute("photoList");
				if(photoList.size() != 0){
					int i=1;
					for(Object[] photo : photoList){
						%>
							<tr>
								<td width="10"><%=i++%></td>
								<td><a href="photo?method=show&id=<%=photo[0].toString()%>" target="_blank" title="view"><%=photo[1].toString()%></a></td>
								<td width="170"><%=photo[2].toString()%></td>
								<td width="30"><a href="photo?method=show&id=<%=photo[0].toString()%>" target="_blank">View</a></td>
								<td width="30"><a href="photo?method=edit&id=<%=photo[0].toString()%>">Edit</a></td>
								<td width="30"><a href="photo?method=delete&id=<%=photo[0].toString()%>">Delete</a></td>
							</tr>
				<%
				}
		}else{
			%>
			<tr>
				<td>the photo list is null</td>
			</tr>
			<%
		}
	%>
	</table>
	<p>if you have any question, you can to browse <a href="http://www.mimaiji.com">http://www.mimaiji.com</a> or mail to me dualrs(at)gmail.com</p>
	</div>
</body>
</html>