package com.eligibility.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import com.eligibility.util.DBConnection;

@WebServlet("/AdminProvideBenefitServlet")
public class AdminProvideBenefitServlet extends HttpServlet {

    // ── Email credentials ─────────────────────────────────────
    private static final String FROM_EMAIL    = "your_email@gmail.com";   // change this
    private static final String FROM_PASSWORD =
        System.getenv("EMAIL_APP_PASSWORD");
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // ── 1. Read parameters from distribution.jsp form ─────
        String appId         = request.getParameter("application_id");
        String planId        = request.getParameter("plan_id");
        String userEmail     = request.getParameter("user_email");
        String fullName      = request.getParameter("full_name");
        String planName      = request.getParameter("plan_name");
        String familyMembers = request.getParameter("family_members");
        String annualIncome  = request.getParameter("annual_income");
        String accountNo     = request.getParameter("account_no");
        String ifsc          = request.getParameter("ifsc");
        String benefitAmount = "";
        String collectionCenter = "";
        String cardNumber = "";

        // ── 2. Pick correct table ─────────────────────────────
        String table = "";
        switch (planId.trim()) {
            case "PLN-001": table = "snap_applications";     break;
            case "PLN-002": table = "ccap_applications";     break;
            case "PLN-003": table = "medicaid_applications"; break;
            case "PLN-004": table = "medicare_applications"; break;
            case "PLN-005": table = "qhp_applications";      break;
            default:
                response.sendRedirect("distribution.jsp?error=unknownplan");
                return;
        }

        // ── 3. Calculate benefit details per plan ─────────────
        String benefitDetails   = "";
        double installmentAmount = 0.0;
        String selectedPlan     = "";
        int    subsidyPercent   = 0;

        int fam = 1;
        try { fam = Integer.parseInt(familyMembers.trim()); }
        catch (Exception e) { fam = 1; }

        long income = 0;
        try { income = Long.parseLong(annualIncome.replaceAll("[^0-9]", "")); }
        catch (Exception e) { income = 0; }

        switch (planId.trim()) {

            case "PLN-001": // SNAP
                int rice  = fam * 5;
                int wheat = fam * 3;
                benefitDetails =
                    "Rice: "  + rice  + " kg | " +
                    "Wheat: " + wheat + " kg | " +
                    "Sugar: 1 kg | Oil: 1 Litre";
                break;

            case "PLN-002": // CCAP
                benefitDetails =
                    "Daycare at nearest Anganwadi | " +
                    "Nutritional meals for child | " +
                    "Basic health checkups | " +
                    "Vaccination support";
                break;

            case "PLN-003": // MEDICAID
                benefitDetails =
                    "Free treatment up to Rs.5,00,000/year | " +
                    "Hospitalization & surgeries covered | " +
                    "Cashless treatment at empaneled hospitals | " +
                    "Health Card issued";
                break;

            case "PLN-004": // MEDICARE
                benefitDetails =
                    "Free/subsidized senior treatment | " +
                    "Regular health checkups | " +
                    "Medicine discount coupons | " +
                    "Priority hospital treatment";
                break;

            case "PLN-005": // QHP - fetch selected_plan from DB
                Connection conQ = null;
                PreparedStatement psQ = null;
                ResultSet rsQ = null;
                try {
                    conQ = DBConnection.getConnection();
                    psQ  = conQ.prepareStatement(
                        "SELECT selected_plan, annual_income " +
                        "FROM qhp_applications WHERE application_id = ?"
                    );
                    psQ.setInt(1, Integer.parseInt(appId.trim()));
                    rsQ = psQ.executeQuery();

                    if (rsQ.next()) {
                        selectedPlan = rsQ.getString("selected_plan");
                        String dbIncome = rsQ.getString("annual_income");
                        try {
                            income = Long.parseLong(
                                dbIncome.replaceAll("[^0-9]", "")
                            );
                        } catch (Exception ex) { income = 0; }
                    }
                } catch (SQLException ex) {        // ← ADD THIS CATCH
                    ex.printStackTrace();
                    selectedPlan = "";
                    income = 0;
                } finally {
                    try { if (rsQ  != null) rsQ.close();  } catch (Exception ex) {}
                    try { if (psQ  != null) psQ.close();  } catch (Exception ex) {}
                    try { if (conQ != null) conQ.close(); } catch (Exception ex) {}
                }
                // Base premium
                double basePremium = 0;
                if      ("Basic".equalsIgnoreCase(selectedPlan))    basePremium = 500;
                else if ("Standard".equalsIgnoreCase(selectedPlan)) basePremium = 800;
                else if ("Premium".equalsIgnoreCase(selectedPlan))  basePremium = 1200;

                // Subsidy
                if      (income <= 500000) subsidyPercent = 50;
                else if (income <= 800000) subsidyPercent = 20;

                installmentAmount = basePremium - (basePremium * subsidyPercent / 100.0);

                benefitDetails =
                    "Plan: "           + selectedPlan      + " | " +
                    "Base Premium: Rs."+ (int)basePremium  + "/month | " +
                    "Subsidy: "        + subsidyPercent    + "% | " +
                    "You Pay: Rs."     + (int)installmentAmount + "/month";
                break;
        }

