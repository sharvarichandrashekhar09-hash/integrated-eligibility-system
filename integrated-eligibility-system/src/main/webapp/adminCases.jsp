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
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Cases</title>

<style>

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
  font-family: Arial, sans-serif;
}

body {
  background: #070b16;
  color: white;
}

.main{
padding:30px;
}

.sidebar{
display:none;
}

.logo {
  font-size: 30px;
  font-weight: bold;
  color: #ff7b00;
  margin-bottom: 35px;
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

.menu { list-style: none; }
.menu li { margin-bottom: 15px; }
.menu a {
  display: block;
  padding: 14px 18px;
  text-decoration: none;
  color: white;
  border-radius: 12px;
  transition: .3s;
}
.menu a:hover, .active { background: #ff7b00; }

.content {
  flex: 1;
  padding: 30px;
  overflow-y: auto;
}

.page-title {
  font-size: 32px;
  font-weight: bold;
  margin-bottom: 10px;
}

.page-subtitle {
  color: #9ca3af;
  margin-bottom: 25px;
}

.table-box {
  background: #111827;
  padding: 20px;
  border-radius: 20px;
  overflow-x: auto;
}

table {
  width: 100%;
  border-collapse: collapse;
  min-width: 900px;
}

th {
  background: #ff7b00;
  color: white;
  padding: 15px;
  text-align: center;
  white-space: nowrap;
}

td {
  padding: 15px;
  text-align: center;
  border-bottom: 1px solid #1f2937;
  color: white;
  font-size: 13px;
}

tr:hover { background: #1e293b; }

/* ── BADGES ── */
.badge {
  padding: 5px 12px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: bold;
}

.badge-snap     { background: #166534; color: #86efac; }
.badge-ccap     { background: #1e3a5f; color: #93c5fd; }
.badge-medicaid { background: #4a1d96; color: #c4b5fd; }
.badge-medicare { background: #7c2d12; color: #fdba74; }
.badge-qhp      { background: #134e4a; color: #5eead4; }

.badge-verified { background: #166534; color: #86efac; }
.badge-ready    { background: #ff7b00; color: white; }
.badge-paid     { background: #166534; color: #86efac; }

/* ── BUTTONS ── */
.ready-btn {
  background: #ff7b00;
  color: white;
  border: none;
  padding: 10px 18px;
  border-radius: 8px;
  cursor: pointer;
  font-weight: bold;
  font-size: 13px;
  transition: .2s;
  white-space: nowrap;
}

.ready-btn:hover { background: #e06900; transform: scale(1.04); }

.done-label {
  color: #22c55e;
  font-weight: bold;
  font-size: 13px;
}

.no-data {
  text-align: center;
  color: #9ca3af;
  padding: 40px;
  font-size: 15px;
}

/* ── TOAST ── */
.toast {
  position: fixed;
  bottom: 30px;
  right: 30px;
  background: #166534;
  color: #86efac;
  padding: 14px 24px;
  border-radius: 12px;
  font-size: 14px;
  font-weight: bold;
  display: none;
  z-index: 9999;
  box-shadow: 0 4px 20px rgba(0,0,0,0.4);
}

.footer {
  margin-top: 20px;
  text-align: center;
  color: #9ca3af;
  font-size: 12px;
}

</style>

<script>
function markReady(id, planId) {
  if(confirm("Mark this application as Ready for Distribution?")) {
    window.location.href = "AdminMarkReadyServlet?id=" + id + "&plan=" + planId;
  }
}

// show toast if redirected back with ?success=1
window.onload = function(){
  const params = new URLSearchParams(window.location.search);
  if(params.get('success') === '1'){
    const toast = document.getElementById('toast');
    toast.style.display = 'block';
    setTimeout(() => toast.style.display = 'none', 3000);
  }
}
</script>

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

<a href="manageAcc.jsp">
Accounts
</a>

<a href="adminCases.jsp" class="active">
Cases
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

<div class="toast" id="toast">✅ Case marked as Ready for Distribution!</div>

<div class="main">

  <!-- SIDEBAR -->

  <!-- CONTENT -->
  <div class="content">

    <div class="page-title">Admin Case Management</div>
    <div class="page-subtitle">Review verified applications and mark them ready for distribution.</div>

    <div class="table-box">
      <table>
        <tr>
          <th>Application ID</th>
          <th>User</th>
          <th>Plan</th>
          <th>Payment</th>
          <th>Document Status</th>
          <th>Caseworker Remark</th>
          <th>Final Status</th>
          <th>Action</th>
        </tr>

        <%
        try {

          Connection con = DBConnection.getConnection();

          PreparedStatement ps = con.prepareStatement(
            "SELECT application_id, full_name, plan_id, payment_status, " +
            "       doc_status, verification_remark, final_status " +
            "FROM snap_applications WHERE doc_status='VERIFIED' " +

            "UNION ALL " +

            "SELECT application_id, full_name, plan_id, payment_status, " +
            "       doc_status, verification_remark, final_status " +
            "FROM ccap_applications WHERE doc_status='VERIFIED' " +

            "UNION ALL " +

            "SELECT application_id, full_name, plan_id, payment_status, " +
            "       doc_status, verification_remark, final_status " +
            "FROM medicaid_applications WHERE doc_status='VERIFIED' " +

            "UNION ALL " +

            "SELECT application_id, full_name, plan_id, payment_status, " +
            "       doc_status, verification_remark, final_status " +
            "FROM medicare_applications WHERE doc_status='VERIFIED' " +

            "UNION ALL " +

            "SELECT application_id, full_name, plan_id, payment_status, " +
            "       doc_status, verification_remark, final_status " +
            "FROM qhp_applications WHERE doc_status='VERIFIED' " +

            "ORDER BY application_id DESC"
          );

          ResultSet rs = ps.executeQuery();
          boolean found = false;

          while(rs.next()) {
            found = true;

            String planId    = rs.getString("plan_id");
            String planName  = "";
            String planBadge = "";

            if("PLN-001".equals(planId)){ planName="SNAP";     planBadge="badge-snap"; }
            else if("PLN-002".equals(planId)){ planName="CCAP";     planBadge="badge-ccap"; }
            else if("PLN-003".equals(planId)){ planName="Medicaid"; planBadge="badge-medicaid"; }
            else if("PLN-004".equals(planId)){ planName="Medicare"; planBadge="badge-medicare"; }
            else if("PLN-005".equals(planId)){ planName="QHP";      planBadge="badge-qhp"; }

            String finalStatus = rs.getString("final_status");
            boolean isReady    = "READY".equals(finalStatus);
        %>

        <tr>
          <td><%=rs.getString("application_id")%></td>
          <td><%=rs.getString("full_name")%></td>
          <td><span class="badge <%=planBadge%>"><%=planName%></span></td>
          <td><span class="badge badge-paid"><%=rs.getString("payment_status")%></span></td>
          <td><span class="badge badge-verified"><%=rs.getString("doc_status")%></span></td>
          <td><%=rs.getString("verification_remark") != null ? rs.getString("verification_remark") : "–"%></td>

          <!-- Final Status -->
          <td>
            <% if(isReady){ %>
              <span class="badge badge-ready">✅ READY</span>
            <% } else { %>
              <span style="color:#9ca3af; font-size:13px;">Pending Review</span>
            <% } %>
          </td>

          <!-- Action -->
          <td>
            <% if(!isReady){ %>
              <button class="ready-btn"
                onclick="markReady('<%=rs.getString("application_id")%>','<%=planId%>')">
                Mark Ready
              </button>
            <% } else { %>
              <span class="done-label">✔ Sent to Distribution</span>
            <% } %>
          </td>
        </tr>

        <%
          } // end while

          if(!found){
        %>
        <tr>
          <td colspan="8" class="no-data">No verified applications found.</td>
        </tr>
        <%
          }

          rs.close();
          ps.close();
          con.close();

        } catch(Exception e) {
        %>
        <tr>
          <td colspan="8" style="color:#ef4444; padding:20px;">
            Error: <%=e.getMessage()%>
          </td>
        </tr>
        <%
        }
        %>

      </table>
    </div>

    <div class="footer">© 2026 Integrated Eligibility System</div>

  </div>
</div>

</body>
</html>
