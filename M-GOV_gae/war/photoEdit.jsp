<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="org.dualr.lite.album.bean.Photo"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Photo Property Edit - LiteLog Album - A demo of Goolge Appengine Java</title>
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
</style>
</head>

<body>
<h1>Photo Property Edit</h1>
<%
	Photo photo = (Photo)request.getAttribute("photo");
%>
	<form action="photo?method=edit" method="post">
		<input type="hidden" name="id" value="<%=photo.getId()%>"></input>
			Title:<input type="text" name="title" value="<%=photo.getTitle()%>"/><br/>
			Description:<textarea rows="4" cols="30" name="description"><%=photo.getDescription()%></textarea><br/>
			<input type="submit" value="Save"></input>
	</form>
	<img src="photo?method=show&id=<%=photo.getId()%>"  border="0"></img>
</body>
</html>