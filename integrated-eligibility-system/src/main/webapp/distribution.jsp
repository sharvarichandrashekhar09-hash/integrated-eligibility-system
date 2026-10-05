<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
<title>Distribution – IES Admin</title>
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

/* ── CONTENT ── */
.content {
  flex: 1;
  padding: 30px;
  overflow-y: auto;
}.header{

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

.page-title {
  font-size: 32px;
  font-weight: bold;
  margin-bottom: 6px;
}

.page-subtitle {
  color: #9ca3af;
  margin-bottom: 25px;
}

/* ── STAT CARDS ── */
.stats {
  display: flex;
  gap: 18px;
  margin-bottom: 28px;
  flex-wrap: wrap;
}

.stat-card {
  background: #111827;
  border-radius: 16px;
  padding: 20px 28px;
  flex: 1;
  min-width: 160px;
  border-left: 4px solid #ff7b00;
}

.stat-card .num {
  font-size: 32px;
  font-weight: bold;
  color: #ff7b00;
}

.stat-card .label {
  font-size: 13px;
  color: #9ca3af;
  margin-top: 4px;
}

/* ── FILTER BAR ── */
.filter-bar {
  display: flex;
  gap: 12px;
  margin-bottom: 20px;
  flex-wrap: wrap;
  align-items: center;
}

.filter-bar select,
.filter-bar input {
  background: #111827;
  border: 1px solid #1f2937;
  color: white;
  padding: 10px 16px;
  border-radius: 10px;
  font-size: 14px;
  outline: none;
}

.filter-bar select option { background: #111827; }

/* ── TABLE ── */
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
  padding: 14px 12px;
  text-align: center;
  font-size: 13px;
  white-space: nowrap;
}

td {
  padding: 13px 12px;
  text-align: center;
  border-bottom: 1px solid #1f2937;
  color: white;
  font-size: 13px;
}

tr:hover { background: #1e293b; }

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

.badge-pending  { background: #78350f; color: #fcd34d; }
.badge-provided { background: #166534; color: #86efac; }

.provide-btn {
  background: #ff7b00;
  color: white;
  border: none;
  padding: 9px 16px;
  border-radius: 8px;
  cursor: pointer;
  font-size: 13px;
  font-weight: bold;
  transition: .2s;
  white-space: nowrap;
}

.provide-btn:hover { background: #e06900; transform: scale(1.04); }

.provided-label {
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

/* ── MODAL OVERLAY ── */
.modal-overlay {
  display: none;
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.75);
  z-index: 999;
  justify-content: center;
  align-items: center;
}

.modal-overlay.active { display: flex; }

.modal {
  background: #111827;
  border: 1px solid #1f2937;
  border-radius: 20px;
  padding: 32px;
  width: 520px;
  max-width: 95vw;
  max-height: 90vh;
  overflow-y: auto;
  position: relative;
}

.modal h2 {
  font-size: 20px;
  font-weight: bold;
  color: #ff7b00;
  margin-bottom: 20px;
  border-bottom: 1px solid #1f2937;
  padding-bottom: 12px;
}

.modal-section {
  margin-bottom: 18px;
}

.modal-section h4 {
  font-size: 12px;
  color: #9ca3af;
  text-transform: uppercase;
  letter-spacing: 1px;
  margin-bottom: 10px;
}

.info-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 10px;
}

.info-item label {
  display: block;
  font-size: 11px;
  color: #6b7280;
  margin-bottom: 2px;
}

.info-item span {
  font-size: 14px;
  color: white;
  font-weight: 500;
}

.benefit-box {
  background: #0f172a;
  border: 1px solid #ff7b0033;
  border-radius: 12px;
  padding: 14px 18px;
  font-size: 14px;
  color: #fcd34d;
  line-height: 1.9;
}

.modal-actions {
  display: flex;
  gap: 12px;
  margin-top: 24px;
}

.btn-confirm {
  flex: 1;
  background: #ff7b00;
  color: white;
  border: none;
  padding: 13px;
  border-radius: 10px;
  font-size: 15px;
  font-weight: bold;
  cursor: pointer;
  transition: .2s;
}

.btn-confirm:hover { background: #e06900; }

.btn-cancel {
  flex: 1;
  background: #1f2937;
  color: #9ca3af;
  border: none;
  padding: 13px;
  border-radius: 10px;
  font-size: 15px;
  cursor: pointer;
  transition: .2s;
}

.btn-cancel:hover { background: #374151; color: white; }

.close-modal {
  position: absolute;
  top: 16px;
  right: 20px;
  background: none;
  border: none;
  color: #9ca3af;
  font-size: 22px;
  cursor: pointer;
}

.close-modal:hover { color: white; }

.footer {
  margin-top: 20px;
  text-align: center;
  color: #9ca3af;
  font-size: 12px;
}

/* success toast */
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

<a href="manageAcc.jsp">
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

<a href="distribution.jsp" class="active">
Distribution
</a>

<a href="LogoutServlet">
Logout
</a>

</div>

</div>

<!-- ═══════════════ TOAST ═══════════════ -->
<div class="toast" id="toast">✅ Benefit Provided Successfully!</div>

<!-- ═══════════════ MODAL ═══════════════ -->
<div class="modal-overlay" id="modalOverlay">
  <div class="modal">
    <button class="close-modal" onclick="closeModal()">✕</button>
    <h2>🎁 Provide Benefit Confirmation</h2>

    <div class="modal-section">
      <h4>Applicant Details</h4>
      <div class="info-grid">
        <div class="info-item">
          <label>Full Name</label>
          <span id="m_name">–</span>
        </div>
        <div class="info-item">
          <label>Plan</label>
          <span id="m_plan">–</span>
        </div>
        <div class="info-item">
          <label>Mobile</label>
          <span id="m_mobile">–</span>
        </div>
        <div class="info-item">
          <label>Email</label>
          <span id="m_email">–</span>
        </div>
        <div class="info-item">
          <label>City / State</label>
          <span id="m_location">–</span>
        </div>
        <div class="info-item">
          <label>Family Members</label>
          <span id="m_family">–</span>
        </div>
        <div class="info-item">
          <label>Annual Income</label>
          <span id="m_income">–</span>
        </div>
        <div class="info-item">
          <label>Aadhaar</label>
          <span id="m_aadhaar">–</span>
        </div>
      </div>
    </div>

    <div class="modal-section">
      <h4>Bank Details</h4>
      <div class="info-grid">
        <div class="info-item">
          <label>Account Holder</label>
          <span id="m_holder">–</span>
        </div>
        <div class="info-item">
          <label>Account No</label>
          <span id="m_accno">–</span>
        </div>
        <div class="info-item">
          <label>IFSC</label>
          <span id="m_ifsc">–</span>
        </div>
      </div>
    </div>

    <div class="modal-section">
      <h4>Benefits to be Provided</h4>
      <div class="benefit-box" id="m_benefits">–</div>
    </div>

    <div class="modal-actions">
      <button class="btn-cancel" onclick="closeModal()">Cancel</button>
      <button class="btn-confirm" onclick="confirmBenefit()">✓ Confirm & Provide</button>
    </div>
  </div>
</div>

<!-- ═══════════════ MAIN LAYOUT ═══════════════ -->
<div class="main">

  <!-- SIDEBAR -->
  

  <!-- CONTENT -->
  <div class="content">

    <div class="page-title">Benefit Distribution</div>
    <div class="page-subtitle">Review verified applicants and provide benefits.</div>

    <%
      // ── DB QUERY ──────────────────────────────────────────────
      int totalPending  = 0;
      int totalProvided = 0;

      Connection con = null;
      PreparedStatement ps = null;
      ResultSet rs = null;

      String filterPlan   = request.getParameter("plan")   != null ? request.getParameter("plan")   : "ALL";
      String filterSearch = request.getParameter("search") != null ? request.getParameter("search") : "";

      String unionSQL =
    	
    		  "SELECT application_id, full_name, user_email, mobile, address, city, state, " +
    		  "       family_members, annual_income, aadhaar, account_holder, account_no, ifsc, " +
    		  "       plan_id, benefit_status, verification_remark, doc_status " +
    		  "FROM snap_applications " +
    		  "WHERE doc_status='VERIFIED' AND final_status='READY' " +

    		  "UNION ALL " +

    		  "SELECT application_id, full_name, user_email, mobile, address, city, '' as state, " +
    		  "       children_count, annual_income, aadhaar, account_holder, account_no, ifsc, " +
    		  "       plan_id, benefit_status, verification_remark, doc_status " +
    		  "FROM ccap_applications " +
    		  "WHERE doc_status='VERIFIED' AND final_status='READY' " +

    		  "UNION ALL " +

    		  "SELECT application_id, full_name, user_email, mobile, address, '' as city, '' as state, " +
    		  "       family_members, annual_income, aadhaar, account_holder, account_no, ifsc, " +
    		  "       plan_id, benefit_status, verification_remark, doc_status " +
    		  "FROM medicaid_applications " +
    		  "WHERE doc_status='VERIFIED' AND final_status='READY' " +

    		  "UNION ALL " +

    		  "SELECT application_id, full_name, user_email, mobile, address, '' as city, '' as state, " +
    		  "       0 as family_members, annual_income, aadhaar, account_holder, account_no, ifsc, " +
    		  "       plan_id, benefit_status, verification_remark, doc_status " +
    		  "FROM medicare_applications " +
    		  "WHERE doc_status='VERIFIED' AND final_status='READY' " +

    		  "UNION ALL " +

    		  "SELECT application_id, full_name, user_email, mobile, address, '' as city, state_name, " +
    		  "       dependent_members, annual_income, aadhaar, account_holder, account_no, ifsc, " +
    		  "       plan_id, benefit_status, verification_remark, doc_status " +
    		  "FROM qhp_applications " +
    		  "WHERE doc_status='VERIFIED' AND final_status='READY' " +

    		  "ORDER BY application_id DESC";

        

      try {
        con = DBConnection.getConnection();
        ps  = con.prepareStatement(unionSQL);
        rs  = ps.executeQuery();

        // count stats first pass
        java.util.List<java.util.Map<String,String>> rows = new java.util.ArrayList<>();

        while(rs.next()){
          java.util.Map<String,String> row = new java.util.LinkedHashMap<>();
          row.put("application_id",    rs.getString("application_id"));
          row.put("full_name",         rs.getString("full_name"));
          row.put("user_email",        rs.getString("user_email"));
          row.put("mobile",            rs.getString("mobile"));
          row.put("address",           rs.getString("address"));
          row.put("city",              rs.getString("city"));
          row.put("state",             rs.getString("state"));
          row.put("family_members",    rs.getString("family_members"));
          row.put("annual_income",     rs.getString("annual_income"));
          row.put("aadhaar",           rs.getString("aadhaar"));
          row.put("account_holder",    rs.getString("account_holder"));
          row.put("account_no",        rs.getString("account_no"));
          row.put("ifsc",              rs.getString("ifsc"));
          row.put("plan_id",           rs.getString("plan_id"));
          row.put("benefit_status",    rs.getString("benefit_status") != null ? rs.getString("benefit_status") : "PENDING");
          row.put("verification_remark", rs.getString("verification_remark"));
          row.put("doc_status",        rs.getString("doc_status"));

          String bs = row.get("benefit_status");
          if("PROVIDED".equals(bs)) totalProvided++;
          else                      totalPending++;

          rows.add(row);
        }
        rs.close(); ps.close();

        // apply filter
        java.util.List<java.util.Map<String,String>> filtered = new java.util.ArrayList<>();
        for(java.util.Map<String,String> row : rows){
          boolean planMatch   = "ALL".equals(filterPlan) || row.get("plan_id").equals(filterPlan);
          boolean searchMatch = filterSearch.isEmpty() ||
                                row.get("full_name").toLowerCase().contains(filterSearch.toLowerCase()) ||
                                row.get("application_id").contains(filterSearch);
          if(planMatch && searchMatch) filtered.add(row);
        }
    %>

    <!-- STATS -->
    <div class="stats">
      <div class="stat-card">
        <div class="num"><%=filtered.size()%></div>
        <div class="label">Total Verified</div>
      </div>
      <div class="stat-card">
        <div class="num"><%=totalPending%></div>
        <div class="label">Pending Benefits</div>
      </div>
      <div class="stat-card">
        <div class="num"><%=totalProvided%></div>
        <div class="label">Benefits Provided</div>
      </div>
    </div>

    <!-- FILTER BAR -->
    <form method="get" action="distribution.jsp">
      <div class="filter-bar">
        <select name="plan" onchange="this.form.submit()">
          <option value="ALL"    <%="ALL".equals(filterPlan)    ?"selected":""%>>All Plans</option>
          <option value="PLN-001"<%="PLN-001".equals(filterPlan)?"selected":""%>>SNAP</option>
          <option value="PLN-002"<%="PLN-002".equals(filterPlan)?"selected":""%>>CCAP</option>
          <option value="PLN-003"<%="PLN-003".equals(filterPlan)?"selected":""%>>Medicaid</option>
          <option value="PLN-004"<%="PLN-004".equals(filterPlan)?"selected":""%>>Medicare</option>
          <option value="PLN-005"<%="PLN-005".equals(filterPlan)?"selected":""%>>QHP</option>
        </select>
        <input type="text" name="search" placeholder="Search by name or App ID..."
               value="<%=filterSearch%>" />
        <button type="submit" class="provide-btn">Search</button>
      </div>
    </form>

    <!-- TABLE -->
    <div class="table-box">
      <table>
        <tr>
          <th>App ID</th>
          <th>Full Name</th>
          <th>Plan</th>
          <th>Mobile</th>
          <th>City / State</th>
          <th>Family</th>
          <th>Annual Income</th>
          <th>Bank Account</th>
          <th>Benefit Status</th>
          <th>Action</th>
        </tr>

        <%
          if(filtered.isEmpty()){
        %>
        <tr>
          <td colspan="10" class="no-data">No verified applications found.</td>
        </tr>
        <%
          } else {
            for(java.util.Map<String,String> row : filtered){

              String pid = row.get("plan_id");
              String planName = "";
              String badgeClass = "";
              if("PLN-001".equals(pid)){ planName="SNAP";     badgeClass="badge-snap"; }
              else if("PLN-002".equals(pid)){ planName="CCAP";     badgeClass="badge-ccap"; }
              else if("PLN-003".equals(pid)){ planName="Medicaid"; badgeClass="badge-medicaid"; }
              else if("PLN-004".equals(pid)){ planName="Medicare"; badgeClass="badge-medicare"; }
              else if("PLN-005".equals(pid)){ planName="QHP";      badgeClass="badge-qhp"; }

              String benefitStatus = row.get("benefit_status");
              String location = "";
              if(row.get("city") != null && !row.get("city").isEmpty()) location += row.get("city");
              if(row.get("state")!= null && !row.get("state").isEmpty()){
                if(!location.isEmpty()) location += ", ";
                location += row.get("state");
              }
              if(location.isEmpty()) location = "–";

              String accDisplay = (row.get("account_no") != null && !row.get("account_no").isEmpty())
                ? "****" + row.get("account_no").substring(Math.max(0, row.get("account_no").length()-4))
                : "–";

              // build benefit string for modal
              String benefits = "";
              int fam = 0;
              try{ fam = Integer.parseInt(row.get("family_members")); } catch(Exception ex){ fam = 1; }

              if("PLN-001".equals(pid)){
                benefits = "• Rice : "  + (fam*5) + " kg<br>" +
                           "• Wheat: "  + (fam*3) + " kg<br>" +
                           "• Sugar: 1 kg (family)<br>" +
                           "• Oil  : 1 Litre (family)";
              } else if("PLN-002".equals(pid)){
                benefits = "• Daycare at nearest Anganwadi<br>" +
                           "• Nutritional meals for child<br>" +
                           "• Basic health checkups<br>" +
                           "• Vaccination support";
              } else if("PLN-003".equals(pid)){
                benefits = "• Free treatment up to ₹5,00,000/year<br>" +
                           "• Hospitalization & surgeries covered<br>" +
                           "• Cashless treatment at empaneled hospitals<br>" +
                           "• Health Card issued";
              } else if("PLN-004".equals(pid)){
                benefits = "• Free / subsidized senior treatment<br>" +
                           "• Regular health checkups<br>" +
                           "• Medicine discount coupons<br>" +
                           "• Priority hospital treatment";
              } else if("PLN-005".equals(pid)){
                benefits = "• Selected Plan: " + (row.get("selected_plan") != null ? row.get("selected_plan") : "–") + "<br>" +
                           "• Hospitalization coverage<br>" +
                           "• Doctor consultation & diagnostics<br>" +
                           "• Partial cashless treatment";
              }
        %>
        <tr>
          <td><%=row.get("application_id")%></td>
          <td><%=row.get("full_name")%></td>
          <td><span class="badge <%=badgeClass%>"><%=planName%></span></td>
          <td><%=row.get("mobile") != null ? row.get("mobile") : "–"%></td>
          <td><%=location%></td>
          <td><%=fam > 0 ? fam : "–"%></td>
          <td>₹ <%=row.get("annual_income") != null ? row.get("annual_income") : "–"%></td>
          <td><%=accDisplay%></td>
          <td>
            <% if("PROVIDED".equals(benefitStatus)){ %>
              <span class="badge badge-provided">PROVIDED</span>
            <% } else { %>
              <span class="badge badge-pending">PENDING</span>
            <% } %>
          </td>
          <td>
            <% if(!"PROVIDED".equals(benefitStatus)){ %>
            <button class="provide-btn" onclick="openModal(
              '<%=row.get("application_id")%>',
              '<%=row.get("full_name").replace("'","\\'")%>',
              '<%=planName%>',
              '<%=pid%>',
              '<%=row.get("mobile") != null ? row.get("mobile") : ""%>',
              '<%=row.get("user_email") != null ? row.get("user_email") : ""%>',
              '<%=location.replace("'","\\'")%>',
              '<%=fam%>',
              '<%=row.get("annual_income") != null ? row.get("annual_income") : ""%>',
              '<%=row.get("aadhaar") != null ? row.get("aadhaar") : ""%>',
              '<%=row.get("account_holder") != null ? row.get("account_holder").replace("'","\\'") : ""%>',
              '<%=row.get("account_no") != null ? row.get("account_no") : ""%>',
              '<%=row.get("ifsc") != null ? row.get("ifsc") : ""%>',
              `<%=benefits%>`
            )">Provide Benefit</button>
            <% } else { %>
              <span class="provided-label">✅ Done</span>
            <% } %>
          </td>
        </tr>
        <%
            } // end for
          } // end else
        %>
      </table>
    </div>

    <%
      } catch(Exception e) {
    %>
    <div style="color:#ef4444;padding:20px;">Error: <%=e.getMessage()%></div>
    <%
      } finally {
        try{ if(con!=null) con.close(); } catch(Exception ex){}
      }
    %>

    <div class="footer">© 2026 Integrated Eligibility System</div>

  </div><!-- /content -->
</div><!-- /main -->

<!-- ═══════════════ HIDDEN FORM ═══════════════ -->
<form id="benefitForm" method="post" action="AdminProvideBenefitServlet">
  <input type="hidden" id="f_appId"   name="application_id" />
  <input type="hidden" id="f_planId"  name="plan_id" />
  <input type="hidden" id="f_email"   name="user_email" />
  <input type="hidden" id="f_name"    name="full_name" />
  <input type="hidden" id="f_plan"    name="plan_name" />
  <input type="hidden" id="f_family"  name="family_members" />
  <input type="hidden" id="f_income"  name="annual_income" />
  <input type="hidden" id="f_accno"   name="account_no" />
  <input type="hidden" id="f_ifsc"    name="ifsc" />
  <input type="hidden" id="f_benefits" name="benefit_details" />
</form>

<script>

let currentAppId  = '';
let currentPlanId = '';

function openModal(appId, name, planName, planId, mobile, email,
                   location, family, income, aadhaar,
                   holder, accNo, ifsc, benefits){

  currentAppId  = appId;
  currentPlanId = planId;

  document.getElementById('m_name').textContent     = name;
  document.getElementById('m_plan').textContent     = planName;
  document.getElementById('m_mobile').textContent   = mobile   || '–';
  document.getElementById('m_email').textContent    = email    || '–';
  document.getElementById('m_location').textContent = location || '–';
  document.getElementById('m_family').textContent   = family   || '–';
  document.getElementById('m_income').textContent   = '₹ ' + (income || '–');
  document.getElementById('m_aadhaar').textContent  = aadhaar  || '–';
  document.getElementById('m_holder').textContent   = holder   || '–';
  document.getElementById('m_accno').textContent    = accNo    || '–';
  document.getElementById('m_ifsc').textContent     = ifsc     || '–';
  document.getElementById('m_benefits').innerHTML   = benefits || '–';

  // fill hidden form
  document.getElementById('f_appId').value    = appId;
  document.getElementById('f_planId').value   = planId;
  document.getElementById('f_email').value    = email;
  document.getElementById('f_name').value     = name;
  document.getElementById('f_plan').value     = planName;
  document.getElementById('f_family').value   = family;
  document.getElementById('f_income').value   = income;
  document.getElementById('f_accno').value    = accNo;
  document.getElementById('f_ifsc').value     = ifsc;
  document.getElementById('f_benefits').value = benefits.replace(/<br>/g, ', ');

  document.getElementById('modalOverlay').classList.add('active');
}

function closeModal(){
  document.getElementById('modalOverlay').classList.remove('active');
}

function confirmBenefit(){
  closeModal();
  document.getElementById('benefitForm').submit();
}

// show toast if redirected with ?success=1
const urlParams = new URLSearchParams(window.location.search);
if(urlParams.get('success') === '1'){
  const toast = document.getElementById('toast');
  toast.style.display = 'block';
  setTimeout(() => toast.style.display = 'none', 3500);
}

</script>
</body>
</html>
