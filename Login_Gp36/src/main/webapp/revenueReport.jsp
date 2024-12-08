<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="com.cs336.pkg.*" %>
<%@ page import="java.io.*,java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Revenue Report</title>
</head>
<body>
    <h2>Revenue Report</h2>
    <form method="GET" action="revenueReport.jsp">
        <label for="groupBy">Group By:</label>
        <select name="groupBy">
            <option value="transitLine" <%= "transitLine".equals(request.getParameter("groupBy")) ? "selected" : "" %>>Transit Line</option>
            <option value="customerName" <%= "customerName".equals(request.getParameter("groupBy")) ? "selected" : "" %>>Customer Name</option>
        </select><br>
        
        <button type="submit">Generate Report</button>
    </form>
    <%
        String groupBy = request.getParameter("groupBy");

        if (groupBy != null) {
            try {
                ApplicationDB db = new ApplicationDB();
                Connection con = db.getConnection();
                String sql;

                if ("transitLine".equals(groupBy)) {
                    sql = "SELECT ts.transit_line_name, SUM(r.total_fare) AS total_revenue " +
                          "FROM Reservations r " +
                          "JOIN Train_Schedules ts ON r.schedule_id = ts.schedule_id " +
                          "GROUP BY ts.transit_line_name " +
                          "ORDER BY total_revenue DESC";
                } else {
                    sql = "SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name, SUM(r.total_fare) AS total_revenue " +
                          "FROM Reservations r " +
                          "JOIN Customers c ON r.customer_id = c.customer_id " +
                          "GROUP BY customer_name " +
                          "ORDER BY total_revenue DESC";
                }

                PreparedStatement pstmt = con.prepareStatement(sql);

                ResultSet rs = pstmt.executeQuery();

                if (!rs.isBeforeFirst()) {
                    out.println("<p>No revenue data available.</p>");
                } else {
                    out.println("<table border='1'><tr><th>" + (groupBy.equals("transitLine") ? "Transit Line" : "Customer Name") + "</th><th>Total Revenue</th></tr>");
                    while (rs.next()) {
                        out.println("<tr>");
                        out.println("<td>" + rs.getString(1) + "</td>");
                        out.println("<td>$" + rs.getDouble("total_revenue") + "</td>");
                        out.println("</tr>");
                    }
                    out.println("</table>");
                }

                rs.close();
                pstmt.close();
                db.closeConnection(con);

            } catch (Exception e) {
                out.println("<p>Error generating revenue report: " + e.getMessage() + "</p>");
            }
        }
    %>
    <p><a href="adminPage.jsp">Back to Dashboard</a></p>
</body>
</html>
