<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.eligibility.util.DBConnection" %>

<%
    String email = (String) session.getAttribute("userEmail");
    if (email == null) {
        response.sendRedirect("auth.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Benefits – IES</title>

<style>

*{
margin:0;
padding:0;
box-sizing:border-box;
font-family:Arial,sans-serif;
}

body{
background:url('https://images.unsplash.com/photo-1521791136064-7986c2920216?q=80&w=1470&auto=format&fit=crop')
no-repeat center center/cover;
background-attachment:fixed;
min-height:100vh;
overflow-x:hidden;
}

.overlay{
background:rgba(0,0,0,.80);
min-height:100vh;
}

/* HEADER */

.topbar{
width:100%;
height:85px;
background:rgba(0,0,0,.45);
backdrop-filter:blur(10px);
display:flex;
justify-content:space-between;
align-items:center;
padding:0 30px;
border-bottom:1px solid rgba(255,255,255,.08);
}

.logo{
font-size:34px;
font-weight:bold;
color:#22c55e;
}

.nav-buttons{
display:flex;
align-items:center;
gap:10px;
flex-wrap:wrap;
}

.nav-buttons a{
text-decoration:none;
color:white;
padding:12px 18px;
border-radius:10px;
transition:.3s;
font-size:14px;
}

.nav-buttons a:hover,
.nav-buttons a.active{
background:#22c55e;
}

.logout-btn{
padding:12px 20px;
border:none;
border-radius:30px;
background:#22c55e;
color:white;
cursor:pointer;
font-weight:bold;
}

.logout-btn:hover{
background:#16a34a;
}

/* CONTENT */

.content{
padding:35px;
color:white;
width:100%;
}

.page-title{
font-size:38px;
font-weight:bold;
margin-bottom:8px;
}

.page-subtitle{
color:#9ca3af;
margin-bottom:30px;
}

/* STATS */

.stats{
display:flex;
gap:20px;
flex-wrap:wrap;
margin-bottom:30px;
}

.stat-card{
background:rgba(255,255,255,.08);
backdrop-filter:blur(10px);
padding:25px;
border-radius:18px;
flex:1;
min-width:200px;
border-left:4px solid #22c55e;
}

.num{
font-size:34px;
font-weight:bold;
color:#22c55e;
}

.label{
color:#9ca3af;
margin-top:5px;
}

/* NO BENEFITS */

.no-benefits{
background:rgba(255,255,255,.08);
backdrop-filter:blur(10px);
padding:60px;
border-radius:20px;
text-align:center;
}

.no-benefits h3{
font-size:24px;
margin-bottom:10px;
}

/* BENEFIT CARDS */

.cards-grid{
display:grid;
grid-template-columns:repeat(auto-fill,minmax(340px,1fr));
gap:25px;
}

.benefit-card{
background:rgba(255,255,255,.08);
backdrop-filter:blur(12px);
border-radius:20px;
overflow:hidden;
transition:.3s;
}

.benefit-card:hover{
transform:translateY(-5px);
}

.card-header{
padding:18px 22px;
display:flex;
justify-content:space-between;
align-items:center;
}

.plan-snap .card-header{
background:linear-gradient(135deg,#166534,#15803d);
}

.plan-ccap .card-header{
background:linear-gradient(135deg,#1e40af,#2563eb);
}

.plan-medicaid .card-header{
background:linear-gradient(135deg,#6d28d9,#8b5cf6);
}

.plan-medicare .card-header{
background:linear-gradient(135deg,#c2410c,#ea580c);
}

.plan-qhp .card-header{
background:linear-gradient(135deg,#0f766e,#14b8a6);
}

.plan-name{
font-size:20px;
font-weight:bold;
}

.status-badge{
padding:6px 14px;
border-radius:20px;
background:rgba(255,255,255,.2);
font-size:12px;
}

.card-body{
padding:20px;
}

.validity{
display:flex;
justify-content:space-between;
background:rgba(0,0,0,.25);
padding:12px 15px;
border-radius:10px;
margin-bottom:15px;
}

.validity label{
font-size:11px;
color:#9ca3af;
display:block;
}

.validity span{
font-weight:bold;
}

.benefit-item{
display:flex;
gap:10px;
padding:8px 0;
color:#d1d5db;
}

.dot{
width:7px;
height:7px;
background:#22c55e;
border-radius:50%;
margin-top:6px;
}

.active-tag{
display:flex;
align-items:center;
gap:8px;
color:#22c55e;
font-weight:bold;
margin-top:10px;
}

.pulse{
width:8px;
height:8px;
background:#22c55e;
border-radius:50%;
animation:pulse 1.5s infinite;
}

@keyframes pulse{
0%,100%{
box-shadow:0 0 0 0 rgba(34,197,94,.4);
}
50%{
box-shadow:0 0 0 6px rgba(34,197,94,0);
}
}

/* FOOTER */

.footer{
margin-top:50px;
padding:20px;
text-align:center;
color:#9ca3af;
border-top:1px solid rgba(255,255,255,.08);
}

</style>
</head>
<body>


    <!-- MAIN -->
    <div class="main">

        <!-- SIDEBAR -->
      <div class="topbar">

<div class="logo">
IES
</div>

<div class="nav-buttons">

<a href="userDashboard.jsp">
Dashboard
</a>

<a href="plans.jsp">
Plans
</a>

<a href="transaction.jsp">
Transactions
</a>

<a href="benefits.jsp" class="active">
Benefits
</a>

<a href="track.jsp">
Track
</a>


<form action="LogoutServlet" method="post" style="display:inline;">

<button class="logout-btn">
Logout
</button>

</form>

</div>

</div>
        <!-- CONTENT -->
        <div class="content">

            <div class="page-title"> My Benefits</div>
            <div class="page-subtitle">All your active government benefit plans in one place.</div>

            <%
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            int totalBenefits  = 0;
            int activePlans    = 0;

            java.util.List<java.util.Map<String,String>> benefits = new java.util.ArrayList<>();

            try {
                con = DBConnection.getConnection();

                ps = con.prepareStatement(
                    "SELECT id, application_id, plan_name, benefit_details, " +
                    "       installment_amount, installment_start_date, status, created_date " +
                    "FROM distributed_benefits " +
                    "WHERE user_email = ? " +
                    "ORDER BY created_date DESC"
                );
                ps.setString(1, email);
                rs = ps.executeQuery();

                while (rs.next()) {
                    java.util.Map<String,String> b = new java.util.LinkedHashMap<>();
                    b.put("id",               rs.getString("id"));
                    b.put("application_id",   rs.getString("application_id"));
                    b.put("plan_name",        rs.getString("plan_name"));
                    b.put("benefit_details",  rs.getString("benefit_details"));
                    b.put("installment_amount", rs.getString("installment_amount"));
                    b.put("installment_start_date", rs.getString("installment_start_date"));
                    b.put("status",           rs.getString("status"));
                    b.put("created_date",     rs.getString("created_date"));
                    benefits.add(b);
                    totalBenefits++;
                    if ("ACTIVE".equals(rs.getString("status"))) activePlans++;
                }

            } catch (Exception e) {
                out.println("<p style='color:#ef4444;'>Error: " + e.getMessage() + "</p>");
            } finally {
                try { if (rs  != null) rs.close();  } catch (Exception ex) {}
                try { if (ps  != null) ps.close();  } catch (Exception ex) {}
                try { if (con != null) con.close(); } catch (Exception ex) {}
            }
            %>

            <!-- STATS -->
            <div class="stats">
                <div class="stat-card">
                    <div class="num"><%=totalBenefits%></div>
                    <div class="label">Total Benefits</div>
                </div>
                <div class="stat-card">
                    <div class="num"><%=activePlans%></div>
                    <div class="label">Active Plans</div>
                </div>
                <div class="stat-card">
                    <div class="num"><%=totalBenefits - activePlans%></div>
                    <div class="label">Completed</div>
                </div>
            </div>

            <%
            if (benefits.isEmpty()) {
            %>
            <!-- NO BENEFITS -->
            <div class="no-benefits">
                
                <h3>No Benefits Yet</h3>
                <p>Once your application is approved and verified,<br>your benefits will appear here.</p>
            </div>

            <%
            } else {
            %>

            <!-- BENEFIT CARDS -->
            <div class="cards-grid">

            <%
            for (java.util.Map<String,String> b : benefits) {

                String planName    = b.get("plan_name")       != null ? b.get("plan_name")       : "";
                String details     = b.get("benefit_details") != null ? b.get("benefit_details") : "";
                String appId       = b.get("application_id")  != null ? b.get("application_id")  : "";
                String status      = b.get("status")          != null ? b.get("status")          : "ACTIVE";
                String startDate   = b.get("installment_start_date") != null ? b.get("installment_start_date") : "";
                String installAmt  = b.get("installment_amount")     != null ? b.get("installment_amount")     : "0";

                double instAmt = 0;
                try { instAmt = Double.parseDouble(installAmt); } catch (Exception ex) {}

                // plan CSS class + icon
                String planClass = "plan-snap";
                String planIcon  = "🌾";
                if      ("CCAP".equalsIgnoreCase(planName))     { planClass="plan-ccap";     planIcon="👶"; }
                else if ("Medicaid".equalsIgnoreCase(planName)) { planClass="plan-medicaid"; planIcon="🏥"; }
                else if ("Medicare".equalsIgnoreCase(planName)) { planClass="plan-medicare"; planIcon="👴"; }
                else if ("QHP".equalsIgnoreCase(planName))      { planClass="plan-qhp";      planIcon="🛡️"; }

                // valid until = start + 1 year
                String validUntil = "–";
                try {
                    java.time.LocalDate sd = java.time.LocalDate.parse(startDate);
                    validUntil = sd.plusYears(1).toString();
                } catch (Exception ex) {}

                // split benefit details by |
                String[] detailItems = details.split("\\|");
            %>

            <div class="benefit-card <%=planClass%>">

                <!-- Card Header -->
                <div class="card-header">
                    <div>
                        <div class="plan-name"><%=planName%></div>
                        <div style="font-size:12px;color:rgba(255,255,255,0.7);margin-top:3px;">
                            App #<%=appId%>
                        </div>
                    </div>
                    <div style="display:flex;flex-direction:column;align-items:flex-end;gap:8px;">
                        <span class="plan-icon"><%=planIcon%></span>
                        <span class="status-badge"><%=status%></span>
                    </div>
                </div>

                <!-- Card Body -->
                <div class="card-body">

                    <!-- Validity -->
                    <div class="validity">
                        <div class="v-item">
                            <label>Activated On</label>
                            <span><%=startDate != null && !startDate.isEmpty() ? startDate : "–"%></span>
                        </div>
                        <div class="v-item" style="text-align:right;">
                            <label>Valid Until</label>
                            <span><%=validUntil%></span>
                        </div>
                    </div>

                    <!-- Benefit Items -->
                    <div class="benefit-items">
                    <%
                    for (String item : detailItems) {
                        item = item.trim();
                        if (!item.isEmpty()) {
                    %>
                        <div class="benefit-item">
                            <div class="dot"></div>
                            <span><%=item%></span>
                        </div>
                    <%
                        }
                    }
                    %>
                    </div>

                    <%-- QHP: show installment box + pay button --%>
                    <% if ("QHP".equalsIgnoreCase(planName) && instAmt > 0) { %>

                    <div class="qhp-box">
                        <div class="qhp-row">
                            <label>Monthly Premium</label>
                            <span class="highlight">₹<%=(int)instAmt%>/month</span>
                        </div>
                        <div class="qhp-row">
                            <label>First Installment Due</label>
                            <span><%=startDate != null && !startDate.isEmpty() ? startDate : "–"%></span>
                        </div>
                        <div class="qhp-row">
                            <label>Payment Status</label>
                            <span class="subsidy">Due</span>
                        </div>
                    </div>

                    <button class="pay-btn"
                        onclick="window.location.href='qhpPayment.jsp?appId=<%=appId%>&amount=<%=(int)instAmt%>'">
                        💳 Pay First Installment – ₹<%=(int)instAmt%>
                    </button>

                    <% } %>

                    <!-- Active pulse indicator -->
                    <% if ("ACTIVE".equals(status)) { %>
                    <div class="active-tag">
                        <div class="pulse"></div>
                        Benefit is Active
                    </div>
                    <% } %>

                </div>
            </div>

            <%
            } // end for
            %>

            </div><!-- /cards-grid -->

            <% } // end else %>

            <div class="footer">
                © 2026 Integrated Eligibility System | All Rights Reserved
            </div>

        </div><!-- /content -->
    </div><!-- /main -->


</body>
</html>
