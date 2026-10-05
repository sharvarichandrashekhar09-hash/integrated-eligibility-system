<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%
String email =
(String)session.getAttribute("userEmail");

String role =
(String)session.getAttribute("employeeType");


if(email==null ||
role==null ||
!role.equalsIgnoreCase("CaseWorker")){

response.sendRedirect("auth.jsp");
return;

}
%>
<!DOCTYPE html>

<html>
<head>
<meta charset="UTF-8">
<title>Document Verification</title>

<style>

*{
margin:0;
padding:0;
box-sizing:border-box;
font-family:'Segoe UI',sans-serif;
}

body{
background:#f5e9dc;
}

.header{
height:70px;
background:white;
display:flex;
justify-content:space-between;
align-items:center;
padding:0 30px;
border-bottom:1px solid #ddd;
}

.logo{
font-size:28px;
font-weight:bold;
color:#ff7a00;
}

.menu a{
text-decoration:none;
color:#ff7a00;
margin-left:15px;
padding:8px 15px;
border-radius:20px;
background:#fff3e6;
}

.active{
background:#ff7a00 !important;
color:white !important;
}

.container{
width:90%;
margin:30px auto;
}

.container h1{
color:#1f2d50;
margin-bottom:10px;
}

.container p{
color:#666;
margin-bottom:25px;
}

.table-box{
background:white;
border-radius:15px;
overflow:hidden;
box-shadow:0 2px 10px rgba(0,0,0,.1);
}

table{
width:100%;
border-collapse:collapse;
}

th{
background:#ff951a;
color:white;
padding:15px;
}

td{
padding:15px;
text-align:center;
border-bottom:1px solid #eee;
}

.view-btn{
background:#2196f3;
color:white;
border:none;
padding:8px 15px;
border-radius:6px;
cursor:pointer;
}

.approve-btn{
background:#28a745;
color:white;
border:none;
padding:8px 15px;
border-radius:6px;
cursor:pointer;
margin-right:5px;
}

.reject-btn{
background:#dc3545;
color:white;
border:none;
padding:8px 15px;
border-radius:6px;
cursor:pointer;
}

.footer{
margin-top:30px;
text-align:center;
font-size:12px;
color:#777;
}

</style>

</head>

<body>

<div class="header">

<div class="logo">
IES CASEWORKER
</div>

<div class="menu">

<a href="caseworkerDashboard.jsp">
Dashboard
</a>

<a href="documentVerification.jsp" class="active">
Verification
</a>

<a href="caseworkerCases.jsp">
Cases
</a>

<a href="payments.jsp">
Payment
</a>

<a href="logout.jsp">
Logout
</a>

</div>

</div>

<div class="container">

<h1>Document Verification</h1>

<p>
Verify uploaded citizen documents, check bank details,
review eligibility information, and approve applications.
</p>

<div class="table-box">
<%@ page import="java.sql.*" %>
<%@ page import="com.eligibility.util.DBConnection" %>

<%
String caseworkerEmail = (String) session.getAttribute("userEmail");
%>

<table>

<tr>
<th>App ID</th>
<th>User</th>
<th>Plan</th>
<th>Bank Details</th>
<th>Documents</th>
<th>Status</th>
<th>Action</th>
</tr>

<%
try{

Connection con = DBConnection.getConnection();

PreparedStatement ps = con.prepareStatement(
		"SELECT application_id,full_name,plan_id,account_holder,account_no,ifsc,doc_status,uploaded_files FROM snap_applications WHERE doc_status='UPLOADED' " +
				"UNION ALL " +
				"SELECT application_id,full_name,plan_id,account_holder,account_no,ifsc,doc_status,uploaded_files FROM ccap_applications WHERE doc_status='UPLOADED' " +
				"UNION ALL " +
				"SELECT application_id,full_name,plan_id,account_holder,account_no,ifsc,doc_status,uploaded_files FROM medicaid_applications WHERE doc_status='UPLOADED' " +
				"UNION ALL " +
				"SELECT application_id,full_name,plan_id,account_holder,account_no,ifsc,doc_status,uploaded_files FROM medicare_applications WHERE doc_status='UPLOADED' " +
				"UNION ALL " +
				"SELECT application_id,full_name,plan_id,account_holder,account_no,ifsc,doc_status,uploaded_files FROM qhp_applications WHERE doc_status='UPLOADED' " +
				"ORDER BY application_id DESC"
);

ResultSet rs = ps.executeQuery();

boolean found = false;

while(rs.next()){

found = true;

String appId = rs.getString("application_id");
String fullName = rs.getString("full_name");
String planId = rs.getString("plan_id");
String accountHolder = rs.getString("account_holder");
String accountNo = rs.getString("account_no");
String ifsc = rs.getString("ifsc");
String uploadedFiles = rs.getString("uploaded_files");

String planName = "";
if("PLN-001".equals(planId)) planName = "SNAP";
else if("PLN-002".equals(planId)) planName = "CCAP";
else if("PLN-003".equals(planId)) planName = "MEDICAID";
else if("PLN-004".equals(planId)) planName = "MEDICARE";
else if("PLN-005".equals(planId)) planName = "QHP";

%>

<tr>

<td><%=appId%></td>
<td><%=fullName%></td>
<td><%=planName%></td>

<td>
<%=accountHolder%><br>
<%=accountNo%><br>
<%=ifsc%>
</td>

<td>
<%
if(uploadedFiles != null && !uploadedFiles.isEmpty()){
String[] files = uploadedFiles.split(",");
for(String f : files){
%>
<a href="uploads/<%=f.trim()%>"
target="_blank"
style="color:#2196f3;display:block;margin-bottom:5px;">
📄 <%=f.trim()%>
</a>
<%
}
}else{
out.print("No documents");
}
%>
</td>
<td>UPLOADED</td>

<td>
<button class="approve-btn"
onclick="window.location.href='FinalApproveServlet?id=<%=appId%>&plan=<%=planId%>'">
Approve
</button>

<button class="reject-btn"
onclick="window.location.href='FinalRejectServlet?id=<%=appId%>&plan=<%=planId%>'">
Reject
</button>
</td>

</tr>

<%
}

if(!found){
%>
<tr>
<td colspan="6">No uploaded documents yet.</td>
</tr>
<%
}

con.close();

}catch(Exception e){
out.println(e);
}
%>

</table>

</div>

</div>

<div class="footer">
© 2026 Integrated Eligibility System
</div>

</body>
</html>
