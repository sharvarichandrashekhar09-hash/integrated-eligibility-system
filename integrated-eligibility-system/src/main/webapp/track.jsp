<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ page import="java.sql.*" %>
<%@ page import="com.eligibility.util.DBConnection" %>

<%
String email =
(String)session.getAttribute("userEmail");

if(email==null){

response.sendRedirect("auth.jsp");
return;

}
%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Track Application</title>

<style>

*{
margin:0;
padding:0;
box-sizing:border-box;
font-family:Arial,sans-serif;
}

body{
background:#070b16;
color:white;
}

.header{
height:70px;
background:#111827;
display:flex;
justify-content:space-between;
align-items:center;
padding:0 30px;
}

.logo{
font-size:30px;
font-weight:bold;
color:#22c55e;
}

.nav a{
text-decoration:none;
color:white;
margin-left:15px;
padding:10px 18px;
border-radius:10px;
transition:.3s;
}

.nav a:hover,
.active{
background:#22c55e;
}

.container{
padding:30px;
}

.title{
font-size:32px;
font-weight:bold;
margin-bottom:10px;
}

.sub-title{
color:#9ca3af;
margin-bottom:25px;
}

.table-box{
background:#111827;
padding:20px;
border-radius:20px;
overflow-x:auto;
}

table{
width:100%;
border-collapse:collapse;
background:#0f172a;
border-radius:15px;
overflow:hidden;
}

th{
background:#22c55e;
color:white;
padding:15px;
text-align:center;
}

td{
padding:15px;
text-align:center;
border-bottom:1px solid #1f2937;
}

tr:hover{
background:#1e293b;
}

.pending{
color:#facc15;
font-weight:bold;
}

.approved{
color:#22c55e;
font-weight:bold;
}

.rejected{
color:#ef4444;
font-weight:bold;
}

.requested{
color:#38bdf8;
font-weight:bold;
}

.footer{
margin-top:20px;
text-align:center;
color:#9ca3af;
font-size:12px;
}

</style>

<script>

function refreshPage(){

location.reload();

}

</script>

</head>

<body>

<div class="header">

<div class="logo">
IES
</div>

<div class="nav">

<a href="userDashboard.jsp">
Dashboard
</a>

<a href="plans.jsp">
Plans
</a>

<a href="track.jsp"
class="active">
Track
</a>

<a href="benefits.jsp">
Benefits
</a>
<form action="LogoutServlet" method="post" style="display:inline;">

<button class="logout-btn">
Logout
</button>

</form>
</div>

</div>

<div class="container">

<div class="title">
Track Application Status
</div>

<div class="sub-title">
Monitor your application progress, document requests and approvals.
</div>

<div class="table-box">

<table>

<tr>

<th>Application ID</th>
<th>Plan ID</th>
<th>Plan Name</th>
<th>Payment</th>
<th>Document Status</th>
<th>Request Date</th>
<th>Final Status</th>

</tr>

<%

try{

Connection con=
DBConnection.getConnection();

PreparedStatement ps=
con.prepareStatement(

"SELECT application_id,plan_id,payment_status,doc_status,request_date,final_status FROM snap_applications WHERE user_email=? " +

"UNION ALL " +

"SELECT application_id,plan_id,payment_status,doc_status,request_date,final_status FROM ccap_applications WHERE user_email=? " +

"UNION ALL " +

"SELECT application_id,plan_id,payment_status,doc_status,request_date,final_status FROM medicaid_applications WHERE user_email=? " +

"UNION ALL " +

"SELECT application_id,plan_id,payment_status,doc_status,request_date,final_status FROM medicare_applications WHERE user_email=? " +

"UNION ALL " +

"SELECT application_id,plan_id,payment_status,doc_status,request_date,final_status FROM qhp_applications WHERE user_email=?"

);

ps.setString(1,email);
ps.setString(2,email);
ps.setString(3,email);
ps.setString(4,email);
ps.setString(5,email);

ResultSet rs=
ps.executeQuery();

while(rs.next()){

String planId=
rs.getString("plan_id");

String planName="";

if("PLN-001".equals(planId))
planName="SNAP";

else if("PLN-002".equals(planId))
planName="CCAP";

else if("PLN-003".equals(planId))
planName="MEDICAID";

else if("PLN-004".equals(planId))
planName="MEDICARE";

else if("PLN-005".equals(planId))
planName="QHP";

%>

<tr>

<td>
<%=rs.getInt("application_id")%>
</td>

<td>
<%=planId%>
</td>

<td>
<%=planName%>
</td>

<td>

<%=rs.getString("payment_status")%>

</td>

<td>

<%

String docStatus=
rs.getString("doc_status");

if("REQUESTED".equals(docStatus)){

%>

<span class="requested">
DOCUMENT REQUESTED
</span>

<%

}else if("VERIFIED".equals(docStatus)){

%>

<span class="approved">
VERIFIED
</span>

<%

}else{

out.print(docStatus);

}

%>

</td>

<td>

<%=rs.getTimestamp("request_date")%>

</td>

<td>

<%

String finalStatus=
rs.getString("final_status");

if("APPROVED".equals(finalStatus)){

%>

<span class="approved">
APPROVED
</span>

<%

}else if("REJECTED".equals(finalStatus)){

%>

<span class="rejected">
REJECTED
</span>

<%

}else{

%>

<span class="pending">
PENDING
</span>

<%

}

%>

</td>

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

<div class="footer">
© 2026 Integrated Eligibility System
</div>

</div>

</body>

</html>