<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="com.cs336.pkg.*" %>
<%@ page import="java.io.*,java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Sales Report</title>
</head>
<body>
    <h2>Monthly Sales Report</h2>
    <form method="GET" action="salesReport.jsp">
        <label for="month">Select Month:</label>
        <input type="month" name="month" required><br>
        <button type="submit">Generate Report</button>
    </form>
    <%
        String month = request.getParameter("month");
        if (month != null) {
            try {
                ApplicationDB db = new ApplicationDB();
                Connection con = db.getConnection();
                String sql = "SELECT DATE_FORMAT(reservation_date, '%Y-%m') AS month, SUM(total_fare) AS total_revenue " +
                             "FROM Reservations WHERE DATE_FORMAT(reservation_date, '%Y-%m') = ? " +
                             "GROUP BY month";
                PreparedStatement pstmt = con.prepareStatement(sql);
                pstmt.setString(1, month);

                ResultSet rs = pstmt.executeQuery();

                if (!rs.isBeforeFirst()) {
                    out.println("<p>No data available for the selected month.</p>");
                } else {
                    out.println("<table border='1'><tr><th>Month</th><th>Total Revenue</th></tr>");
                    while (rs.next()) {
                        out.println("<tr><td>" + rs.getString("month") + "</td><td>$" + rs.getDouble("total_revenue") + "</td></tr>");
                    }
                    out.println("</table>");
                }
                rs.close();
                pstmt.close();
                db.closeConnection(con);

            } catch (Exception e) {
                out.println("<p>Error generating report: " + e.getMessage() + "</p>");
            }
        }
    %>
        <p><a href="adminPage.jsp">Back to Dashboard</a></p>
</body>
</html>
