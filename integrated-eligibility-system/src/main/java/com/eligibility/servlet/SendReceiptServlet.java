package com.eligibility.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.eligibility.util.DBConnection;
import com.eligibility.util.EmailUtility;

@WebServlet("/SendReceiptServlet")
public class SendReceiptServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(

            HttpServletRequest request,

            HttpServletResponse response)

            throws ServletException, IOException {

        try {

            String txnId =

            request.getParameter(
            "txn"
            );

            Connection con =
            DBConnection.getConnection();

            PreparedStatement ps =

            con.prepareStatement(

            "SELECT * FROM payments "
            + "WHERE transaction_id=?"

            );

            ps.setString(
            1,
            txnId
            );

            ResultSet rs =
            ps.executeQuery();

            if(rs.next()){

                String email =

                rs.getString(
                "user_email"
                );

                String userName =

                rs.getString(
                "user_name"
                );

                String planName =

                rs.getString(
                "plan_name"
                );

                String amount =

                rs.getString(
                "amount"
                );

                String paymentMode =

                rs.getString(
                "payment_mode"
                );

                String paymentStatus =

                rs.getString(
                "payment_status"
                );

                String paymentDate =

                rs.getString(
                "payment_date"
                );

                String message =

                "Dear "
                + userName

                + "\n\n"

                + "Your payment has been received successfully."

                + "\n\n"

                + "Transaction ID : "
                + txnId

                + "\n"

                + "Plan Name : "
                + planName

                + "\n"

                + "Amount : ₹"
                + amount

                + "\n"

                + "Payment Mode : "
                + paymentMode

                + "\n"

                + "Status : "
                + paymentStatus

                + "\n"

                + "Payment Date : "
                + paymentDate

                + "\n\n"

                + "Thank you for using"

                + "\n"

                + "Integrated Eligibility System";

                EmailUtility.sendMail(

                email,

                "Payment Receipt",

                message

                );

            }

            rs.close();
            ps.close();
            con.close();

            response.sendRedirect(
            "payments.jsp"
            );

        }

        catch(Exception e){

            e.printStackTrace();

            response.getWriter().println(

            "<h3>Error : "

            + e.getMessage()

            + "</h3>"

            );

        }

    }

}