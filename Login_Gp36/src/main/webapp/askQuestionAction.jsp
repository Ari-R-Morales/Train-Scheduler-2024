<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="com.cs336.pkg.*" %>
<%@ page import="java.io.*,java.sql.*" %>

<%
    // Get the question text from the form
    String questionText = request.getParameter("questionText");

    // Validate session and get customer ID
    session = request.getSession(false);
    if (session == null || session.getAttribute("customer_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    try {
        // Retrieve the customer ID from session
        int customerId = (Integer) session.getAttribute("customer_id");

        // Establish a database connection
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();

        // Insert the new question into the Questions table
        String sql = "INSERT INTO Questions (customer_id, question_text, created_at) VALUES (?, ?, NOW())";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setInt(1, customerId);
        pstmt.setString(2, questionText);

        int rowsInserted = pstmt.executeUpdate();

        if (rowsInserted > 0) {
            out.println("<p>Your question has been successfully submitted! Our customer service will respond shortly.</p>");
        } else {
            out.println("<p>Failed to submit your question. Please try again later.</p>");
        }

        // Close the database resources
        pstmt.close();
        db.closeConnection(con);

    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }
%>

<p><a href="customerPage.jsp">Back to Dashboard</a></p>
