
package com.eligibility.servlet;

import java.io.IOException;
import java.util.Random;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.eligibility.util.EmailUtility;

@WebServlet("/SendOtpServlet")
public class SendOtpServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)

            throws ServletException, IOException {

        String email =
                request.getParameter("email");

        Random random = new Random();

        int otpNumber =
                100000 + random.nextInt(900000);

        String otp =
                String.valueOf(otpNumber);

        boolean sent =
                EmailUtility.sendOTP(email, otp);

        if(sent){

            HttpSession session =
                    request.getSession();

            session.setAttribute(
                    "otp",
                    otp
            );

            session.setAttribute(
                    "otpTime",
                    System.currentTimeMillis()
            );

            response.getWriter().print(
                    "success"
            );

        } else {

            response.getWriter().print(
                    "failed"
            );
        }
    }
}

