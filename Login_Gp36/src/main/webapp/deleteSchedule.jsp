<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="com.cs336.pkg.*" %>
<%@ page import="java.io.*,java.sql.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%
    String scheduleId = request.getParameter("scheduleId");

    try {
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();

        String sql = "DELETE FROM Train_Schedules WHERE schedule_id = ?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(scheduleId));

        int rowsDeleted = pstmt.executeUpdate();
        if (rowsDeleted > 0) {
            out.println("<p>Schedule deleted successfully!</p>");
        } else {
            out.println("<p>Failed to delete schedule. Please check the Schedule ID.</p>");
        }

        pstmt.close();
        db.closeConnection(con);

    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }
%>
<a href="browseSchedules.jsp">Back to Browse</a>
