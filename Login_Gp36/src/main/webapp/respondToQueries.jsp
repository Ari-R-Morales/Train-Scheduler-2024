<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="com.cs336.pkg.*" %>
<%@ page import="java.io.*,java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Respond to Customer Queries</title>
</head>
<body>
    <h2>Respond to Customer Queries</h2>
    <%
        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();

            String sql = "SELECT q.question_id, q.question_text, c.first_name, c.last_name FROM Questions q " +
                         "JOIN Customers c ON q.customer_id = c.customer_id " +
                         "WHERE q.reply_text IS NULL";
            PreparedStatement pstmt = con.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery();

            if (!rs.isBeforeFirst()) {
                out.println("<p>No unanswered questions at this time.</p>");
            } else {
                out.println("<table border='1'><tr><th>Customer</th><th>Question</th><th>Reply</th></tr>");
                while (rs.next()) {
                    out.println("<tr>");
                    out.println("<td>" + rs.getString("first_name") + " " + rs.getString("last_name") + "</td>");
                    out.println("<td>" + rs.getString("question_text") + "</td>");
                    out.println("<td>");
                    out.println("<form method='POST' action='respondToQueryAction.jsp'>");
                    out.println("<input type='hidden' name='questionId' value='" + rs.getInt("question_id") + "'>");
                    out.println("<textarea name='replyText' rows='3' cols='30' required></textarea><br>");
                    out.println("<button type='submit'>Submit Reply</button>");
                    out.println("</form>");
                    out.println("</td>");
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
    <p><a href="repPage.jsp">Back to Dashboard</a></p>
</body>
</html>
