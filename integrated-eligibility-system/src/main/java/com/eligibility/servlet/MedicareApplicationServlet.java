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

@WebServlet("/MedicareApplicationServlet")
public class MedicareApplicationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            Connection con =
                    DBConnection.getConnection();

            String sql =

            "INSERT INTO medicare_applications("
            + "user_email,"
            + "plan_id,"
            + "full_name,"
            + "mobile,"
            + "aadhaar,"
            + "address,"
            + "indian_citizen,"
            + "age,"
            + "senior_citizen,"
            + "annual_income,"
            + "income_exceed,"
            + "private_insurance,"
            + "regular_treatment,"
            + "chronic_illness,"
            + "illness_type,"
            + "doctor_visit,"
            + "hospitalized,"
            + "regular_medicine,"
            + "medical_expense,"
            + "treatment_support,"
            + "health_checkup,"
            + "hospital_name,"
            + "government_hospital,"
            + "government_scheme,"
            + "medical_bill_difficulty,"
            + "medicine_discount,"
            + "caretaker,"
            + "living_type,"
            + "details_correct,"
            + "verification_agreement,"
            + "update_information,"
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

            ps.setString(1, userEmail);
            ps.setString(2, request.getParameter("plan_id"));
            ps.setString(3, request.getParameter("full_name"));
            ps.setString(4, request.getParameter("mobile"));
            ps.setString(5, request.getParameter("aadhaar"));
            ps.setString(6, request.getParameter("address"));
            ps.setString(7, request.getParameter("indian_citizen"));

            ps.setInt(8,
                    Integer.parseInt(
                    request.getParameter("age")));

            ps.setString(9,
                    request.getParameter("senior_citizen"));

            ps.setString(10,
                    request.getParameter("annual_income"));

            ps.setString(11,
                    request.getParameter("income_exceed"));

            ps.setString(12,
                    request.getParameter("private_insurance"));

            ps.setString(13,
                    request.getParameter("regular_treatment"));

            ps.setString(14,
                    request.getParameter("chronic_illness"));

            ps.setString(15,
                    request.getParameter("illness_type"));

            ps.setString(16,
                    request.getParameter("doctor_visit"));

            ps.setString(17,
                    request.getParameter("hospitalized"));

            ps.setString(18,
                    request.getParameter("regular_medicine"));

            ps.setString(19,
                    request.getParameter("medical_expense"));

            ps.setString(20,
                    request.getParameter("treatment_support"));

            ps.setString(21,
                    request.getParameter("health_checkup"));

            ps.setString(22,
                    request.getParameter("hospital_name"));

            ps.setString(23,
                    request.getParameter("government_hospital"));

            ps.setString(24,
                    request.getParameter("government_scheme"));

            ps.setString(25,
                    request.getParameter("medical_bill_difficulty"));

            ps.setString(26,
                    request.getParameter("medicine_discount"));

            ps.setString(27,
                    request.getParameter("caretaker"));

            ps.setString(28,
                    request.getParameter("living_type"));

            ps.setString(29,
                    request.getParameter("details_correct"));

            ps.setString(30,
                    request.getParameter("verification_agreement"));

            ps.setString(31,
                    request.getParameter("update_information"));

            ps.setString(32,
                    request.getParameter("reason"));

            ps.setString(33, "PENDING");
            ps.setString(34, "PENDING");
            

            /* AI LOGIC */

            int aiScore = 0;

            int age =
            Integer.parseInt(
            request.getParameter("age"));

            double income =
            Double.parseDouble(
            request.getParameter("annual_income"));

            String chronicIllness =
            request.getParameter("chronic_illness");

            if(age >= 60){
                aiScore += 40;
            }

            if(income <= 300000){
                aiScore += 40;
            }

            if("Yes".equalsIgnoreCase(chronicIllness)){
                aiScore += 20;
            }

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

            ps.setInt(35, aiScore);

            ps.setString(36, aiStatus);

            ps.setString(37, "NOT_REQUIRED");

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
                    + "&plan=PLN-004"

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
                "<h3>Application Failed</h3>");

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