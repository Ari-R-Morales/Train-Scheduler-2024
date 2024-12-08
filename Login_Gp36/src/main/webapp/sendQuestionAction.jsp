<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="java.io.*,java.sql.*" %>

<%
    String questionText = request.getParameter("questionText");

    session = request.getSession(false);
    if (session == null || session.getAttribute("customer_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int customerId = (Integer) session.getAttribute("customer_id");

    try {
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();

        String sql = "INSERT INTO Questions (customer_id, question_text, created_at) VALUES (?, ?, NOW())";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setInt(1, customerId);
        pstmt.setString(2, questionText);

        int rowsInserted = pstmt.executeUpdate();

        if (rowsInserted > 0) {
            out.println("<p>Your question has been submitted successfully!</p>");
        } else {
            out.println("<p>Failed to submit your question. Please try again.</p>");
        }

        pstmt.close();
        db.closeConnection(con);

    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }
%>
<p><a href="customerPage.jsp">Back to Dashboard</a></p>
