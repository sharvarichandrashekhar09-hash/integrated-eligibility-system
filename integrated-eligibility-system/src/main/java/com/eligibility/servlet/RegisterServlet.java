
package com.eligibility.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;

import com.eligibility.util.DBConnection;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)

            throws ServletException, IOException {

        String employeeType =
                request.getParameter("employee_type");

        String firstName =
                request.getParameter("first_name");

        String middleName =
                request.getParameter("middle_name");

        String surname =
                request.getParameter("surname");

        String gender =
                request.getParameter("gender");

        String dob =
                request.getParameter("dob");

        String email =
                request.getParameter("email");

        String mobile =
                request.getParameter("mobile");

        String password =
                request.getParameter("password");

        String userOtp =
                request.getParameter("otp");

        // Mandatory Validation

        if(employeeType == null ||
           firstName == null ||
           middleName == null ||
           surname == null ||
           gender == null ||
           dob == null ||
           email == null ||
           mobile == null ||
           password == null ||
           userOtp == null ||

           employeeType.trim().isEmpty() ||
           firstName.trim().isEmpty() ||
           middleName.trim().isEmpty() ||
           surname.trim().isEmpty() ||
           gender.trim().isEmpty() ||
           dob.trim().isEmpty() ||
           email.trim().isEmpty() ||
           mobile.trim().isEmpty() ||
           password.trim().isEmpty() ||
           userOtp.trim().isEmpty()) {

            response.getWriter().println(
                "<script>"
                + "alert('All Fields Are Mandatory');"
                + "window.location='auth.jsp';"
                + "</script>"
            );

            return;
        }

        HttpSession session =
                request.getSession();

        String sessionOtp =
                (String) session.getAttribute("otp");

        Long otpTime =
                (Long) session.getAttribute("otpTime");

        // OTP NULL CHECK

        if(sessionOtp == null || otpTime == null){

            response.getWriter().println(
                "<script>"
                + "alert('Please Generate OTP First');"
                + "window.location='auth.jsp';"
                + "</script>"
            );

            return;
        }

        // OTP Expiry

        long currentTime =
                System.currentTimeMillis();

        long difference =
                currentTime - otpTime;

        long tenMinutes =
                10 * 60 * 1000;

        if(difference > tenMinutes){

            response.getWriter().println(
                "<script>"
                + "alert('OTP Expired');"
                + "window.location='auth.jsp';"
                + "</script>"
            );

            return;
        }

        // OTP MATCH

        if(!userOtp.equals(sessionOtp)){

            response.getWriter().println(
                "<script>"
                + "alert('Invalid OTP');"
                + "window.location='auth.jsp';"
                + "</script>"
            );

            return;
        }

        // PASSWORD HASH

        String hashedPassword =
                BCrypt.hashpw(
                        password,
                        BCrypt.gensalt()
                );

        try {

            Connection con =
                    DBConnection.getConnection();

            String sql =
                "INSERT INTO registration "
                + "(employee_type,"
                + "first_name,"
                + "middle_name,"
                + "surname,"
                + "gender,"
                + "dob,"
                + "email,"
                + "mobile,"
                + "password,"
                + "status)"
                + " VALUES(?,?,?,?,?,?,?,?,?,?)";

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ps.setString(1, employeeType);
            ps.setString(2, firstName);
            ps.setString(3, middleName);
            ps.setString(4, surname);
            ps.setString(5, gender);
            ps.setString(6, dob);
            ps.setString(7, email);
            ps.setString(8, mobile);
            ps.setString(9, hashedPassword);

            String status = "PENDING";

            if(employeeType.equalsIgnoreCase("User")){

                status = "APPROVED";
            }

            ps.setString(10, status);

            int row =
                    ps.executeUpdate();

            if(row > 0){

                session.removeAttribute("otp");
                session.removeAttribute("otpTime");

                response.getWriter().println(

                    "<script>"

                    + "alert('Registration Successful');"

                    + "window.location='auth.jsp';"

                    + "</script>"
                );

            } else {

                response.getWriter().println(

                    "<script>"

                    + "alert('Registration Failed');"

                    + "window.location='auth.jsp';"

                    + "</script>"
                );
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.getWriter().println(

                "<script>"

                + "alert('Something Went Wrong');"

                + "window.location='auth.jsp';"

                + "</script>"
            );
        }
    }
}