        // ── 4. DB operations ──────────────────────────────────
        Connection con = null;
        PreparedStatement ps1 = null;
        PreparedStatement ps2 = null;

        try {
            con = DBConnection.getConnection();

            // 4a. INSERT into distributed_benefits
            String insertSQL =
                "INSERT INTO distributed_benefits " +
                "(application_id, user_name, user_email, plan_name, " +
                " benefit_details, installment_amount, installment_start_date, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

            ps1 = con.prepareStatement(insertSQL);
            ps1.setString(1, appId);
            ps1.setString(2, fullName);
            ps1.setString(3, userEmail);
            ps1.setString(4, planName);
            ps1.setString(5, benefitDetails);
            ps1.setDouble(6, installmentAmount);
            ps1.setString(7, LocalDate.now().toString());
            ps1.setString(8, "ACTIVE");
            ps1.executeUpdate();

            // 4b. UPDATE benefit_status = 'PROVIDED' in plan table
            String updateSQL =
                "UPDATE " + table +
                " SET benefit_status = 'PROVIDED'" +
                " WHERE application_id = ?";

            ps2 = con.prepareStatement(updateSQL);
            ps2.setInt(1, Integer.parseInt(appId.trim()));
            ps2.executeUpdate();

            // ── 5. Send email to user ─────────────────────────
            sendBenefitEmail(
                userEmail, fullName, planName,
                benefitDetails, appId,
                installmentAmount, subsidyPercent, selectedPlan
            );

            // ── 6. Redirect back with success ─────────────────
            response.sendRedirect("distribution.jsp?success=1");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("distribution.jsp?error=" + e.getMessage());

        } finally {
            try { if (ps1 != null) ps1.close(); } catch (Exception ex) {}
            try { if (ps2 != null) ps2.close(); } catch (Exception ex) {}
            try { if (con != null) con.close(); } catch (Exception ex) {}
        }
    }

    // ── EMAIL METHOD ──────────────────────────────────────────
    private void sendBenefitEmail(
            String toEmail, String name, String planName,
            String benefitDetails, String appId,
            double installmentAmount, int subsidyPercent,
            String selectedPlan) {

        try {
            Properties props = new Properties();
            props.put("mail.smtp.host",            "smtp.gmail.com");
            props.put("mail.smtp.port",            "587");
            props.put("mail.smtp.auth",            "true");
            props.put("mail.smtp.starttls.enable", "true");

            Session mailSession = Session.getInstance(props,
                new Authenticator() {
                    protected PasswordAuthentication
                    getPasswordAuthentication() {
                        return new PasswordAuthentication(
                            FROM_EMAIL, FROM_PASSWORD
                        );
                    }
                }
            );

            MimeMessage msg = new MimeMessage(mailSession);
            msg.setFrom(new InternetAddress(FROM_EMAIL));
            msg.setRecipient(
                Message.RecipientType.TO,
                new InternetAddress(toEmail)
            );
            msg.setSubject(
                "Your Benefit Has Been Activated – " + planName
            );

            // ── Build email body ──────────────────────────────
            String qhpExtra = "";
            if ("QHP".equalsIgnoreCase(planName) && installmentAmount > 0) {
                qhpExtra =
                    "<tr>" +
                    "  <td style='padding:8px;color:#9ca3af;'>Selected Plan</td>" +
                    "  <td style='padding:8px;color:white;font-weight:bold;'>"
                        + selectedPlan + "</td>" +
                    "</tr>" +
                    "<tr>" +
                    "  <td style='padding:8px;color:#9ca3af;'>Government Subsidy</td>" +
                    "  <td style='padding:8px;color:#22c55e;font-weight:bold;'>"
                        + subsidyPercent + "% OFF</td>" +
                    "</tr>" +
                    "<tr>" +
                    "  <td style='padding:8px;color:#9ca3af;'>Your Monthly Premium</td>" +
                    "  <td style='padding:8px;color:#ff7b00;font-weight:bold;'>₹"
                        + (int)installmentAmount + "/month</td>" +
                    "</tr>";
            }

            String body =
                "<div style='background:#070b16;padding:40px;font-family:Arial,sans-serif;'>" +

                "  <div style='max-width:600px;margin:auto;" +
                "              background:#111827;border-radius:20px;overflow:hidden;'>" +

                "    <div style='background:#ff7b00;padding:30px;text-align:center;'>" +
                "      <h1 style='color:white;margin:0;font-size:28px;'>🎁 Benefit Activated!</h1>" +
                "    </div>" +

                "    <div style='padding:30px;'>" +

                "      <p style='color:#9ca3af;font-size:15px;margin-bottom:25px;'>" +
                "        Dear <strong style='color:white;'>" + name + "</strong>," +
                "        <br><br>" +
                "        Your application has been reviewed and approved by the admin." +
                "        Your benefit is now <strong style='color:#22c55e;'>ACTIVE</strong>." +
                "      </p>" +

                "      <table style='width:100%;border-collapse:collapse;" +
                "                    background:#0f172a;border-radius:12px;overflow:hidden;" +
                "                    margin-bottom:25px;'>" +
                "        <tr>" +
                "          <td style='padding:8px;color:#9ca3af;'>Application ID</td>" +
                "          <td style='padding:8px;color:white;font-weight:bold;'>#" + appId + "</td>" +
                "        </tr>" +
                "        <tr style='background:#1e293b;'>" +
                "          <td style='padding:8px;color:#9ca3af;'>Plan</td>" +
                "          <td style='padding:8px;color:#ff7b00;font-weight:bold;'>" + planName + "</td>" +
                "        </tr>" +
                "        <tr>" +
                "          <td style='padding:8px;color:#9ca3af;'>Valid From</td>" +
                "          <td style='padding:8px;color:white;font-weight:bold;'>" + LocalDate.now() + "</td>" +
                "        </tr>" +
                "        <tr style='background:#1e293b;'>" +
                "          <td style='padding:8px;color:#9ca3af;'>Valid Until</td>" +
                "          <td style='padding:8px;color:white;font-weight:bold;'>" + LocalDate.now().plusYears(1) + "</td>" +
                "        </tr>" +
                qhpExtra +
                "      </table>" +

                "      <div style='background:#0f172a;border-left:4px solid #ff7b00;" +
                "                  border-radius:8px;padding:18px;margin-bottom:25px;'>" +
                "        <p style='color:#ff7b00;font-weight:bold;margin-bottom:10px;'>Benefits Entitled:</p>" +
                "        <p style='color:#fcd34d;font-size:14px;line-height:1.8;'>" +
                           benefitDetails.replace("|", "<br>•") +
                "        </p>" +
                "      </div>" +

                "      <p style='color:#9ca3af;font-size:13px;text-align:center;'>" +
                "        Please visit your nearest center with your <strong style='color:white;'>Application ID</strong>." +
                "        <br>Login to your dashboard to view and download your benefit card." +
                "      </p>" +

                "    </div>" +

                "    <div style='background:#05070f;padding:15px;text-align:center;'>" +
                "      <p style='color:#6b7280;font-size:12px;margin:0;'>" +
                "        © 2026 Integrated Eligibility System | All Rights Reserved" +
                "      </p>" +
                "    </div>" +

                "  </div>" +
                "</div>";

            msg.setContent(body, "text/html; charset=UTF-8");
            Transport.send(msg);

        } catch (Exception e) {
            // Email failure should not stop the benefit process
            System.err.println("Email send failed: " + e.getMessage());
        }
    }
}