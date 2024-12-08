<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="com.cs336.pkg.*" %>
<%@ page import="java.io.*,java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Best Customer</title>
</head>
<body>
    <h2>Best Customer</h2>
    <%
        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();
            String sql = "SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name, SUM(r.total_fare) AS total_spent " +
                         "FROM Reservations r " +
                         "JOIN Customers c ON r.customer_id = c.customer_id " +
                         "GROUP BY customer_name " +
                         "ORDER BY total_spent DESC LIMIT 1";

            PreparedStatement pstmt = con.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery();

            if (!rs.isBeforeFirst()) {
                out.println("<p>No data available for the best customer.</p>");
            } else {
                rs.next();
                out.println("<p>Best Customer: " + rs.getString("customer_name") + "</p>");
                out.println("<p>Total Spending: $" + rs.getDouble("total_spent") + "</p>");
            }

            rs.close();
            pstmt.close();
            db.closeConnection(con);

        } catch (Exception e) {
            out.println("<p>Error retrieving best customer: " + e.getMessage() + "</p>");
        }
    %>
    <p><a href="adminPage.jsp">Back to Dashboard</a></p>
</body>
</html>
