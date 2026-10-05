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

@WebServlet("/QhpApplicationServlet")
public class QhpApplicationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            Connection con =
                    DBConnection.getConnection();

            String sql =

            "INSERT INTO qhp_applications("
            + "user_email,"
            + "plan_id,"
            + "full_name,"
            + "dob,"
            + "gender,"
            + "mobile,"
            + "email,"
            + "aadhaar,"
            + "pan_card,"
            + "address,"
            + "state_name,"
            + "marital_status,"
            + "dependent_members,"
            + "occupation,"
            + "employed,"
            + "monthly_income,"
            + "annual_income,"
            + "employer_insurance,"
            + "employment_sector,"
            + "major_illness,"
            + "hospitalized,"
            + "chronic_disease,"
            + "regular_medication,"
            + "smoking_alcohol,"
            + "maternity_treatment,"
            + "surgery_history,"
            + "private_insurance,"
            + "selected_plan,"
            + "premium_amount,"
            + "family_plan,"
            + "additional_schemes,"
            + "reason,"
            + "status,"
            + "payment_status,"
            + "ai_score,"
            + "ai_status,"
            + "doc_status"
            + ") VALUES("
            + "?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?"
            + ")";

            PreparedStatement ps =
                    con.prepareStatement(
                    sql,
                    Statement.RETURN_GENERATED_KEYS);

            String userEmail = (String) request.getSession()
                    .getAttribute("userEmail");


            ps.setString(2,
                    request.getParameter("plan_id"));

            ps.setString(3,
                    request.getParameter("full_name"));

            ps.setString(4,
                    request.getParameter("dob"));

            ps.setString(5,
                    request.getParameter("gender"));

            ps.setString(6,
                    request.getParameter("mobile"));

            ps.setString(7,
                    request.getParameter("email"));

            ps.setString(8,
                    request.getParameter("aadhaar"));

            ps.setString(9,
                    request.getParameter("pan_card"));

            ps.setString(10,
                    request.getParameter("address"));

            ps.setString(11,
                    request.getParameter("state_name"));

            ps.setString(12,
                    request.getParameter("marital_status"));

            ps.setInt(
                    13,
                    Integer.parseInt(
                    request.getParameter(
                    "dependent_members"))
            );

            ps.setString(14,
                    request.getParameter("occupation"));

            ps.setString(15,
                    request.getParameter("employed"));

            ps.setString(16,
                    request.getParameter("monthly_income"));

            ps.setString(17,
                    request.getParameter("annual_income"));

            ps.setString(18,
                    request.getParameter("employer_insurance"));

            ps.setString(19,
                    request.getParameter("employment_sector"));

            ps.setString(20,
                    request.getParameter("major_illness"));

            ps.setString(21,
                    request.getParameter("hospitalized"));

            ps.setString(22,
                    request.getParameter("chronic_disease"));

            ps.setString(23,
                    request.getParameter("regular_medication"));

            ps.setString(24,
                    request.getParameter("smoking_alcohol"));

            ps.setString(25,
                    request.getParameter("maternity_treatment"));

            ps.setString(26,
                    request.getParameter("surgery_history"));

            ps.setString(27,
                    request.getParameter("private_insurance"));

            ps.setString(28,
                    request.getParameter("selected_plan"));

            ps.setString(29,
                    request.getParameter("premium_amount"));

            ps.setString(30,
                    request.getParameter("family_plan"));

            ps.setString(31,
                    request.getParameter("additional_schemes"));

            ps.setString(32,
                    request.getParameter("reason"));

            ps.setString(33,
                    "PENDING");

            ps.setString(34,
                    "PENDING");

            /* AI LOGIC */

            int aiScore = 0;

            double income =
            Double.parseDouble(
            request.getParameter("annual_income"));

            String selectedPlan =
            request.getParameter("selected_plan");

            if(income >= 300000 &&
               income <= 800000){

                aiScore += 50;
            }

            if(selectedPlan != null &&
               !selectedPlan.isEmpty()){

                aiScore += 25;
            }

            aiScore += 25; // willing to pay premium

            String aiStatus;

            if(aiScore >= 80){

                aiStatus =
                "HIGH ELIGIBILITY";

            }
            else if(aiScore >= 50){

                aiStatus =
                "MEDIUM ELIGIBILITY";

            }
            else{

                aiStatus =
                "LOW ELIGIBILITY";

            }

            ps.setInt(35,
                    aiScore);

            ps.setString(36,
                    aiStatus);

            ps.setString(37,
                    "NOT_REQUIRED");
            int result =
                    ps.executeUpdate();

            if(result > 0){

                ResultSet keys =
                ps.getGeneratedKeys();

                if(keys.next()){

                    int applicationId =
                    keys.getInt(1);

                    response.sendRedirect(

                    "transaction.jsp?id="
                    + applicationId
                    + "&plan=PLN-005"

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

                "<h3>Application Failed</h3>"

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