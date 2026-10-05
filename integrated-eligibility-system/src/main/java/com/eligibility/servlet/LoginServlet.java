
package com.eligibility.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;

import com.eligibility.util.DBConnection;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)

            throws ServletException, IOException {
    	response.getWriter().println("LoginServlet Working");
        String employeeType =
                request.getParameter(
                        "employee_type");

        String email =
                request.getParameter(
                        "email");

        String password =
                request.getParameter(
                        "password");

        String captchaInput =
                request.getParameter(
                        "captchaInput");

        HttpSession session =
                request.getSession();

        try {

            Connection con =
                    DBConnection.getConnection();

            String sql =
                    "SELECT * FROM registration "
                    + "WHERE email=? "
                    + "AND employee_type=?";

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ps.setString(1, email);
            ps.setString(2, employeeType);

            ResultSet rs =
                    ps.executeQuery();

            // USER EXISTS

            if(rs.next()){

                String dbPassword =
                        rs.getString(
                                "password");

                String status =
                        rs.getString(
                                "status");

                int attempts =
                        rs.getInt(
                                "login_attempts");

                // MAX ATTEMPTS

                if(attempts >= 3){

                    response.getWriter().println(

                        "<script>"

                        + "alert('Account Locked After 3 Failed Attempts');"

                        + "window.location='auth.jsp';"

                        + "</script>"
                    );

                    return;
                }

                // STATUS CHECK

                if(employeeType.equalsIgnoreCase("CaseWorker")
                        && !status.equalsIgnoreCase("APPROVED")){

                    response.getWriter().println(

                        "<script>"

                        + "alert('Case Worker Approval Pending');"

                        + "window.location='auth.jsp';"

                        + "</script>"
                    );

                    return;
                }

                // CAPTCHA FOR ADMIN

                if(employeeType.equalsIgnoreCase("Admin")){

                    String generatedCaptcha =
                            (String) session.getAttribute(
                                    "captcha");

                    if(generatedCaptcha == null ||
                            !generatedCaptcha.equals(captchaInput)){

                        response.getWriter().println(

                            "<script>"

                            + "alert('Invalid Captcha');"

                            + "window.location='auth.jsp';"

                            + "</script>"
                        );

                        return;
                    }
                }

                // PASSWORD VERIFY

                boolean match =
                        BCrypt.checkpw(
                                password,
                                dbPassword);

                if(match){

                	 System.out.println("LOGIN EMAIL = " + email);
                     System.out.println("LOGIN ROLE = " + employeeType);  // RESET ATTEMPTS

                    String resetSql =
                            "UPDATE registration "
                            + "SET login_attempts=0 "
                            + "WHERE email=?";

                    PreparedStatement resetPs =
                            con.prepareStatement(
                                    resetSql);

                    resetPs.setString(1, email);

                    resetPs.executeUpdate();

                    // SESSION

                    session.setAttribute(
                            "userEmail",
                            email);

                    session.setAttribute(
                            "employeeType",
                            employeeType);

                    // REDIRECT
                   
                    if(employeeType.equalsIgnoreCase("User")){

                        response.sendRedirect(
                                "userDashboard.jsp");

                    } else if(employeeType.equalsIgnoreCase("Admin")){

                        response.sendRedirect(
                                "adminDashboard.jsp");

                    } else if(employeeType.equalsIgnoreCase("CaseWorker")){

                        response.sendRedirect(
                                "caseworkerDashboard.jsp");
                    }

                } else {

                    // INCREASE ATTEMPTS

                    attempts++;

                    String updateSql =
                            "UPDATE registration "
                            + "SET login_attempts=? "
                            + "WHERE email=?";

                    PreparedStatement updatePs =
                            con.prepareStatement(
                                    updateSql);

                    updatePs.setInt(1, attempts);

                    updatePs.setString(2, email);

                    updatePs.executeUpdate();

                    response.getWriter().println(

                        "<script>"

                        + "alert('Invalid Password');"

                        + "window.location='auth.jsp';"

                        + "</script>"
                    );
                }

            } else {

                response.getWriter().println(

                    "<script>"

                    + "alert('User Not Registered');"

                    + "window.location='auth.jsp';"

                    + "</script>"
                );
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.getWriter().println(

                "<script>"

                + "alert('Login Failed');"

                + "window.location='auth.jsp';"

                + "</script>"
            );
        }
    }
}

