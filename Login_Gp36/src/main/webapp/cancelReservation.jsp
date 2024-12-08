<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="com.cs336.pkg.*" %>
<%@ page import="java.io.*,java.sql.*" %>

<%
    session = request.getSession(false);
    if (session == null || session.getAttribute("customer_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int customerId = (Integer) session.getAttribute("customer_id");
    String reservationId = request.getParameter("reservationId");

    try {
        // Database connection
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();

        // Validate that the reservation belongs to the logged-in customer
        String sqlValidate = "SELECT reservation_id FROM Reservations WHERE reservation_id = ? AND customer_id = ?";
        PreparedStatement pstmtValidate = con.prepareStatement(sqlValidate);
        pstmtValidate.setString(1, reservationId);
        pstmtValidate.setInt(2, customerId);

        ResultSet rs = pstmtValidate.executeQuery();

        if (!rs.next()) {
            out.println("<p>Invalid reservation or you do not have permission to cancel this reservation.</p>");
        } else {
            // Delete the reservation
            String sqlDelete = "DELETE FROM Reservations WHERE reservation_id = ?";
            PreparedStatement pstmtDelete = con.prepareStatement(sqlDelete);
            pstmtDelete.setString(1, reservationId);

            int rowsDeleted = pstmtDelete.executeUpdate();
            if (rowsDeleted > 0) {
                out.println("<p>Reservation successfully canceled.</p>");
            } else {
                out.println("<p>Failed to cancel the reservation. Please try again.</p>");
            }

            pstmtDelete.close();
        }

        rs.close();
        pstmtValidate.close();
        db.closeConnection(con);

    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }
%>
<p><a href="viewReservations.jsp">Back to Reservations</a></p>
