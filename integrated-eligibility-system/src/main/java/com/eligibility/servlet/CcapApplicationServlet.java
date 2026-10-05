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

@WebServlet("/CcapApplicationServlet")
public class CcapApplicationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            Connection con =
                    DBConnection.getConnection();

            String sql =

                    "INSERT INTO ccap_applications("
                    + "user_email,"
                    + "plan_id,"
                    + "full_name,"
                    + "mobile,"
                    + "aadhaar,"
                    + "address,"
                    + "district,"
                    + "city,"
                    + "state,"
                    + "indian_citizen,"
                    + "annual_income,"
                    + "children_count,"
                    + "child_name,"
                    + "child_dob,"
                    + "child_age,"
                    + "single_parent,"
                    + "both_parents_working,"
                    + "vaccinations,"
                    + "health_problem,"
                    + "verification_agreement,"
                    + "details_correct,"
                    + "update_information,"
                    + "reason,"
                    + "status,"
                    + "payment_status,"
                    + "ai_score,"
                    + "ai_status,"
                    + "doc_status"
                    + ") VALUES("
                    + "?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?"
                    + ")";

            PreparedStatement ps =
                    con.prepareStatement(
                    sql,
                    Statement.RETURN_GENERATED_KEYS
                    );

            String userEmail = (String) request.getSession()
                    .getAttribute("userEmail");

            ps.setString(1,  userEmail);
            ps.setString(2,  request.getParameter("plan_id"));
            ps.setString(3,  request.getParameter("full_name"));
            ps.setString(4,  request.getParameter("mobile"));
            ps.setString(5,  request.getParameter("aadhaar"));
            ps.setString(6,  request.getParameter("address"));
            ps.setString(7,  request.getParameter("district"));
            ps.setString(8,  request.getParameter("city"));
            ps.setString(9,  request.getParameter("state"));
            ps.setString(10, request.getParameter("indian_citizen"));
            ps.setString(11, request.getParameter("annual_income"));

            ps.setInt(
                    12,
                    Integer.parseInt(
                    request.getParameter("children_count"))
            );

            ps.setString(13, request.getParameter("child_name"));
            ps.setString(14, request.getParameter("child_dob"));
            ps.setString(15, request.getParameter("child_age"));
            ps.setString(16, request.getParameter("single_parent"));
            ps.setString(17, request.getParameter("both_parents_working"));
            ps.setString(18, request.getParameter("vaccinations"));
            ps.setString(19, request.getParameter("health_problem"));
            ps.setString(20, request.getParameter("verification_agreement"));
            ps.setString(21, request.getParameter("details_correct"));
            ps.setString(22, request.getParameter("update_information"));

            String[] reasons =
                    request.getParameterValues("reason");

            String reason = "Not Selected";

            if(reasons != null && reasons.length > 0){
                reason = String.join(", ", reasons);
            }

            ps.setString(23, reason);
            ps.setString(24, "PENDING");
            ps.setString(25, "PENDING");

            /* AI LOGIC */

            int aiScore = 0;

            double income =
            Double.parseDouble(
            request.getParameter("annual_income"));

            String singleParent =
            request.getParameter("single_parent");

            String bothParentsWorking =
            request.getParameter("both_parents_working");

            String childDob =
            request.getParameter("child_dob");

            // Check income eligibility
            if(income <= 200000){
                aiScore += 40;
            }

            // Check child age eligibility (6 months to 6 years)
            if(childDob != null && !childDob.isEmpty()){
                java.time.LocalDate dob =
                java.time.LocalDate.parse(childDob);
                java.time.LocalDate today =
                java.time.LocalDate.now();
                long months =
                java.time.temporal.ChronoUnit.MONTHS.between(dob, today);
                if(months >= 6 && months <= 72){
                    aiScore += 30;
                }
            }

            // Check parent condition
            if("Yes".equalsIgnoreCase(singleParent)
            || "Yes".equalsIgnoreCase(bothParentsWorking)){
                aiScore += 30;
            }

            String aiStatus;

            if(aiScore >= 80){
                aiStatus = "HIGH ELIGIBILITY";
            }
            else if(aiScore >= 50){
                aiStatus = "MEDIUM ELIGIBILITY";
            }
            else{
                aiStatus = "LOW ELIGIBILITY";
            }

            ps.setInt(26,    aiScore);
            ps.setString(27, aiStatus);
            ps.setString(28, "NOT_REQUIRED");

            int result = ps.executeUpdate();

            if(result > 0){

                ResultSet keys =
                ps.getGeneratedKeys();

                int applicationId = 0;

                if(keys.next()){

                    applicationId =
                    keys.getInt(1);

                    response.sendRedirect(
                    "transaction.jsp?id="
                    + applicationId
                    + "&plan=PLN-002"
                    );

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
                "<h3>CCAP Application Failed</h3>"
                );

            }

            ps.close();
            con.close();

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
