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
    <h2>Your Reservations</h2>
    <%
        session = request.getSession(false);
        if (session == null || session.getAttribute("customer_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int customerId = (Integer) session.getAttribute("customer_id");

        try {
            // Establish database connection
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();

            // Fetch future reservations for the logged-in customer
            String sql = "SELECT r.reservation_id, r.schedule_id, r.reservation_date, r.total_fare, r.ticket_type, r.discount_type, " +
                         "s1.station_name AS origin, s2.station_name AS destination, ts.departure_datetime " +
                         "FROM Reservations r " +
                         "JOIN Stations s1 ON r.origin_station_id = s1.station_id " +
                         "JOIN Stations s2 ON r.destination_station_id = s2.station_id " +
                         "JOIN Train_Schedules ts ON r.schedule_id = ts.schedule_id " +
                         "WHERE r.customer_id = ? AND ts.departure_datetime >= NOW() " +
                         "ORDER BY ts.departure_datetime ASC";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, customerId);

            ResultSet rs = pstmt.executeQuery();

            if (!rs.isBeforeFirst()) {
                out.println("<p>You have no upcoming reservations.</p>");
            } else {
                out.println("<table border='1'>");
                out.println("<tr><th>Reservation ID</th><th>Origin</th><th>Destination</th><th>Departure Date</th>" +
                            "<th>Fare</th><th>Ticket Type</th><th>Discount</th><th>Action</th></tr>");
                while (rs.next()) {
                    out.println("<tr>");
                    out.println("<td>" + rs.getInt("reservation_id") + "</td>");
                    out.println("<td>" + rs.getString("origin") + "</td>");
                    out.println("<td>" + rs.getString("destination") + "</td>");
                    out.println("<td>" + rs.getTimestamp("departure_datetime") + "</td>");
                    out.println("<td>$" + rs.getDouble("total_fare") + "</td>");
                    out.println("<td>" + rs.getString("ticket_type") + "</td>");
                    out.println("<td>" + rs.getString("discount_type") + "</td>");
                    out.println("<td><a href='cancelReservation.jsp?reservationId=" + rs.getInt("reservation_id") + "'>Cancel</a></td>");
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
    %>
    <p><a href="customerPage.jsp">Back to Dashboard</a></p>
</body>
</html>
