<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.eligibility.util.DBConnection" %>

<%
String userEmail = (String) session.getAttribute("userEmail");

if(userEmail == null){
    response.sendRedirect("auth.jsp");
    return;
}
%>
<!DOCTYPE html>

<html>
<head>
<meta charset="UTF-8">
<title>Upload Documents</title>

<style>

*{
margin:0;
padding:0;
box-sizing:border-box;
font-family:'Segoe UI',sans-serif;
}

body{
background:#3a3a3a;
}

.header{
height:70px;
background:#444;
display:flex;
justify-content:space-between;
align-items:center;
padding:0 20px;
}

.logo{
font-size:32px;
font-weight:bold;
color:#4ade80;
}

.menu a{
text-decoration:none;
color:white;
background:#555;
padding:10px 20px;
border-radius:20px;
margin-left:10px;
}

.active{
background:#22c55e !important;
}

.container{
margin:20px;
background:#4b4b4b;
border-radius:20px;
padding:25px;
min-height:500px;
box-shadow:0 10px 20px rgba(0,0,0,.3);
}

.container h1{
color:white;
margin-bottom:20px;
}

.request-box{
background:#7d6a47;
color:#f7d97c;
padding:12px;
border-radius:10px;
font-weight:600;
}

.document-area{
display:none;
}

.document-area h3{
margin-bottom:15px;
}

.document-area input{
margin-bottom:15px;
}

.upload-btn{
background:#22c55e;
color:white;
border:none;
padding:12px 25px;
border-radius:8px;
cursor:pointer;
font-size:14px;
}

.footer{
height:40px;
background:#444;
display:flex;
justify-content:center;
align-items:center;
color:#ddd;
font-size:12px;
margin-top:20px;
}

</style>

</head>
<body>

<div class="header">
<div class="logo">IES</div>
<div class="menu">
<a href="userDashboard.jsp">Dashboard</a>
<a href="plans.jsp">Plans</a>
<a href="track.jsp">Track</a>
<a href="uploadDocuments.jsp" class="active">Documents</a>
<a href="benefits.jsp">Benefits</a>
<a href="index.jsp">LogOut</a>
</div>

</div>

<div class="container">
<h1>Upload Documents</h1>

<%
try{

Connection con = DBConnection.getConnection();

PreparedStatement ps = con.prepareStatement(
    "SELECT application_id,plan_id,full_name,required_docs FROM snap_applications WHERE doc_status='REQUESTED' AND user_email=? " +
    "UNION ALL " +
    "SELECT application_id,plan_id,full_name,required_docs FROM ccap_applications WHERE doc_status='REQUESTED' AND user_email=? " +
    "UNION ALL " +
    "SELECT application_id,plan_id,full_name,required_docs FROM medicaid_applications WHERE doc_status='REQUESTED' AND user_email=? " +
    "UNION ALL " +
    "SELECT application_id,plan_id,full_name,required_docs FROM medicare_applications WHERE doc_status='REQUESTED' AND user_email=? " +
    "UNION ALL " +
    "SELECT application_id,plan_id,full_name,required_docs FROM qhp_applications WHERE doc_status='REQUESTED' AND user_email=? " +
    "ORDER BY application_id DESC"
);

ps.setString(1,userEmail);
ps.setString(2,userEmail);
ps.setString(3,userEmail);
ps.setString(4,userEmail);
ps.setString(5,userEmail);

ResultSet rs = ps.executeQuery();

boolean found = false;

while(rs.next()){

found = true;

String appId = rs.getString("application_id");
String planId = rs.getString("plan_id");
String userName = rs.getString("full_name");
String docs = rs.getString("required_docs");

String planName = "";
if("PLN-001".equals(planId)) planName = "SNAP";
else if("PLN-002".equals(planId)) planName = "CCAP";
else if("PLN-003".equals(planId)) planName = "MEDICAID";
else if("PLN-004".equals(planId)) planName = "MEDICARE";
else if("PLN-005".equals(planId)) planName = "QHP";

%>

<div class="request-box">
Application ID : <%=appId%><br><br>
User Name : <%=userName%><br><br>
Plan : <%=planName%><br><br>
Required Documents : <%=docs%>
</div>

<form action="UploadDocumentsServlet" method="post"
enctype="multipart/form-data"
style="margin-bottom:40px;">

<input type="hidden" name="appId" value="<%=appId%>">
<input type="hidden" name="planId" value="<%=planId%>">
<input type="hidden" name="docs" value="<%=docs%>">

<h3 style="color:white;margin:15px 0;">Upload Documents</h3>

<%
if(docs != null && !docs.isEmpty()){
String[] docArray = docs.split(",");
for(String d : docArray){
%>
<p style="color:#f7d97c;margin-bottom:5px;">
✓ <%=d.trim()%>
</p>
<input type="file" name="<%=d.trim()%>"
style="margin-bottom:15px;display:block;color:white;">
<%
}
}
%>

<h3 style="color:white;margin:15px 0;">Bank Details</h3>

<input type="text" name="accountHolder"
placeholder="Account Holder Name"
style="width:300px;padding:10px;border-radius:6px;border:none;display:block;margin-bottom:10px;">

<input type="text" name="bankName"
placeholder="Bank Name"
style="width:300px;padding:10px;border-radius:6px;border:none;display:block;margin-bottom:10px;">

<input type="text" name="accountNo"
placeholder="Account Number"
style="width:300px;padding:10px;border-radius:6px;border:none;display:block;margin-bottom:10px;">

<input type="text" name="confirmAccountNo"
placeholder="Confirm Account Number"
style="width:300px;padding:10px;border-radius:6px;border:none;display:block;margin-bottom:10px;">

<input type="text" name="ifsc"
placeholder="IFSC Code"
style="width:300px;padding:10px;border-radius:6px;border:none;display:block;margin-bottom:10px;">

<input type="text" name="branchName"
placeholder="Branch Name"
style="width:300px;padding:10px;border-radius:6px;border:none;display:block;margin-bottom:20px;">

<button type="submit" class="upload-btn">
Submit Documents & Bank Details
</button>

</form>

<%
}

if(!found){
%>
<div class="request-box">
No document request from caseworker yet.
</div>
<%
}

con.close();

}catch(Exception e){
out.println(e);
}
%>

</div>

<div class="footer">
© 2026 Integrated Eligibility System
</div>

</body>
</html>