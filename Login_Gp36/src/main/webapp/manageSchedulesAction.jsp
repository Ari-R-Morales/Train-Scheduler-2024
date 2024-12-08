<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="com.cs336.pkg.*" %>
<%@ page import="java.io.*,java.sql.*" %>

<%
    String action = request.getParameter("action");
    String scheduleId = request.getParameter("scheduleId");
    String transitLine = request.getParameter("transitLine");
    String departureDatetime = request.getParameter("departureDatetime");
    String arrivalDatetime = request.getParameter("arrivalDatetime");
    String fare = request.getParameter("fare");

    try {
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();

        if ("edit".equals(action)) {
            // Update schedule
            String sql = "UPDATE Train_Schedules SET transit_line_name = ?, departure_datetime = ?, arrival_datetime = ?, fare = ? WHERE schedule_id = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, transitLine);
            pstmt.setString(2, departureDatetime);
            pstmt.setString(3, arrivalDatetime);
            pstmt.setDouble(4, Double.parseDouble(fare));
            pstmt.setInt(5, Integer.parseInt(scheduleId));

            int rowsUpdated = pstmt.executeUpdate();
            if (rowsUpdated > 0) {
                out.println("<p>Train schedule updated successfully.</p>");
            } else {
                out.println("<p>Error: Failed to update train schedule.</p>");
            }

            pstmt.close();
        } else if ("delete".equals(action)) {
            // Delete schedule
            String sql = "DELETE FROM Train_Schedules WHERE schedule_id = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(scheduleId));

            int rowsDeleted = pstmt.executeUpdate();
            if (rowsDeleted > 0) {
                out.println("<p>Train schedule deleted successfully.</p>");
            } else {
                out.println("<p>Error: Failed to delete train schedule.</p>");
            }

            pstmt.close();
        }

        db.closeConnection(con);

    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }
%>
<p><a href="manageSchedules.jsp">Back to Manage Train Schedules</a></p>
