<%@page import="java.sql.*"%>
<%@page import="com.eligibility.util.DBConnection"%>
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

<title>Payment Records</title>

<style>

*{
margin:0;
padding:0;
box-sizing:border-box;
font-family:'Segoe UI',sans-serif;
}

body{

background:
linear-gradient(
rgba(10,15,30,.88),
rgba(10,15,30,.88)
),
url('https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=1600');

background-size:cover;
background-position:center;
background-attachment:fixed;

color:white;
min-height:100vh;
}

/* HEADER */

.header{

height:90px;

background:rgba(8,15,25,.95);

display:flex;

justify-content:space-between;

align-items:center;

padding:0 40px;

border-bottom:1px solid rgba(255,255,255,.08);

position:sticky;
top:0;
z-index:999;
}

.logo{

font-size:28px;

font-weight:bold;

color:#ff8c00;
}

.menu{

display:flex;

gap:15px;
}

.menu a{

text-decoration:none;

padding:12px 22px;

border-radius:30px;

background:rgba(255,255,255,.08);

color:white;

font-weight:600;

transition:.3s;
}

.menu a:hover,
.menu a.active{

background:#ff8c00;

transform:translateY(-2px);
}

/* CONTENT */

.container{

width:95%;

margin:30px auto;

background:rgba(255,255,255,.08);

backdrop-filter:blur(15px);

padding:25px;

border-radius:25px;

box-shadow:0 10px 30px rgba(0,0,0,.3);
}

h2{

text-align:center;

color:#ff8c00;

margin-bottom:25px;

font-size:32px;
}

/* TABLE */

table{

width:100%;

border-collapse:collapse;
}

table th{

background:#ff8c00;

color:white;

padding:15px;
}

table td{

padding:14px;

text-align:center;

border-bottom:1px solid rgba(255,255,255,.08);

color:white;
}

tr:hover{

background:rgba(255,255,255,.05);
}

/* BUTTONS */

.btn{

padding:10px 18px;

border:none;

border-radius:30px;

color:white;

text-decoration:none;

font-weight:bold;

display:inline-block;

transition:.3s;
}

.receipt{

background:#2563eb;
}

.receipt:hover{

background:#1d4ed8;
}

.email{

background:#ff8c00;
}

.email:hover{

background:#f97316;
}

/* FOOTER */

.footer{

height:55px;

background:rgba(8,15,25,.95);

display:flex;

justify-content:center;

align-items:center;

margin-top:30px;

color:#9ca3af;

border-top:1px solid rgba(255,255,255,.08);
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

<a href="documentVerification.jsp">
Verification
</a>

<a href="caseworkerCases.jsp">
Cases
</a>

<a href="payments.jsp" class="active">
Payment
</a>

<a href="LogoutServlet">
Logout
</a>

</div>

</div>

<div class="container">

<h2>

Payment Records

</h2>

<table>

<tr>

<th>Transaction ID</th>

<th>Name</th>

<th>Email</th>

<th>Plan</th>

<th>Amount</th>

<th>Status</th>

<th>Date</th>

<th>Receipt</th>

<th>Email</th>

</tr>

<%

Connection con =
DBConnection.getConnection();

Statement st =
con.createStatement();

ResultSet rs =

st.executeQuery(

"SELECT * FROM payments ORDER BY payment_date DESC"

);

while(rs.next()){

%>

<tr>

<td>

<%=rs.getString(
"transaction_id"
)%>

</td>

<td>

<%=rs.getString(
"user_name"
)%>

</td>

<td>

<%=rs.getString(
"user_email"
)%>

</td>

<td>

<%=rs.getString(
"plan_name"
)%>

</td>

<td>

₹<%=rs.getDouble(
"amount"
)%>

</td>

<td>

<%=rs.getString(
"payment_status"
)%>

</td>

<td>

<%=rs.getTimestamp(
"payment_date"
)%>

</td>

<td>

<a

class="btn receipt"

href="ReceiptServlet?txn=<%=rs.getString("transaction_id")%>">

View Receipt

</a>

</td>

<td>

<a

class="btn email"

href="SendReceiptServlet?txn=<%=rs.getString("transaction_id")%>">

Send Receipt

</a>

</td>

</tr>

<%

}

con.close();

%>

</table>

</div>
<div class="footer">
© 2026 Integrated Eligibility System
</div>
</body>
</html>