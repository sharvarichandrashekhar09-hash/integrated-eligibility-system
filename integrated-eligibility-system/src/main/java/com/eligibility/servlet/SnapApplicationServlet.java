package com.eligibility.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.eligibility.util.DBConnection;

@WebServlet("/SnapApplicationServlet")
public class SnapApplicationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            Connection con =
                    DBConnection.getConnection();

            String sql =
                    "INSERT INTO snap_applications("
                    + "user_email,"
                    + "plan_id,"
                    + "full_name,"
                    + "dob,"
                    + "gender,"
                    + "mobile,"
                    + "aadhaar,"
                    + "address,"
                    + "state,"
                    + "district,"
                    + "city,"
                    + "family_members,"
                    + "living_together,"
                    + "annual_income,"
                    + "government_job,"
                    + "ration_card,"
                    + "children_count,"
                    + "senior_citizen,"
                    + "disabled_member,"
                    + "monthly_expense,"
                    + "house_type,"
                    + "details_correct,"
                    + "government_verification,"
                    + "update_information,"
                    + "reason,"
                    + "status,"
                    + "payment_status,"
                    + "ai_score,"
                    + "ai_status,"
                    + "ai_remark"
                    + ") VALUES("
                    + "?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?"
                    + ")";

            PreparedStatement ps =
                    con.prepareStatement(
                    sql,
                    Statement.RETURN_GENERATED_KEYS);

            String userEmail = (String) request.getSession()
                    .getAttribute("userEmail");

            ps.setString(1,  userEmail);
            ps.setString(2,  request.getParameter("plan_id"));
            ps.setString(3,  request.getParameter("full_name"));
            ps.setString(4,  request.getParameter("dob"));
            ps.setString(5,  request.getParameter("gender"));
            ps.setString(6,  request.getParameter("mobile"));
            ps.setString(7,  request.getParameter("aadhaar"));
            ps.setString(8,  request.getParameter("address"));
            ps.setString(9,  request.getParameter("state"));
            ps.setString(10, request.getParameter("district"));
            ps.setString(11, request.getParameter("city"));
            ps.setString(12, request.getParameter("family_members"));
            ps.setString(13, request.getParameter("living_together"));
            ps.setString(14, request.getParameter("annual_income"));
            ps.setString(15, request.getParameter("government_job"));
            ps.setString(16, request.getParameter("ration_card"));

            String childrenCount =
                    request.getParameter("children_count");

            ps.setInt(
                    17,
                    (childrenCount == null ||
                     childrenCount.isEmpty())
                    ? 0
                    : Integer.parseInt(childrenCount)
            );

            ps.setString(18, request.getParameter("senior_citizen"));
            ps.setString(19, request.getParameter("disabled_member"));
            ps.setString(20, request.getParameter("monthly_expense"));
            ps.setString(21, request.getParameter("house_type"));
            ps.setString(22, request.getParameter("details_correct"));
            ps.setString(23, request.getParameter("government_verification"));
            ps.setString(24, request.getParameter("update_information"));

            String[] reasons =
                    request.getParameterValues("reason");

            String reason = "Not Selected";

            if(reasons != null && reasons.length > 0){
                reason = String.join(", ", reasons);
            }

            ps.setString(25, reason);
            ps.setString(26, "PENDING");
            ps.setString(27, "PENDING");

            /* AI LOGIC */

            int aiScore = 0;

            double income =
            Double.parseDouble(
            request.getParameter("annual_income"));

            if(income <= 250000){
                aiScore += 40;
            }

            int familyMembers =
            Integer.parseInt(
            request.getParameter("family_members"));

            if(familyMembers >= 4){
                aiScore += 30;
            }

            String govtJob =
            request.getParameter("government_job");

            if("No".equalsIgnoreCase(govtJob)){
                aiScore += 30;
            }

            String aiStatus = "";
            String aiRemark = "";

            if(aiScore >= 80){
                aiStatus = "HIGH ELIGIBILITY";
                aiRemark = "APPROVE";
            }
            else if(aiScore >= 50){
                aiStatus = "MEDIUM ELIGIBILITY";
                aiRemark = "REVIEW";
            }
            else{
                aiStatus = "LOW ELIGIBILITY";
                aiRemark = "REJECT";
            }

            ps.setInt(28,    aiScore);
            ps.setString(29, aiStatus);
            ps.setString(30, aiRemark);

            int result = ps.executeUpdate();

            if(result > 0){

                ResultSet keys =
                        ps.getGeneratedKeys();

                if(keys.next()){

                    int applicationId =
                            keys.getInt(1);

                    response.sendRedirect(
                            "transaction.jsp?id="
                            + applicationId
                            + "&plan=PLN-001");

                }
                else{

                    response.getWriter().println(
                    "<h3>Application Saved But Application ID Not Generated</h3>"
                    );

                }

                keys.close();

            }
            else{

                response.getWriter().println(
                        "<h3>Application Submission Failed</h3>");

            }

            ps.close();
            con.close();

        }
        catch(Exception e){

            e.printStackTrace();

            response.getWriter().println(
                    "<h3>Error : "
                    + e.getMessage()
                    + "</h3>");
        }
    }
}
