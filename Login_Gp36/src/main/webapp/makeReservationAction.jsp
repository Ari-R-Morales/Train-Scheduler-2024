<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.sql.*,javax.servlet.http.*,javax.servlet.*" %>

<%
    String origin = request.getParameter("origin");
    String destination = request.getParameter("destination");
    String date = request.getParameter("date");
    String ticketType = request.getParameter("ticketType");
    String discount = request.getParameter("discount");

    try {
        // Get database connection
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();

        // Calculate fare
        String sqlFare = "SELECT ts.fare FROM Train_Schedules ts "
                       + "JOIN Stations s1 ON ts.origin_station_id = s1.station_id "
                       + "JOIN Stations s2 ON ts.destination_station_id = s2.station_id "
                       + "WHERE s1.station_name = ? AND s2.station_name = ? AND DATE(ts.departure_datetime) = ?";
        PreparedStatement pstmtFare = con.prepareStatement(sqlFare);
        pstmtFare.setString(1, origin);
        pstmtFare.setString(2, destination);
        pstmtFare.setString(3, date);

        ResultSet rsFare = pstmtFare.executeQuery();
        double baseFare = 0.0;
        if (rsFare.next()) {
            baseFare = rsFare.getDouble("fare");
        }

        // Apply discount
        double discountPercentage = Double.parseDouble(discount);
        double totalFare = baseFare - (baseFare * (discountPercentage / 100));

        // Insert reservation into database
        String sqlReservation = "INSERT INTO Reservations (customer_id, schedule_id, reservation_date, total_fare, origin_station_id, destination_station_id, ticket_type) "
                              + "VALUES (?, ?, NOW(), ?, (SELECT station_id FROM Stations WHERE station_name = ?), (SELECT station_id FROM Stations WHERE station_name = ?), ?)";
        PreparedStatement pstmtReservation = con.prepareStatement(sqlReservation);
        pstmtReservation.setInt(1, (Integer) session.getAttribute("customer_id")); // Assumes customer_id is stored in session
        pstmtReservation.setInt(2, rsFare.getInt("schedule_id"));
        pstmtReservation.setDouble(3, totalFare);
        pstmtReservation.setString(4, origin);
        pstmtReservation.setString(5, destination);
        pstmtReservation.setString(6, ticketType);

        int rowsInserted = pstmtReservation.executeUpdate();

        if (rowsInserted > 0) {
            out.println("<p>Reservation successful! Total Fare: $" + totalFare + "</p>");
        } else {
            out.println("<p>Failed to make reservation. Please try again.</p>");
        }

        // Close resources
        rsFare.close();
        pstmtFare.close();
        pstmtReservation.close();
        db.closeConnection(con);

    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }
%>
<a href="customerPage.jsp">Back to Dashboard</a>
