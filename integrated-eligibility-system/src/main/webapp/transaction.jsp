<%@page import="java.sql.*"%>
<%@page import="com.eligibility.util.DBConnection"%>
<%
String email =
(String)session.getAttribute("userEmail");

if(email==null){

response.sendRedirect("auth.jsp");
return;

}
%>
<%

String appId =
request.getParameter("id");

String planId =
request.getParameter("plan");

String userName = "";

String planName = "";
double amount = 0;

try{

Connection con =
DBConnection.getConnection();

PreparedStatement ps1 =
con.prepareStatement(

"select plan_name from plans where plan_id=?"

);

ps1.setString(
1,
planId
);

ResultSet rs1 =
ps1.executeQuery();

if(rs1.next()){

planName =
rs1.getString(
"plan_name"
);

}

if(planId.equals("PLN-001")){

PreparedStatement ps =
con.prepareStatement(

"select full_name,user_email from snap_applications where application_id=?"

);

ps.setInt(
1,
Integer.parseInt(appId)
);

ResultSet rs =
ps.executeQuery();

if(rs.next()){

userName =
rs.getString(
"full_name"
);

email =
rs.getString(
"user_email"
);

}

amount = 1;

}

else if(planId.equals("PLN-002")){

PreparedStatement ps =
con.prepareStatement(

"select full_name,user_email from ccap_applications where application_id=?"

);

ps.setInt(
1,
Integer.parseInt(appId)
);

ResultSet rs =
ps.executeQuery();

if(rs.next()){

userName =
rs.getString(
"full_name"
);

email =
rs.getString(
"user_email"
);

}

amount = 1;

}

else if(planId.equals("PLN-003")){

PreparedStatement ps =
con.prepareStatement(

"select full_name,user_email from medicaid_applications where application_id=?"

);

ps.setInt(
1,
Integer.parseInt(appId)
);

ResultSet rs =
ps.executeQuery();

if(rs.next()){

userName =
rs.getString(
"full_name"
);

email =
rs.getString(
"user_email"
);

}

amount = 2;

}

else if(planId.equals("PLN-004")){

PreparedStatement ps =
con.prepareStatement(

"select full_name,user_email from medicare_applications where application_id=?"

);

ps.setInt(
1,
Integer.parseInt(appId)
);

ResultSet rs =
ps.executeQuery();

if(rs.next()){

userName =
rs.getString(
"full_name"
);

email =
rs.getString(
"user_email"
);

}

amount = 2;

}

else if(planId.equals("PLN-005")){

PreparedStatement ps =
con.prepareStatement(

"select full_name,user_email from qhp_applications where application_id=?"

);

ps.setInt(
1,
Integer.parseInt(appId)
);

ResultSet rs =
ps.executeQuery();

if(rs.next()){

userName =
rs.getString(
"full_name"
);

email =
rs.getString(
"user_email"
);

}

amount = 3;

}

con.close();

}catch(Exception e){

e.printStackTrace();

}

%>

<!DOCTYPE html>
<html>
<head>

<title>Transaction Page</title>

<style>


*{
margin:0;
padding:0;
box-sizing:border-box;
font-family:'Segoe UI',sans-serif;
}

body{

background:
linear-gradient(rgba(2,8,25,.85),
rgba(2,8,25,.85)),
url('https://images.unsplash.com/photo-1516574187841-cb9cc2ca948b?w=1600');

background-size:cover;
background-position:center;
background-attachment:fixed;

color:white;
min-height:100vh;
}

.header{

height:85px;

background:rgba(6,16,31,.90);

backdrop-filter:blur(15px);

display:flex;

justify-content:space-between;

align-items:center;

padding:0 40px;

border-bottom:1px solid rgba(255,255,255,.08);
}

.logo{

font-size:34px;

font-weight:bold;

color:#22c55e;
}

.header-buttons a{

text-decoration:none;

color:white;

background:#22c55e;

padding:12px 22px;

border-radius:30px;

margin-left:10px;

font-weight:600;

transition:.3s;
}

.header-buttons a:hover{

background:#16a34a;
}

.container{

width:700px;

margin:50px auto;

background:rgba(255,255,255,.05);

backdrop-filter:blur(15px);

padding:35px;

border-radius:20px;

border:1px solid rgba(255,255,255,.08);

box-shadow:0 10px 30px rgba(0,0,0,.3);
}

h2{

text-align:center;

color:#22c55e;

font-size:32px;

margin-bottom:25px;
}

.info{

background:rgba(255,255,255,.04);

padding:15px;

border-radius:12px;

margin-bottom:15px;

font-size:18px;
}

.pay-btn{

width:100%;

padding:15px;

background:#22c55e;

color:white;

border:none;

font-size:18px;

font-weight:bold;

cursor:pointer;

border-radius:12px;

transition:.3s;
}

.pay-btn:hover{

background:#16a34a;

transform:translateY(-2px);
}

.footer{

position:fixed;

bottom:0;

left:0;

right:0;

height:45px;

background:rgba(6,16,31,.90);

backdrop-filter:blur(15px);

display:flex;

align-items:center;

justify-content:center;

border-top:1px solid rgba(255,255,255,.08);

font-size:13px;

color:#d1d5db;
}



</style>

</head>

<body>


<div class="header">

<div class="logo">
IES
</div>

<div class="header-buttons">

<a href="userDashboard.jsp">
Dashboard
</a>

<a href="plans.jsp">
Plans
</a>

<a href="transaction.jsp">
Transactions
</a>

<a href="benefits.jsp">
Benefits
</a>

<a href="track.jsp">
Track
</a>

<a href="index.jsp">
LogOut
</a>

</div>

</div>


<div class="container" style="margin-top:40px;">

<h2>Application Payment</h2>

<div class="info">
<b>Application ID :</b>
<%=appId%>
</div>

<div class="info">
<b>Name :</b>
<%=userName%>
</div>

<div class="info">
<b>Email :</b>
<%=email%>
</div>

<div class="info">
<b>Plan :</b>
<%=planName%>
</div>

<div class="info">
<b>Amount :</b>
₹<%=amount%>
</div>

<form action="CreateOrderServlet" method="post">

<input
type="hidden"
name="applicationId"
value="<%=appId%>">

<input
type="hidden"
name="userName"
value="<%=userName%>">

<input
type="hidden"
name="email"
value="<%=email%>">

<input
type="hidden"
name="planId"
value="<%=planId%>">

<input
type="hidden"
name="planName"
value="<%=planName%>">

<input
type="hidden"
name="amount"
value="<%=amount%>">

<button
class="pay-btn"
type="submit">

Pay Now

</button>

</form>

</div>

<div class="footer">

© 2026 Integrated Eligibility System

</div>


</body>
</html>