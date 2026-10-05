package com.eligibility.servlet;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import com.eligibility.util.DBConnection;

@WebServlet("/UploadDocumentsServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class UploadDocumentsServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            HttpSession session = request.getSession();
            String userEmail = (String) session.getAttribute("userEmail");

            String appId = request.getParameter("appId");
            String planId = request.getParameter("planId");
            
            System.out.println("appId = " + appId);
            System.out.println("planId = " + planId);
            
            String accountHolder = request.getParameter("accountHolder");
            String accountNo = request.getParameter("accountNo");
            String ifsc = request.getParameter("ifsc");
            String docs = request.getParameter("docs");

            // UPLOAD FOLDER
            String uploadFolder = getServletContext()
                    .getRealPath("") + File.separator + "uploads";

            File folder = new File(uploadFolder);
            if(!folder.exists()){
                folder.mkdirs();
            }

            // SAVE EACH FILE
            StringBuilder fileNames = new StringBuilder();

            if(docs != null && !docs.isEmpty()){

                String[] docArray = docs.split(",");

                for(String doc : docArray){

                    String fieldName = doc.trim();

                    Part part = request.getPart(fieldName);

                    if(part != null &&
                       part.getSize() > 0){

                        String fileName =
                            appId + "_" +
                            fieldName.replace(" ","_") +
                            "_" +
                            part.getSubmittedFileName();

                        part.write(uploadFolder +
                                File.separator + fileName);

                        if(fileNames.length() > 0){
                            fileNames.append(",");
                        }

                        fileNames.append(fileName);
                    }
                }
            }

            String tableName = "";
            if("PLN-001".equals(planId)) tableName = "snap_applications";
            else if("PLN-002".equals(planId)) tableName = "ccap_applications";
            else if("PLN-003".equals(planId)) tableName = "medicaid_applications";
            else if("PLN-004".equals(planId)) tableName = "medicare_applications";
            else if("PLN-005".equals(planId)) tableName = "qhp_applications";

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
            	    "UPDATE " + tableName +
            	    " SET doc_status='UPLOADED'," +
            	    " account_holder=?," +
            	    " account_no=?," +
            	    " ifsc=?," +
            	    " uploaded_files=?" +
            	    " WHERE application_id=?"
            	
            );

            ps.setString(1, accountHolder);
            ps.setString(2, accountNo);
            ps.setString(3, ifsc);
            ps.setString(4, fileNames.toString());
            ps.setInt(5, Integer.parseInt(appId));
            ps.executeUpdate();

            // SAVE TO BANK_DETAILS TABLE
            PreparedStatement ps2 = con.prepareStatement(
                "INSERT INTO bank_details(" +
                "application_id,plan_id,user_email," +
                "account_holder,account_no,ifsc)" +
                " VALUES(?,?,?,?,?,?)"
            );

            ps2.setInt(1, Integer.parseInt(appId));
            ps2.setString(2, planId);
            ps2.setString(3, userEmail);
            ps2.setString(4, accountHolder);
            ps2.setString(5, accountNo);
            
            ps.setInt(5, Integer.parseInt(appId));
            int rows = ps.executeUpdate();
            System.out.println("Rows updated = " + rows);
            System.out.println("tableName = " + tableName);
            System.out.println("fileNames = " + fileNames.toString());
            ps2.setString(6, ifsc);
            ps2.executeUpdate();

            ps.close();
            ps2.close();
            con.close();

            response.sendRedirect("uploadDocuments.jsp");

        } catch(Exception e) {
            e.printStackTrace();
            response.getWriter().println(
                "<h3>Error: " + e.getMessage() + "</h3>"
            );
        }
    }
}