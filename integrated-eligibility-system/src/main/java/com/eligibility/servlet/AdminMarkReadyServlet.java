package com.eligibility.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.eligibility.util.DBConnection;

@WebServlet("/AdminMarkReadyServlet")
public class AdminMarkReadyServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String appId  = request.getParameter("id");
        String planId = request.getParameter("plan");

        // ── Validate ──────────────────────────────────────────
        if (appId == null || appId.trim().isEmpty() ||
            planId == null || planId.trim().isEmpty()) {

            response.sendRedirect("adminCases.jsp?error=invalid");
            return;
        }

        // ── Pick correct table based on plan_id ───────────────
        String table = "";

        switch (planId.trim()) {
            case "PLN-001": table = "snap_applications";     break;
            case "PLN-002": table = "ccap_applications";     break;
            case "PLN-003": table = "medicaid_applications"; break;
            case "PLN-004": table = "medicare_applications"; break;
            case "PLN-005": table = "qhp_applications";      break;
            default:
                response.sendRedirect("adminCases.jsp?error=unknownplan");
                return;
        }

        // ── Update final_status = 'READY' ─────────────────────
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();

            String sql = "UPDATE " + table +
                         " SET final_status = 'READY'" +
                         " WHERE application_id = ?";

            ps = con.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(appId.trim()));

            int rows = ps.executeUpdate();

            if (rows > 0) {
                // success → back to adminCases with toast
                response.sendRedirect("adminCases.jsp?success=1");
            } else {
                // no rows updated
                response.sendRedirect("adminCases.jsp?error=notfound");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminCases.jsp?error=" + e.getMessage());

        } finally {
            try { if (ps  != null) ps.close();  } catch (Exception ex) {}
            try { if (con != null) con.close(); } catch (Exception ex) {}
        }
    }
}