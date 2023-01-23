<html>
<head>
<title>PERL:ASP</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="xampp.css" rel="stylesheet" type="text/css">
</head>
<body>
&nbsp;<p>
<table width=500 cellpadding=0 cellspacing=0 border=0>
<tr><td align=center>
<h1>Testing ASP with a loop incrementing the text size:<h1><p>
<% for(1..5) { %>
<!-- iterated html text -->
<font size="<%=$_%>" > Size = <%=$_%> </font> <br>
 <% } %>
</td></tr>
</table></body>
</HTML>