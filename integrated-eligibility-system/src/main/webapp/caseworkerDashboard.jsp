
<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.eligibility.util.DBConnection" %>
<%
String email =
(String) session.getAttribute("userEmail");

if(email==null){

response.sendRedirect("auth.jsp");
return;
}
%>

<%
int totalCases = 0;
int pendingCases = 0;
int approvedCases = 0;
int rejectedCases = 0;

try{

Connection con =
DBConnection.getConnection();

String query =

"SELECT COUNT(*) total," +

"SUM(CASE WHEN doc_status='PENDING' OR doc_status IS NULL THEN 1 ELSE 0 END) pending," +

"SUM(CASE WHEN doc_status='VERIFIED' THEN 1 ELSE 0 END) approved," +

"SUM(CASE WHEN doc_status='REJECTED' THEN 1 ELSE 0 END) rejected " +

"FROM (" +

"SELECT doc_status FROM snap_applications UNION ALL " +

"SELECT doc_status FROM ccap_applications UNION ALL " +

"SELECT doc_status FROM medicaid_applications UNION ALL " +

"SELECT doc_status FROM medicare_applications UNION ALL " +

"SELECT doc_status FROM qhp_applications" +

") t";

PreparedStatement ps =
con.prepareStatement(query);

ResultSet rs =
ps.executeQuery();

if(rs.next()){

totalCases =
rs.getInt("total");

pendingCases =
rs.getInt("pending");

approvedCases =
rs.getInt("approved");

rejectedCases =
rs.getInt("rejected");

}

con.close();

}catch(Exception e){

e.printStackTrace();

}
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Caseworker Dashboard</title>

<style>

*{
margin:0;
padding:0;
box-sizing:border-box;
font-family:Arial,sans-serif;
}

body{
background:#f3f4f6;
}

.main{
display:flex;
height:100vh;
}

.sidebar{
width:250px;
background:#162033;
padding:25px 15px;
color:white;
}

.logo{
font-size:28px;
font-weight:bold;
margin-bottom:35px;
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
transition:0.3s;
}

.menu a:hover{
background:#ff8c00;
}

.content{
flex:1;
padding:30px;
overflow-y:auto;
}

.topbar{
display:flex;
justify-content:space-between;
align-items:center;
margin-bottom:30px;
}

.logout-btn{
padding:12px 22px;
background:#ff8c00;
border:none;
border-radius:30px;
color:white;
cursor:pointer;
font-weight:bold;
}

.cards{
display:grid;
grid-template-columns:repeat(4,1fr);
gap:20px;
margin-bottom:30px;
}

.card{
background:white;
padding:25px;
border-radius:18px;
}

.card h2{
margin-top:10px;
font-size:34px;
color:#ff8c00;
}

.performance{
background:white;
height:300px;
border-radius:20px;
padding:25px;
}

.chart-card{

background:white;

padding:25px;

border-radius:20px;

margin-top:25px;

box-shadow:0 2px 10px rgba(0,0,0,.08);

}

.chart-header{

display:flex;

justify-content:space-between;

align-items:center;

margin-bottom:20px;

}

.chart-header h3{

color:#1e293b;

}

.chart-header span{

color:#ff8c00;

font-weight:bold;

}

.chart{

width:100%;

height:220px;

}

.chart svg{

width:100%;

height:100%;

}

.chart polyline{

stroke-linecap:round;

stroke-linejoin:round;

animation:heartbeat 3s infinite ease-in-out;

}

@keyframes heartbeat{

0%{
transform:translateY(0);
}

50%{
transform:translateY(-5px);
}

100%{
transform:translateY(0);
}

}
</style>

</head>

<body>

<div class="main">

<div class="sidebar">

<div class="logo">
Caseworker
</div>

<ul class="menu">

<li>
<a href="caseworkerDashboard.jsp"
style="background:#ff8c00;">
Dashboard
</a>
</li>

<li>
<a href="documentVerification.jsp">
Verification Documents
</a>
</li>

<li>
<a href="caseworkerCases.jsp">
Cases
</a>
</li>

<li>
<a href="payments.jsp">
Payment
</a>
</li>

</ul>

</div>

<div class="content">

<div class="topbar">

<div>

<h1>
Cases Overview
</h1>

<p>
Track verification workflow and activities
</p>

</div>

<div style="display:flex;align-items:center;gap:15px;">

<span style="font-weight:bold;color:#555;">
<%=email%>
</span>

<form action="LogoutServlet" method="post">

<button class="logout-btn">
Logout
</button>

</form>

</div>

</div>

<div class="cards">


<div class="card">
<p>Total Cases</p>
<h2><%=totalCases%></h2>
</div>

<div class="card">
<p>Pending</p>
<h2><%=pendingCases%></h2>
</div>

<div class="card">
<p>Approved</p>
<h2><%=approvedCases%></h2>
</div>

<div class="card">
<p>Rejected</p>
<h2><%=rejectedCases%></h2>
</div>

</div>




<br>

<div class="chart-card">

<div class="chart-header">

<h3>Case Processing Trend</h3>

<span>Last 30 Days</span>

</div>

<div class="chart">

<svg viewBox="0 0 800 200">

<polyline
fill="none"
stroke="#ff8c00"
stroke-width="6"
points="
0,140
50,130
100,120
150,90
200,110
250,70
300,95
350,60
400,80
450,50
500,90
550,40
600,70
650,30
700,50
750,20
800,35"/>

</svg>

</div>

</div>
</div>

</div>

</body>
</html>
