
<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ page import="java.sql.*" %>
<%@ page import="com.eligibility.util.DBConnection" %>
<%
String email =
(String)session.getAttribute("userEmail");

String role =
(String)session.getAttribute("employeeType");

if(email==null ||
role==null ||
!role.equalsIgnoreCase("Admin")){

response.sendRedirect("auth.jsp");
return;

}
%>


<!DOCTYPE html>

<html>
<head>

<meta charset="UTF-8">

<title>Manage Account</title>

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

.main{
padding:30px;
}

.sidebar{
display:none;
}

.logo{
font-size:30px;
font-weight:bold;
color:#ff7b00;
margin-bottom:35px;
}

.header{

height:90px;

background:#05070f;

display:flex;

justify-content:space-between;

align-items:center;

padding:0 40px;

border-bottom:1px solid #1d1d1d;

position:sticky;

top:0;

z-index:999;

}

.logo-header{

font-size:30px;

font-weight:bold;

color:#ff7b00;

}

.nav{

display:flex;

gap:15px;

}

.nav a{

text-decoration:none;

padding:12px 22px;

border-radius:30px;

background:#111827;

color:white;

font-weight:bold;

transition:.3s;

}

.nav a:hover,
.nav .active{

background:#ff7b00;

}

.menu{
list-style:none;
}

.menu li{
margin-bottom:15px;
}

.menu a{
display:block;
padding:14px 18px;
text-decoration:none;
color:white;
border-radius:12px;
transition:.3s;
}

.menu a:hover,
.active{
background:#ff7b00;
}

.content{
flex:1;
padding:30px;
overflow-y:auto;
}

.page-title{
font-size:34px;
font-weight:bold;
margin-bottom:8px;
}

.page-subtitle{
color:#9ca3af;
margin-bottom:25px;
}

.table-box{
background:#111827;
padding:20px;
border-radius:20px;
}

table{
width:100%;
border-collapse:collapse;
background:#0f172a;
border-radius:15px;
overflow:hidden;
}

th{
background:#ff7b00;
padding:15px;
text-align:center;
color:white;
}

td{
padding:15px;
text-align:center;
border-bottom:1px solid #1f2937;
color:white;
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

.approve-btn{
background:#22c55e;
color:white;
border:none;
padding:8px 16px;
border-radius:8px;
cursor:pointer;
margin-right:5px;
font-weight:bold;
}

.approve-btn:hover{
background:#16a34a;
}

.reject-btn{
background:#ef4444;
color:white;
border:none;
padding:8px 16px;
border-radius:8px;
cursor:pointer;
font-weight:bold;
}

.reject-btn:hover{
background:#dc2626;
}

.footer{
margin-top:20px;
text-align:center;
color:#9ca3af;
font-size:12px;
}

</style>



</head>

<body>


<div class="header">

<div class="logo-header">
IES ADMIN
</div>

<div class="nav">

<a href="adminDashboard.jsp">
Dashboard
</a>

<a href="manageAcc.jsp" class="active">
Accounts
</a>

<a href="adminCases.jsp">
Cases
</a>

<a href="adminViewCases.jsp">
CaseWokerCase
</a>

<a href="adminBenefits.jsp">
Benefits
</a>

<a href="distribution.jsp">
Distribution
</a>

<a href="LogoutServlet">
Logout
</a>

</div>

</div>

<div class="main">



<div class="content">

<div class="page-title">
Manage Case Workers
</div>

<div class="page-subtitle">
Approve or reject case worker accounts.
</div>

<div class="table-box">

<table>

<tr>
<th>Name</th>
<th>Email</th>
<th>SSN</th>
<th>Mobile</th>
<th>Status</th>
<th>Action</th>
</tr>

<%

try{

Connection con=
DBConnection.getConnection();

PreparedStatement ps=
con.prepareStatement(

"SELECT * FROM registration " +
"WHERE employee_type='CaseWorker' " +
"ORDER BY id DESC"

);

ResultSet rs=
ps.executeQuery();

while(rs.next()){

String status=
rs.getString("status");

%>

<tr>

<td>

<%=rs.getString("first_name")%>
<%=rs.getString("surname")%>

</td>

<td>

<%=rs.getString("email")%>

</td>

<td>

<%=rs.getString("ssn")%>

</td>

<td>

<%=rs.getString("mobile")%>

</td>

<td>

<%

if("APPROVED".equals(status)){

%>

<span class="approved">
APPROVED
</span>

<%

}else if("REJECTED".equals(status)){

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

<td>

<%

if("PENDING".equals(status)){

%>

<button
class="approve-btn"
onclick="approveUser(<%=rs.getInt("id")%>)">
Approve
</button>

<button
class="reject-btn"
onclick="rejectUser(<%=rs.getInt("id")%>)">
Reject
</button>

<%

}else{

%>

-

<%

}

%>

</td>

</tr>

<%

}

rs.close();
ps.close();
con.close();

}catch(Exception e){

out.println(e);

}

%>

</table>

</div>

<div class="footer">
© 2026 Eligibility & Benefit Management System
</div>

</div>

</div>
<script>

function approveUser(id){

if(confirm("Approve this case worker account?")){

window.location.href=
"ApproveCaseWorkerServlet?id="+id;

}

}

function rejectUser(id){

if(confirm("Reject this case worker account?")){

window.location.href=
"RejectCaseWorkerServlet?id="+id;

}

}

</script>
</body>

</html>

