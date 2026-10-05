package com.eligibility.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.eligibility.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/FinalRejectServlet")
public class FinalRejectServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int applicationId =
            Integer.parseInt(
            request.getParameter("id"));

            String planId =
            request.getParameter("plan");

            String tableName = "";

            if("PLN-001".equals(planId)){
                tableName = "snap_applications";
            }
            else if("PLN-002".equals(planId)){
                tableName = "ccap_applications";
            }
            else if("PLN-003".equals(planId)){
                tableName = "medicaid_applications";
            }
            else if("PLN-004".equals(planId)){
                tableName = "medicare_applications";
            }
            else if("PLN-005".equals(planId)){
                tableName = "qhp_applications";
            }

            Connection con =
            DBConnection.getConnection();

            PreparedStatement ps =
            con.prepareStatement(

            "UPDATE " + tableName +
            " SET doc_status=?," +
            " verification_status=?," +
            " verification_remark=? " +
            " WHERE application_id=?"

            );

            ps.setString(1,"REJECTED");
            ps.setString(2,"REJECTED");
            ps.setString(3,"Documents Rejected");
            ps.setInt(4,applicationId);

            ps.executeUpdate();

            response.sendRedirect(
            "documentVerification.jsp");

            ps.close();
            con.close();

        }
        catch(Exception e){

            e.printStackTrace();

        }

    }

}