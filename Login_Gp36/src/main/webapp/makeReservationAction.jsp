<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.ApplicationDB, java.sql.*, javax.servlet.http.*, javax.servlet.*" %>

<%
    // Retrieve form parameters
    String origin = request.getParameter("origin");
    String destination = request.getParameter("destination");
    String date = request.getParameter("date");
    String ticketType = request.getParameter("ticketType");
    String discount = request.getParameter("discount");

    // Validate session and get customer_id
    if (session == null || session.getAttribute("customer_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    try {
        int customerId = (Integer) session.getAttribute("customer_id");

        // Map the discount value to discount type
        String discountType = "None";
        if ("25".equals(discount)) discountType = "Child";
        else if ("35".equals(discount)) discountType = "Senior";
        else if ("50".equals(discount)) discountType = "Disabled";

        // Database connection
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();

        // Query to get the schedule ID, fare, and number of stops
        String sqlFare = "SELECT ts.schedule_id, ts.fare, COUNT(st.stop_id) AS stops_count " +
                         "FROM Train_Schedules ts " +
                         "JOIN Stations s1 ON ts.origin_station_id = s1.station_id " +
                         "JOIN Stations s2 ON ts.destination_station_id = s2.station_id " +
                         "JOIN Stops st ON ts.schedule_id = st.schedule_id " +
                         "WHERE s1.station_name = ? AND s2.station_name = ? AND DATE(ts.departure_datetime) = ? " +
                         "GROUP BY ts.schedule_id";
        PreparedStatement pstmtFare = con.prepareStatement(sqlFare);
        pstmtFare.setString(1, origin);
        pstmtFare.setString(2, destination);
        pstmtFare.setString(3, date);

        ResultSet rsFare = pstmtFare.executeQuery();

        if (!rsFare.next()) {
            out.println("<p>No schedules found for the selected criteria. Please try again.</p>");
        } else {
            int scheduleId = rsFare.getInt("schedule_id");
            double baseFare = rsFare.getDouble("fare");

            // Calculate total fare with discount and round-trip multiplier
            double discountValue = Double.parseDouble(discount) / 100;
            double discountedFare = baseFare - (baseFare * discountValue);
            double totalFare = "Round-Trip".equals(ticketType) ? discountedFare * 2 : discountedFare;

            // Insert reservation into the database
            String sqlReservation = "INSERT INTO Reservations (customer_id, schedule_id, reservation_date, total_fare, origin_station_id, destination_station_id, ticket_type, discount_type) " +
                                    "VALUES (?, ?, NOW(), ?, (SELECT station_id FROM Stations WHERE station_name = ?), (SELECT station_id FROM Stations WHERE station_name = ?), ?, ?)";
            PreparedStatement pstmtReservation = con.prepareStatement(sqlReservation);
            pstmtReservation.setInt(1, customerId);
            pstmtReservation.setInt(2, scheduleId);
            pstmtReservation.setDouble(3, totalFare);
            pstmtReservation.setString(4, origin);
            pstmtReservation.setString(5, destination);
            pstmtReservation.setString(6, ticketType);
            pstmtReservation.setString(7, discountType);

            int rowsInserted = pstmtReservation.executeUpdate();

            if (rowsInserted > 0) {
                out.println("<p>Reservation successful! Total Fare: $" + totalFare + "</p>");
            } else {
                out.println("<p>Failed to make reservation. Please try again.</p>");
            }

            pstmtReservation.close();
        }

        rsFare.close();
        pstmtFare.close();
        db.closeConnection(con);

    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }
%>
<a href="customerPage.jsp">Back to Dashboard</a>
