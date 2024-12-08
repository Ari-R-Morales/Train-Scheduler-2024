<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="com.cs336.pkg.*" %>
<%@ page import="java.io.*,java.sql.*" %>


<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Search Questions</title>
</head>
<body>
    <h2>Search Questions</h2>
    <form method="GET" action="searchQuestions.jsp">
        <label for="keyword">Keyword:</label>
        <input type="text" name="keyword" value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>" required>
        <button type="submit">Search</button>
    </form>
    <%
        String keyword = request.getParameter("keyword");

        if (keyword != null) {
            try {
                ApplicationDB db = new ApplicationDB();
                Connection con = db.getConnection();

                String sql = "SELECT q.question_text, q.reply_text FROM Questions q " +
                             "WHERE q.question_text LIKE ? OR q.reply_text LIKE ?";
                PreparedStatement pstmt = con.prepareStatement(sql);
                pstmt.setString(1, "%" + keyword + "%");
                pstmt.setString(2, "%" + keyword + "%");

                ResultSet rs = pstmt.executeQuery();

                if (!rs.isBeforeFirst()) {
                    out.println("<p>No results found for the keyword: " + keyword + "</p>");
                } else {
                    out.println("<table border='1'><tr><th>Question</th><th>Answer</th></tr>");
                    while (rs.next()) {
                        out.println("<tr>");
                        out.println("<td>" + rs.getString("question_text") + "</td>");
                        out.println("<td>" + rs.getString("reply_text") + "</td>");
                        out.println("</tr>");
                    }
                    out.println("</table>");
                }

                rs.close();
                pstmt.close();
                db.closeConnection(con);

            } catch (Exception e) {
                out.println("<p>Error: " + e.getMessage() + "</p>");
            }
        }
    %>
    <p><a href="customerPage.jsp">Back to Dashboard</a></p>
</body>
</html>
