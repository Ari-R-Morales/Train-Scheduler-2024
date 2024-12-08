<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="com.cs336.pkg.*" %>
<%@ page import="java.io.*,java.sql.*" %>

<%
    // Retrieve parameters from the form
    String questionId = request.getParameter("questionId");
    String replyText = request.getParameter("replyText");

    // Validate inputs
    if (questionId == null || questionId.trim().isEmpty() || replyText == null || replyText.trim().isEmpty()) {
        out.println("<p>Error: Invalid action or missing data.</p>");
        out.println("<p><a href='respondToQueries.jsp'>Back to Queries</a></p>");
        return;
    }

    if (session == null) {
        out.println("<p>Session is null. Redirecting to login.</p>");
        response.sendRedirect("login.jsp");
        return;
    }

    Integer employeeId = (Integer) session.getAttribute("employee_id");

    if (employeeId == null) {
        out.println("<p>Employee ID not found in session. Redirecting to login.</p>");
        response.sendRedirect("login.jsp");
        return;
    }

    try {
        // Establish database connection
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();

        // Update the question with the reply
        String sql = "UPDATE Questions SET reply_text = ?, replied_by = ?, replied_at = NOW() WHERE question_id = ?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, replyText);
        pstmt.setInt(2, employeeId);
        pstmt.setInt(3, Integer.parseInt(questionId));

        int rowsUpdated = pstmt.executeUpdate();

        if (rowsUpdated > 0) {
            out.println("<p>Reply submitted successfully!</p>");
        } else {
            out.println("<p>Failed to submit the reply. Please try again.</p>");
        }

        // Close resources
        pstmt.close();
        db.closeConnection(con);

    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }
%>
<p><a href="respondToQueries.jsp">Back to Queries</a></p>
