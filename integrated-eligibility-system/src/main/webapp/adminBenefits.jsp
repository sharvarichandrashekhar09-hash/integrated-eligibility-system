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
!"Admin".equals(role)){

response.sendRedirect("auth.jsp");
return;

}
%>
<%
double totalAllocated=0;
double totalDistributed=0;
double totalRemaining=0;
int totalBeneficiaries=0;
int totalSchemes=0;

try{

Connection con=
DBConnection.getConnection();

PreparedStatement ps=
con.prepareStatement(
"SELECT * FROM government_allocations"
);

ResultSet rs=
ps.executeQuery();

while(rs.next()){

totalSchemes++;

totalAllocated+=
rs.getDouble("allocated_amount");

totalDistributed+=
rs.getDouble("distributed_amount");

totalRemaining+=
rs.getDouble("remaining_balance");

totalBeneficiaries+=
rs.getInt("beneficiaries_served");

}

rs.close();
ps.close();
con.close();

}catch(Exception e){

e.printStackTrace();

}
%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Admin Benefits</title>

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
font-size:32px;
font-weight:bold;
margin-bottom:10px;
}

.page-subtitle{
color:#9ca3af;
margin-bottom:25px;
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

.card p{
color:#cbd5e1;
}

.card h2{
margin-top:10px;
font-size:28px;
}

.table-box{
background:#111827;
padding:20px;
border-radius:20px;
}

table{
width:100%;
border-collapse:collapse;
margin-top:20px;
}

th{
background:#ff7b00;
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

.status-active{
color:#22c55e;
font-weight:bold;
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

<div class="main">
<div class="header">

<div class="logo-header">
IES ADMIN
</div>

<div class="nav">

<a href="adminDashboard.jsp">
Dashboard
</a>

<a href="manageAcc.jsp">
Accounts
</a>

<a href="adminCases.jsp">
Cases
</a>

<a href="adminBenefits.jsp" class="active">
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
</div>

<div class="content">

<div class="page-title">
Benefits Management
</div>

<div class="page-subtitle">
Government allocation and benefit distribution overview
</div>

<div class="cards">

<div class="card">
<p>Total Schemes</p>
<h2><%=totalSchemes%></h2>
</div>

<div class="card">
<p>Total Allocated</p>
<h2>₹<%=String.format("%.0f",totalAllocated)%></h2>
</div>

<div class="card">
<p>Total Distributed</p>
<h2>₹<%=String.format("%.0f",totalDistributed)%></h2>
</div>

<div class="card">
<p>Beneficiaries Served</p>
<h2><%=totalBeneficiaries%></h2>
</div>

</div>

<div class="table-box">

<h2>
Government Allocation History
</h2>

<table>

<tr>
<th>Month</th>
<th>Year</th>
<th>Scheme</th>
<th>Allocated</th>
<th>Beneficiary Limit</th>
<th>Distributed</th>
<th>Remaining</th>
<th>Served</th>
<th>Status</th>
</tr>

<%

try{

Connection con=
DBConnection.getConnection();

PreparedStatement ps=
con.prepareStatement(
"SELECT * FROM government_allocations ORDER BY id DESC"
);

ResultSet rs=
ps.executeQuery();

while(rs.next()){

%>

<tr>

<td>
<%=rs.getString("month_name")%>
</td>

<td>
<%=rs.getInt("year_value")%>
</td>

<td>
<%=rs.getString("scheme_name")%>
</td>

<td>
₹<%=rs.getDouble("allocated_amount")%>
</td>

<td>
<%=rs.getInt("beneficiary_limit")%>
</td>

<td>
₹<%=rs.getDouble("distributed_amount")%>
</td>

<td>
₹<%=rs.getDouble("remaining_balance")%>
</td>

<td>
<%=rs.getInt("beneficiaries_served")%>
</td>

<td class="status-active">
<%=rs.getString("status")%>
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
&copy; 2026 Integrated Eligibility System
</div>

</div>



</body>

</html>