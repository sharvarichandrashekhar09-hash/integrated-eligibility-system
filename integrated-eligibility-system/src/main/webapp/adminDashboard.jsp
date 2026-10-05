
<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="com.eligibility.util.DBConnection"%>

<%
int totalApplications=0;
int pendingRequests=0;
int approvedCases=0;
int benefitsGiven=0;

try{

Connection con=DBConnection.getConnection();

Statement st=con.createStatement();

ResultSet rs=st.executeQuery(

"SELECT " +

"(SELECT COUNT(*) FROM snap_applications)+ " +
"(SELECT COUNT(*) FROM ccap_applications)+ " +
"(SELECT COUNT(*) FROM medicaid_applications)+ " +
"(SELECT COUNT(*) FROM medicare_applications)+ " +
"(SELECT COUNT(*) FROM qhp_applications) totalApps"

);

if(rs.next()){

totalApplications=rs.getInt("totalApps");

}

rs=st.executeQuery(

"SELECT COUNT(*) totalPending FROM (" +

"SELECT final_status FROM snap_applications " +
"UNION ALL SELECT final_status FROM ccap_applications " +
"UNION ALL SELECT final_status FROM medicaid_applications " +
"UNION ALL SELECT final_status FROM medicare_applications " +
"UNION ALL SELECT final_status FROM qhp_applications" +

") x WHERE final_status='PENDING'"

);

if(rs.next()){

pendingRequests=rs.getInt("totalPending");

}

rs=st.executeQuery(

"SELECT COUNT(*) totalApproved FROM (" +

"SELECT final_status FROM snap_applications " +
"UNION ALL SELECT final_status FROM ccap_applications " +
"UNION ALL SELECT final_status FROM medicaid_applications " +
"UNION ALL SELECT final_status FROM medicare_applications " +
"UNION ALL SELECT final_status FROM qhp_applications" +

") x WHERE final_status='APPROVED'"

);

if(rs.next()){

approvedCases=rs.getInt("totalApproved");

}

rs=st.executeQuery(
"SELECT COUNT(*) totalBenefits FROM distributed_benefits"
);

if(rs.next()){

benefitsGiven=rs.getInt("totalBenefits");

}

con.close();

}catch(Exception e){

e.printStackTrace();

}
%>
<%
String email =
(String) session.getAttribute("userEmail");

if(email==null){

response.sendRedirect("auth.jsp");
return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>IES Admin Dashboard</title>

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
display:flex;
height:100vh;
}

.sidebar{
width:260px;
background:#05070f;
padding:25px 15px;
border-right:1px solid #1d1d1d;
}

.logo{
font-size:30px;
font-weight:bold;
color:#ff7b00;
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
background:#ff7b00;
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
background:#ff7b00;
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
background:#111827;
padding:25px;
border-radius:18px;
border-top:4px solid #ff7b00;
}

.card h2{
margin-top:10px;
font-size:34px;
}

.analytics{

background:#111827;

border-radius:20px;

padding:25px;

margin-top:20px;

height:420px;

box-shadow:0 10px 25px rgba(0,0,0,.25);

}

.chart-header{

display:flex;

justify-content:space-between;

align-items:center;

margin-bottom:20px;

}

.chart-header h2{

color:white;

font-size:28px;

}

.chart-header span{

color:#ff7b00;

font-size:18px;

font-weight:bold;

}

.chart{

width:100%;

height:300px;

position:relative;

}

.chart svg{

width:100%;

height:100%;

}

.trend-line{

fill:none;

stroke:#ff7b00;

stroke-width:8;

stroke-linecap:round;

stroke-linejoin:round;

filter:drop-shadow(0 0 10px rgba(255,123,0,.5));

animation:drawLine 2s ease-in-out;

}

@keyframes drawLine{

from{

stroke-dasharray:2000;
stroke-dashoffset:2000;

}

to{

stroke-dasharray:2000;
stroke-dashoffset:0;

}

}

.footer{

position:fixed;

bottom:0;

left:260px;

right:0;

height:55px;

background:#05070f;

border-top:1px solid #1d1d1d;

display:flex;

justify-content:center;

align-items:center;

color:#9ca3af;

font-size:14px;

}

</style>

</head>

<body>

<div class="main">

<div class="sidebar">

<div class="logo">
IES ADMIN
</div>

<ul class="menu">

<li>
<a href="adminDashboard.jsp" class="active"
style="background:#ff7b00;">
Dashboard
</a>
</li>

<li>
<a href="manageAcc.jsp">
Accounts
</a>
</li>

<li>
<a href="adminBenefits.jsp">
Benefits
</a>
</li>

<li>
<a href="distribution.jsp">
Distribution
</a>
</li>

<li>
<a href="adminCases.jsp">
Admin Cases
</a>
</li>

<li>
<a href="caseWorkers.jsp">
Case Workers
</a>
</li>


</ul>

</div>

<div class="content">

<div class="topbar">

    <div>

        <h1>
            Welcome Back, Admin
        </h1>

        <p>
            Monitor applications, benefits and reports
        </p>

    </div>

    <div
    style="
    display:flex;
    align-items:center;
    gap:20px;
    ">

        <div
        style="
        text-align:right;
        ">

            <div
            style="
            font-size:18px;
            font-weight:bold;
            color:white;
            ">
                <%=email%>
            </div>

            <div
            style="
            color:#9ca3af;
            font-size:14px;
            ">
                System Administrator
            </div>

        </div>

        <form
        action="LogoutServlet"
        method="post">

            <button
            class="logout-btn">
                Logout
            </button>

        </form>

    </div>

</div>
<div class="cards">

<div class="card">
<p>Total Applications</p>
<h2><%=totalApplications%></h2>
</div>

<div class="card">
<p>Pending Requests</p>
<h2><%=pendingRequests%></h2>
</div>

<div class="card">
<p>Approved Cases</p>
<h2><%=approvedCases%></h2>
</div>

<div class="card">
<p>Benefits Given</p>
<h2><%=benefitsGiven%></h2>
</div>
</div>

<div class="analytics">



<div class="chart-header">

<h2>Case Processing Trend</h2>

<span>Last 30 Days</span>

</div>

<div class="chart">

<svg viewBox="0 0 1000 250">

<polyline
points="
20,180
120,160
180,120
250,150
320,90
390,130
460,75
530,110
600,60
670,120
740,45
810,95
880,30
960,55"
class="trend-line"/>

</svg>

</div>

</div>

</div>



</div>

<div class="footer">

© 2026 Integrated Eligibility System | Admin Portal

</div>

</body>
</html>
