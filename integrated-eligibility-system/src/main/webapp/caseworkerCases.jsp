
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
<title>Case Verification</title>

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
rgba(10,15,30,.85),
rgba(10,15,30,.85)
),
url('https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?w=1600');

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

backdrop-filter:blur(15px);

display:flex;

justify-content:space-between;

align-items:center;

padding:0 40px;

border-bottom:1px solid rgba(255,255,255,.08);

position:sticky;
top:0;
z-index:999;
}

.logo-section{

display:flex;

align-items:center;

gap:12px;

font-size:28px;

font-weight:bold;

color:#ff8c00;
}

.logo-section img{

width:50px;
height:50px;
border-radius:50%;
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

color:white;

transform:translateY(-2px);
}

/* MAIN */

.main{

padding:30px;
}

/* REMOVE SIDEBAR LOOK */

.sidebar{

display:none;
}

/* CONTENT */

.content{

width:100%;

padding:0;
}

.content h1{

font-size:38px;

margin-bottom:25px;

font-weight:700;
}

/* TABLE */

.table-box{

background:rgba(255,255,255,.08);

backdrop-filter:blur(15px);

border-radius:25px;

padding:20px;

box-shadow:0 10px 30px rgba(0,0,0,.3);
}

table{

width:100%;

border-collapse:collapse;
}

thead{

background:#ff8c00;
}

th{

padding:18px;

color:white;

font-size:16px;
}

td{

padding:18px;

text-align:center;

border-bottom:1px solid rgba(255,255,255,.08);

color:white;
}

tr:hover{

background:rgba(255,255,255,.04);
}

/* BUTTONS */

.view-btn{

background:#ff8c00;

border:none;

padding:10px 20px;

border-radius:30px;

color:white;

font-weight:bold;

cursor:pointer;

transition:.3s;
}

.view-btn:hover{

background:#ff9f1c;

transform:translateY(-2px);
}

.remove-btn{

background:#ef4444;

border:none;

padding:10px 20px;

border-radius:30px;

color:white;

font-weight:bold;

cursor:pointer;
}

/* POPUP */

#popup{

background:#111827 !important;

color:white;

border-radius:20px !important;

border:1px solid rgba(255,255,255,.1);
}

#popup h3{

color:#ff8c00;
margin-bottom:15px;
}

/* DOCUMENT SECTION */

#documentSection{

background:rgba(255,255,255,.08);

padding:25px;

border-radius:20px;

backdrop-filter:blur(15px);
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

<!-- HEADER -->

<div class="header">

<div class="logo-section">

<img src="https://cdn-icons-png.flaticon.com/512/3135/3135715.png">

<span>IES CASEWORKER</span>

</div>


<div class="menu">

<a href="caseworkerDashboard.jsp">
Dashboard
</a>

<a href="documentVerification.jsp" >
Verification
</a>

<a href="caseworkerCases.jsp" class="active">
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

<!-- MAIN -->

<div class="main">

<!-- SIDEBAR -->

<div class="sidebar">

<a href="caseworkerCases.jsp">
Cases
</a>

<a href="#"
onclick="showDocumentsSection()">
Documents
</a>

</div>

<!-- CONTENT -->

<div class="content">
<div id="caseSection">
<h1>
Case Verification
</h1>

<div class="table-box">

<table>

<thead>

<tr>

<th>ID</th>
<th>Plan</th>
<th>User</th>

<th>Payment</th>

<th>Status</th>
<th>Action</th>

</tr>

</thead>

<tbody>



<%@ page import="java.sql.*" %>
<%@ page import="com.eligibility.util.DBConnection" %>

<%

