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


@WebServlet("/RejectCaseWorkerServlet")
public class RejectCaseWorkerServlet extends HttpServlet {

    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int id =
            Integer.parseInt(
            request.getParameter("id"));

            Connection con =
            DBConnection.getConnection();

            PreparedStatement ps =
            con.prepareStatement(

            "UPDATE registration " +
            "SET status='REJECTED' " +
            "WHERE id=?"

            );

            ps.setInt(1, id);

            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect(
            "manageAccount.jsp");

        }
        catch(Exception e) {

            e.printStackTrace();

        }

    }

}