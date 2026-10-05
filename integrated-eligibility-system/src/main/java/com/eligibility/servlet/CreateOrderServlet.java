package com.eligibility.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import org.json.JSONObject;

import com.razorpay.Order;
import com.razorpay.RazorpayClient;

@WebServlet("/CreateOrderServlet")
public class CreateOrderServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(

            HttpServletRequest request,

            HttpServletResponse response)

            throws ServletException, IOException {

        try {

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

            String amount =
                    request.getParameter(
                    "amount");

            RazorpayClient client =

            		new RazorpayClient(

                    		"rzp_live_SvsHUVeOv5ukRp",

                    		"yxWq9bYg6mVC18oLjJdZ33GM"

                    		);
            JSONObject orderRequest =
                    new JSONObject();

            orderRequest.put(
                    "amount",

                    Double.parseDouble(
                    amount) * 100
            );

            orderRequest.put(
                    "currency",
                    "INR"
            );

            orderRequest.put(
                    "receipt",
                    "APP_" + applicationId
            );
            System.out.println("Application ID = " + applicationId);
            System.out.println("Amount = " + amount);
            System.out.println("Plan = " + planName);
            Order order =
                    client.orders.create(
                    orderRequest);
           

            		System.out.println(
            		"Order ID = "
            		+ order.get("id")
            		);
            request.setAttribute(
                    "orderId",

                    order.get("id")
            );

            request.setAttribute(
                    "amount",
                    amount
            );

            request.setAttribute(
                    "applicationId",
                    applicationId
            );

            request.setAttribute(
                    "userName",
                    userName
            );

            request.setAttribute(
                    "email",
                    email
            );

            request.setAttribute(
                    "planId",
                    planId
            );

            request.setAttribute(
                    "planName",
                    planName
            );

            request.getRequestDispatcher(

            "razorpay.jsp"

            ).forward(

            request,
            response

            );

        }

        catch(Exception e){

            e.printStackTrace();

            response.setContentType(
            "text/html"
            );

            response.getWriter().println(

            "<h2>Razorpay Error</h2>"

            +

            "<br><br>"

            +

            e.toString()

            );

        }     }

}