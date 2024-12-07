<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="com.cs336.pkg.*" %>
<%@ page import="java.io.*,java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>View Reservation History</title>
</head>
<body>
    <h2>Your Reservation History</h2>

    <%
        // Debug session values
        out.println("Session customer_id: " + session.getAttribute("customer_id"));

        // Use the implicit session object
        if (session == null || session.getAttribute("customer_id") == null) {
            out.println("<p>Session is null or customer_id is not set.</p>");
            response.sendRedirect("login.jsp");
            return;
        }

        int customerId = (Integer) session.getAttribute("customer_id");

        try {
            // Establish database connection
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();

            // Query to fetch reservation history for the logged-in user
            String sql = "SELECT r.reservation_date, r.total_fare, r.ticket_type, "
                       + "s1.station_name AS origin, s2.station_name AS destination, ts.departure_datetime "
                       + "FROM Reservations r "
                       + "JOIN Train_Schedules ts ON r.schedule_id = ts.schedule_id "
                       + "JOIN Stations s1 ON r.origin_station_id = s1.station_id "
                       + "JOIN Stations s2 ON r.destination_station_id = s2.station_id "
                       + "WHERE r.customer_id = ? "
                       + "ORDER BY r.reservation_date DESC";

            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, customerId);

            ResultSet rs = pstmt.executeQuery();

            if (!rs.isBeforeFirst()) {
                out.println("<p>You have no reservation history.</p>");
            } else {
                out.println("<table border='1'>");
                out.println("<tr><th>Reservation Date</th><th>Origin</th><th>Destination</th>"
                          + "<th>Travel Date</th><th>Ticket Type</th><th>Fare</th></tr>");
                while (rs.next()) {
                    out.println("<tr>");
                    out.println("<td>" + rs.getTimestamp("reservation_date") + "</td>");
                    out.println("<td>" + rs.getString("origin") + "</td>");
                    out.println("<td>" + rs.getString("destination") + "</td>");
                    out.println("<td>" + rs.getTimestamp("departure_datetime") + "</td>");
                    out.println("<td>" + rs.getString("ticket_type") + "</td>");
                    out.println("<td>$" + rs.getDouble("total_fare") + "</td>");
                    out.println("</tr>");
                }
                out.println("</table>");
            }

            // Close resources
            rs.close();
            pstmt.close();
            db.closeConnection(con);

        } catch (Exception e) {
            out.println("<p>Error retrieving your reservation history: " + e.getMessage() + "</p>");
        }
    %>

    <p><a href="customerPage.jsp">Back to Dashboard</a></p>
</body>
</html>
