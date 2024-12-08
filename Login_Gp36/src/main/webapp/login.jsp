<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Login Page</title>
</head>
<body>
    <%
        // Check if the form is submitted by looking for username and password parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        boolean isValidUser = false;
        String userType = ""; // Track whether the user is a customer or employee

        if (username != null && password != null) { // Only process login if both username and password are provided
            try {
                // Get the database connection
                ApplicationDB db = new ApplicationDB();
                Connection con = db.getConnection();

                // Check Customers table
                String sqlCustomer = "SELECT * FROM Customers WHERE username = ? AND password = ?";
                PreparedStatement pstmtCustomer = con.prepareStatement(sqlCustomer);
                pstmtCustomer.setString(1, username);
                pstmtCustomer.setString(2, password);

                ResultSet resultCustomer = pstmtCustomer.executeQuery();

                if (resultCustomer.next()) {
                    isValidUser = true;
                    userType = "customer";
                    int customerId = resultCustomer.getInt("customer_id");

                    // Create a session for the user
                    HttpSession userSession = request.getSession();
                    userSession.setAttribute("customer_id", customerId);
                    userSession.setAttribute("username", username);
                    userSession.setAttribute("userType", userType);

                    // Redirect to the Customer Page
                    response.sendRedirect("customerPage.jsp");
                    return; // Stop further execution
                }

                // Check Employees table
                String sqlEmployee = "SELECT * FROM Employees WHERE username = ? AND password = ?";
                PreparedStatement pstmtEmployee = con.prepareStatement(sqlEmployee);
                pstmtEmployee.setString(1, username);
                pstmtEmployee.setString(2, password);

                ResultSet resultEmployee = pstmtEmployee.executeQuery();

                if (resultEmployee.next()) {
                    isValidUser = true;
                    userType = resultEmployee.getString("role"); // Retrieve role (Admin/Customer Representative)
                    int employeeId = resultEmployee.getInt("employee_id"); // Retrieve employee_id

                    // Create a session for the user
                    HttpSession userSession = request.getSession();
                    userSession.setAttribute("employee_id", employeeId); // Store employee_id in session
                    userSession.setAttribute("username", username);
                    userSession.setAttribute("userType", userType);

                    // Redirect based on role
                    if ("Admin".equals(userType)) {
                        response.sendRedirect("adminPage.jsp");
                    } else {
                        response.sendRedirect("repPage.jsp");
                    }
                    return; // Stop further execution
                }

                // Close resources
                resultCustomer.close();
                pstmtCustomer.close();
                resultEmployee.close();
                pstmtEmployee.close();
                db.closeConnection(con);

            } catch (Exception e) {
                out.print("Error: " + e.getMessage());
            }
        }
    %>

    <% if (!isValidUser && username != null && password != null) { %>
        <p>Invalid username or password. Please try again.</p>
    <% } %>

    <!-- Display login form -->
    <form method="post" action="login.jsp">
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" required><br>
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required><br>
        <button type="submit">Login</button>
    </form>

    <a href="register.jsp">Register Here</a>
</body>
</html>
