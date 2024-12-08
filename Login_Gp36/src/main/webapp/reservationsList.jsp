<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="com.cs336.pkg.*" %>
<%@ page import="java.io.*,java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>View Reservations</title>
</head>
<body>
    <h2>Reservations</h2>
    <form method="GET" action="reservationsList.jsp">
        <label for="filterBy">Filter By:</label>
        <select name="filterBy">
            <option value="transitLine" <%= "transitLine".equals(request.getParameter("filterBy")) ? "selected" : "" %>>Transit Line</option>
            <option value="customerName" <%= "customerName".equals(request.getParameter("filterBy")) ? "selected" : "" %>>Customer Name</option>
        </select><br>
        
        <label for="filterValue">Filter Value:</label>
        <input type="text" name="filterValue" value="<%= request.getParameter("filterValue") != null ? request.getParameter("filterValue") : "" %>" required><br>
        
        <button type="submit">Search</button>
    </form>
    <%
        String filterBy = request.getParameter("filterBy");
        String filterValue = request.getParameter("filterValue");

        if (filterBy != null && filterValue != null) {
            try {
                ApplicationDB db = new ApplicationDB();
                Connection con = db.getConnection();
                String sql;

                if ("transitLine".equals(filterBy)) {
                    sql = "SELECT r.reservation_id, r.reservation_date, c.first_name, c.last_name, ts.transit_line_name, r.total_fare " +
                          "FROM Reservations r " +
                          "JOIN Customers c ON r.customer_id = c.customer_id " +
                          "JOIN Train_Schedules ts ON r.schedule_id = ts.schedule_id " +
                          "WHERE ts.transit_line_name = ?";
                } else {
                    sql = "SELECT r.reservation_id, r.reservation_date, c.first_name, c.last_name, ts.transit_line_name, r.total_fare " +
                          "FROM Reservations r " +
                          "JOIN Customers c ON r.customer_id = c.customer_id " +
                          "JOIN Train_Schedules ts ON r.schedule_id = ts.schedule_id " +
                          "WHERE CONCAT(c.first_name, ' ', c.last_name) LIKE ?";
                    filterValue = "%" + filterValue + "%"; // Allow partial matches
                }

                PreparedStatement pstmt = con.prepareStatement(sql);
                pstmt.setString(1, filterValue);

                ResultSet rs = pstmt.executeQuery();

                if (!rs.isBeforeFirst()) {
                    out.println("<p>No reservations found for the specified filter.</p>");
                } else {
                    out.println("<table border='1'><tr><th>Reservation ID</th><th>Date</th><th>Customer</th><th>Transit Line</th><th>Fare</th></tr>");
                    while (rs.next()) {
                        out.println("<tr>");
                        out.println("<td>" + rs.getInt("reservation_id") + "</td>");
                        out.println("<td>" + rs.getTimestamp("reservation_date") + "</td>");
                        out.println("<td>" + rs.getString("first_name") + " " + rs.getString("last_name") + "</td>");
                        out.println("<td>" + rs.getString("transit_line_name") + "</td>");
                        out.println("<td>$" + rs.getDouble("total_fare") + "</td>");
                        out.println("</tr>");
                    }
                    out.println("</table>");
                }

                rs.close();
                pstmt.close();
                db.closeConnection(con);

            } catch (Exception e) {
                out.println("<p>Error retrieving reservations: " + e.getMessage() + "</p>");
            }
        }
    %>
    <p><a href="adminPage.jsp">Back to Dashboard</a></p>
</body>
</html>
