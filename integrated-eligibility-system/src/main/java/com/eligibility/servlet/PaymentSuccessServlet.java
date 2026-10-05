package com.eligibility.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.eligibility.util.DBConnection;

@WebServlet("/PaymentSuccessServlet")
public class PaymentSuccessServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            String paymentId =
                    request.getParameter(
                    "paymentId");

            String orderId =
                    request.getParameter(
                    "orderId");

            String applicationId =
                    request.getParameter(
                    "applicationId");

            String userName =
                    request.getParameter(
                    "userName");

            String email =
                    request.getParameter(
                    "email");

            String planId =
                    request.getParameter(
                    "planId");

            String planName =
                    request.getParameter(
                    "planName");

            double amount =
                    Double.parseDouble(
                    request.getParameter(
                    "amount"));

            Connection con =
                    DBConnection.getConnection();

            /* =========================
               TRANSACTIONS TABLE
            ========================= */

            PreparedStatement ps1 =
            con.prepareStatement(

            "INSERT INTO transactions("

            + "application_id,"
            + "plan_id,"
            + "applicant_name,"
            + "user_email,"
            + "payment_id,"
            + "order_id,"
            + "amount,"
            + "payment_method,"
            + "payment_status"

            + ") VALUES(?,?,?,?,?,?,?,?,?)"

            );

            ps1.setInt(
            1,
            Integer.parseInt(
            applicationId)
            );

            ps1.setString(
            2,
            planId
            );

            ps1.setString(
            3,
            userName
            );

            ps1.setString(
            4,
            email
            );

            ps1.setString(
            5,
            paymentId
            );

            ps1.setString(
            6,
            orderId
            );

            ps1.setDouble(
            7,
            amount
            );

            ps1.setString(
            8,
            "RAZORPAY"
            );

            ps1.setString(
            9,
            "SUCCESS"
            );

            ps1.executeUpdate();

            /* =========================
               PAYMENTS TABLE
            ========================= */

            PreparedStatement ps2 =
            con.prepareStatement(

            "INSERT INTO payments("

            + "transaction_id,"
            + "user_name,"
            + "user_email,"
            + "plan_name,"
            + "amount,"
            + "payment_mode,"
            + "payment_status"

            + ") VALUES(?,?,?,?,?,?,?)"

            );

            ps2.setString(
            1,
            paymentId
            );

            ps2.setString(
            2,
            userName
            );

            ps2.setString(
            3,
            email
            );

            ps2.setString(
            4,
            planName
            );

            ps2.setDouble(
            5,
            amount
            );

            ps2.setString(
            6,
            "RAZORPAY"
            );

            ps2.setString(
            7,
            "SUCCESS"
            );

            ps2.executeUpdate();

            /* =========================
               UPDATE APPLICATION
            ========================= */

            String tableName = "";

            if(planId.equals("PLN-001"))
                tableName =
                "snap_applications";

            else if(planId.equals("PLN-002"))
                tableName =
                "ccap_applications";

            else if(planId.equals("PLN-003"))
                tableName =
                "medicaid_applications";

            else if(planId.equals("PLN-004"))
                tableName =
                "medicare_applications";

            else if(planId.equals("PLN-005"))
                tableName =
                "qhp_applications";

            PreparedStatement ps3 =
            con.prepareStatement(

            "UPDATE "

            + tableName +

            " SET payment_status='SUCCESS' "

            + "WHERE application_id=?"

            );

            ps3.setInt(
            1,
            Integer.parseInt(
            applicationId)
            );

            ps3.executeUpdate();

            con.close();

            response.sendRedirect(
            "caseworkerDashboard.jsp"
            );

        }

        catch(Exception e){

            e.printStackTrace();

            response.getWriter().println(

            "<h2>Error : "

            + e.getMessage()

            + "</h2>"

            );

        }

    }

}