try{

Connection con =
DBConnection.getConnection();


PreparedStatement ps =
con.prepareStatement(
		
		

				"SELECT application_id,plan_id,full_name,payment_status,status,ai_score,ai_status,ai_reason,ai_remark FROM snap_applications " +

				"UNION ALL " +

				"SELECT application_id,plan_id,full_name,payment_status,status,ai_score,ai_status,ai_reason,ai_remark FROM ccap_applications " +

				"UNION ALL " +

				"SELECT application_id,plan_id,full_name,payment_status,status,ai_score,ai_status,ai_reason,ai_remark FROM medicaid_applications " +

				"UNION ALL " +

				"SELECT application_id,plan_id,full_name,payment_status,status,ai_score,ai_status,ai_reason,ai_remark FROM medicare_applications " +

				"UNION ALL " +

				"SELECT application_id,plan_id,full_name,payment_status,status,ai_score,ai_status,ai_reason,ai_remark FROM qhp_applications " +

				"ORDER BY application_id DESC"

				);





ResultSet rs =
ps.executeQuery();

while(rs.next()){

%>

<tr>

<!-- ID -->

<td>
<%=rs.getInt("application_id")%>
</td>

<!-- PLAN -->

<td>

<%
String planId = rs.getString("plan_id");

if("PLN-001".equals(planId)){
    out.print("SNAP");
}
else if("PLN-002".equals(planId)){
    out.print("CCAP");
}
else if("PLN-003".equals(planId)){
    out.print("MEDICAID");
}
else if("PLN-004".equals(planId)){
    out.print("MEDICARE");
}
else if("PLN-005".equals(planId)){
    out.print("QHP");
}
else{
    out.print(planId);
}
%>

</td>

<!-- USER -->

<td>
<%=rs.getString("full_name")%>
</td>





<td>
<%=rs.getString("payment_status")%>
</td>



<td>
<%=rs.getString("status")%>
</td>

<td>



<%
String appStatus = rs.getString("status");

if("PENDING".equalsIgnoreCase(appStatus)){
%>

<button class="view-btn"
onclick="openPopup(
'<%=rs.getInt("application_id")%>',
'<%=rs.getString("plan_id")%>',
'<%=rs.getString("full_name")%>',
'<%=rs.getString("payment_status")%>',
'<%=rs.getString("status")%>',
'<%=rs.getInt("ai_score")%>',
'<%=rs.getString("ai_status")%>',
'<%=rs.getString("ai_reason")%>',
'<%=rs.getString("ai_remark")%>'
)">
View
</button>

<%
}else{
%>

<b><%=appStatus%></b>

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

</tbody>




</table>

</div>

</div>




<div id="documentSection"
style="display:none;">

<h1>Document Request</h1>

<p>
Application ID :
<span id="docAppId"></span>
</p>

<p>
User Name :
<span id="docUser"></span>
</p>

<p>
Plan :
<span id="docPlan"></span>
</p>

<h3>Required Documents</h3>

<div id="requiredDocs"></div>

<br>

<button
class="view-btn"
onclick="window.location.href=
'SendRequestServlet?id='
+currentId+
'&plan='
+currentPlan;">
Send Request
</button>

<button class="view-btn">
Pending Requests
</button>

<button class="view-btn">
History
</button>

</div>


<div id="popup"
style="
display:none;
position:fixed;
top:50%;
left:50%;
transform:translate(-50%,-50%);
background:white;
padding:20px;
width:700px;
border-radius:10px;
box-shadow:0 0 10px rgba(0,0,0,.3);
z-index:9999;">

<h3>Eligibility Analysis</h3>

<p>
<b>AI Score:</b>
<span id="aiScore"></span>
</p>

<p>
<b>AI Status:</b>
<span id="aiStatus"></span>
</p>

<p>
<b>AI Reason:</b>
<span id="aiReason"></span>
</p>

<p>
<b>Recommendation:</b>
<span id="recommendation"></span>
</p>
<hr>

<div style="margin-top:20px;text-align:center;">

<button
class="view-btn"
style="margin-right:10px;"
onclick="approveApplication()">
Approve
</button>

<button
class="remove-btn"
style="margin-right:10px;">
Reject
</button>

<button
onclick="document.getElementById('popup').style.display='none'">
Close
</button>

</div>

</div> <!-- popup -->

</div> <!-- content -->

</div> <!-- main -->

<div class="footer">
© 2026 Integrated Eligibility System
</div>
<script>

var currentId="";
var currentName="";
var currentPlan="";

function openPopup(
id,
plan,
name,
payment,
status,
score,
aiStatus,
reason,
remark
){

currentId=id;
currentName=name;
currentPlan=plan;

document.getElementById("popup").style.display="block";

document.getElementById("aiScore").innerHTML=score;
document.getElementById("aiStatus").innerHTML=aiStatus;
document.getElementById("aiReason").innerHTML=reason;
document.getElementById("recommendation").innerHTML=remark;

}

function approveApplication(){

document.getElementById("popup").style.display="none";

document.getElementById("caseSection").style.display="none";

document.getElementById("documentSection").style.display="block";

document.getElementById("docAppId").innerHTML=currentId;

document.getElementById("docUser").innerHTML=currentName;

document.getElementById("docPlan").innerHTML=currentPlan;

var docs="";

if(currentPlan=="PLN-001"){

docs=
"✓ Aadhaar Card<br>" +
"✓ Income Certificate<br>" +
"✓ Ration Card<br>" +
"✓ Address Proof";

}
else if(currentPlan=="PLN-002"){

docs=
"✓ Aadhaar Card<br>" +
"✓ Birth Certificate<br>" +
"✓ Income Certificate";

}
else if(currentPlan=="PLN-003"){

docs=
"✓ Aadhaar Card<br>" +
"✓ Income Certificate<br>" +
"✓ Medical Certificate";

}
else if(currentPlan=="PLN-004"){

docs=
"✓ Aadhaar Card<br>" +
"✓ Age Proof<br>" +
"✓ Income Certificate<br>" +
"✓ Medical Certificate";

}
else if(currentPlan=="PLN-005"){

docs=
"✓ Aadhaar Card<br>" +
"✓ PAN Card<br>" +
"✓ Income Certificate";

}

document.getElementById("requiredDocs").innerHTML=docs;

}function showDocumentsSection(){

	document.getElementById(
	"caseSection"
	).style.display="none";

	document.getElementById(
	"documentSection"
	).style.display="block";

	}
	
function sendRequest(){

	localStorage.setItem(
	"documentRequest",
	"YES"
	);

	alert(
	"Document Request Sent Successfully"
	);

	}

</script>
</body>
</html>
