<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="com.cs336.pkg.*" %>
<%@ page import="java.io.*,java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Customers by Transit Line</title>
</head>
<body>
    <h2>View Customers with Reservations by Transit Line and Date</h2>
    <form method="GET" action="customersByTransitLine.jsp">
        <label for="transitLine">Transit Line:</label>
        <input type="text" name="transitLine" value="<%= request.getParameter("transitLine") != null ? request.getParameter("transitLine") : "" %>" required><br>

        <label for="date">Date:</label>
        <input type="date" name="date" value="<%= request.getParameter("date") != null ? request.getParameter("date") : "" %>" required><br>

        <button type="submit">Search</button>
    </form>

    <%
        String transitLine = request.getParameter("transitLine");
        String date = request.getParameter("date");

        if (transitLine != null && date != null) {
            try {
                ApplicationDB db = new ApplicationDB();
                Connection con = db.getConnection();

                String sql = "SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name, COUNT(r.reservation_id) AS number_of_bookings, SUM(r.total_fare) AS total_fare " +
                             "FROM Reservations r " +
                             "JOIN Customers c ON r.customer_id = c.customer_id " +
                             "JOIN Train_Schedules ts ON r.schedule_id = ts.schedule_id " +
                             "WHERE ts.transit_line_name = ? AND DATE(ts.departure_datetime) = ? " +
                             "GROUP BY c.customer_id, c.first_name, c.last_name " +
                             "ORDER BY number_of_bookings DESC";

                PreparedStatement pstmt = con.prepareStatement(sql);
                pstmt.setString(1, transitLine);
                pstmt.setString(2, date);

                ResultSet rs = pstmt.executeQuery();

                if (!rs.isBeforeFirst()) {
                    out.println("<p>No customers found for the specified transit line and date.</p>");
                } else {
                    out.println("<table border='1'>");
                    out.println("<tr><th>Customer Name</th><th>Number of Bookings</th><th>Total Fare</th></tr>");
                    while (rs.next()) {
                        out.println("<tr>");
                        out.println("<td>" + rs.getString("customer_name") + "</td>");
                        out.println("<td>" + rs.getInt("number_of_bookings") + "</td>");
                        out.println("<td>$" + rs.getDouble("total_fare") + "</td>");
                        out.println("</tr>");
                    }
                    out.println("</table>");
                }

                rs.close();
                pstmt.close();
                db.closeConnection(con);

            } catch (Exception e) {
                out.println("<p>Error retrieving data: " + e.getMessage() + "</p>");
            }
        }
    %>

    <p><a href="repPage.jsp">Back to Dashboard</a></p>
</body>
</html>
