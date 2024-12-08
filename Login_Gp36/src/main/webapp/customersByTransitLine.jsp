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

                String sql = "SELECT r.reservation_id, r.reservation_date, c.first_name, c.last_name, c.email, ts.transit_line_name, ts.departure_datetime " +
                             "FROM Reservations r " +
                             "JOIN Customers c ON r.customer_id = c.customer_id " +
                             "JOIN Train_Schedules ts ON r.schedule_id = ts.schedule_id " +
                             "WHERE ts.transit_line_name = ? AND DATE(ts.departure_datetime) = ? " +
                             "ORDER BY r.reservation_date DESC";

                PreparedStatement pstmt = con.prepareStatement(sql);
                pstmt.setString(1, transitLine);
                pstmt.setString(2, date);

                ResultSet rs = pstmt.executeQuery();

                if (!rs.isBeforeFirst()) {
                    out.println("<p>No customers found for the specified transit line and date.</p>");
                } else {
                    out.println("<table border='1'>");
                    out.println("<tr><th>Reservation ID</th><th>Customer Name</th><th>Email</th><th>Transit Line</th><th>Departure Datetime</th><th>Reservation Date</th></tr>");
                    while (rs.next()) {
                        out.println("<tr>");
                        out.println("<td>" + rs.getInt("reservation_id") + "</td>");
                        out.println("<td>" + rs.getString("first_name") + " " + rs.getString("last_name") + "</td>");
                        out.println("<td>" + rs.getString("email") + "</td>");
                        out.println("<td>" + rs.getString("transit_line_name") + "</td>");
                        out.println("<td>" + rs.getTimestamp("departure_datetime") + "</td>");
                        out.println("<td>" + rs.getTimestamp("reservation_date") + "</td>");
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
