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

@WebServlet("/SendRequestServlet")
public class SendRequestServlet extends HttpServlet {

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
            String requiredDocs = "";

            if("PLN-001".equals(planId)) {

                tableName = "snap_applications";

                requiredDocs =
                "Aadhaar Card, Income Certificate, Ration Card, Address Proof";

            }
            else if("PLN-002".equals(planId)) {

                tableName = "ccap_applications";

                requiredDocs =
                "Aadhaar Card, Birth Certificate, Income Certificate";

            }
            else if("PLN-003".equals(planId)) {

                tableName = "medicaid_applications";

                requiredDocs =
                "Aadhaar Card, Income Certificate, Medical Certificate";

            }
            else if("PLN-004".equals(planId)) {

                tableName = "medicare_applications";

                requiredDocs =
                "Aadhaar Card, Age Proof, Income Certificate, Medical Certificate";

            }
            else if("PLN-005".equals(planId)) {

                tableName = "qhp_applications";

                requiredDocs =
                "Aadhaar Card, PAN Card, Income Certificate";

            }

            Connection con =
            DBConnection.getConnection();

            PreparedStatement ps =
            con.prepareStatement(
            		"UPDATE " + tableName +
            		" SET required_docs=?, " +
            		" status='APPROVED', " +
            		" doc_status='REQUESTED', " +
            		" request_date=NOW() " +
            		" WHERE application_id=?");

            ps.setString(1, requiredDocs);
            ps.setInt(2, applicationId);

            int result = ps.executeUpdate();

            if(result > 0) {

                response.sendRedirect(
                "caseworkerCases.jsp");

            } else {

                response.getWriter().println(
                "Request Not Sent");

            }

            ps.close();
            con.close();

        }
        catch(Exception e) {

            e.printStackTrace();

        }

    }

}