<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="com.cs336.pkg.*" %>
<%@ page import="java.io.*,java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Browse Questions and Answers</title>
</head>
<body>
    <h2>Browse Questions and Answers</h2>
    <%
        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();

            String sql = "SELECT q.question_text, q.reply_text, c.first_name, c.last_name FROM Questions q " +
                         "JOIN Customers c ON q.customer_id = c.customer_id " +
                         "WHERE q.reply_text IS NOT NULL";
            PreparedStatement pstmt = con.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery();

            if (!rs.isBeforeFirst()) {
                out.println("<p>No questions or answers available at this time.</p>");
            } else {
                out.println("<table border='1'><tr><th>Customer</th><th>Question</th><th>Answer</th></tr>");
                while (rs.next()) {
                    out.println("<tr>");
                    out.println("<td>" + rs.getString("first_name") + " " + rs.getString("last_name") + "</td>");
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
    %>
    <p><a href="customerPage.jsp">Back to Dashboard</a></p>
</body>
</html>
