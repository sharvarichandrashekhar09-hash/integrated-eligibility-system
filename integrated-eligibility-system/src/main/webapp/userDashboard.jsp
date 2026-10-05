
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String email =
        (String) session.getAttribute("userEmail");

    if(email == null){

        response.sendRedirect("auth.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>User Dashboard</title>

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

    min-height:100vh;
    overflow-x:hidden;
}

.overlay{
    background:rgba(0,0,0,0.78);
    min-height:100vh;
}

/* TOPBAR */

.topbar{
    width:100%;
    height:75px;
    background:rgba(0,0,0,0.35);

    display:flex;
    justify-content:space-between;
    align-items:center;

    padding:0 30px;
}

.logo{
    color:#22c55e;
    font-size:34px;
    font-weight:bold;
}

.top-right{
    display:flex;
    align-items:center;
    gap:15px;
}

.profile-circle{
    width:40px;
    height:40px;
    border-radius:50%;
    background:#22c55e;

    display:flex;
    justify-content:center;
    align-items:center;

    color:white;
    font-weight:bold;
}

.logout-btn{
    padding:10px 20px;
    border:none;
    border-radius:30px;
    background:#22c55e;
    color:white;
    cursor:pointer;
    font-weight:bold;
}

/* MAIN */

.main{
    display:flex;
}

/* SIDEBAR */

.sidebar{
    width:260px;
    min-height:calc(100vh - 75px);

    background:rgba(0,0,0,0.45);

    padding:25px 15px;
}

.sidebar h3{
    color:#22c55e;
    margin-bottom:25px;
}

.menu{
    list-style:none;
}

.menu li{
    margin-bottom:12px;
}

.menu a{
    text-decoration:none;
    color:white;

    display:block;

    padding:14px 18px;

    border-radius:10px;

    transition:0.3s;
}


.menu a:hover{
background:#ff7b00;
}

.menu a.active{
background:#22c55e !important;
color:white;
}

/* CONTENT */

.content{
    flex:1;
    padding:35px;
    color:white;
}

.welcome{
    margin-bottom:30px;
}

.welcome h1{
    font-size:42px;
    margin-bottom:10px;
}

.welcome p{
    color:#ccc;
}

/* PROFILE CARD */

.profile-card{
    width:100%;
    background:rgba(255,255,255,0.08);

    border-radius:20px;

    padding:25px;

    backdrop-filter:blur(10px);

    margin-bottom:30px;
}

.profile-top{
    display:flex;
    align-items:center;
    gap:20px;
}

.profile-img{
    width:90px;
    height:90px;
    border-radius:50%;
    background:#22c55e;

    display:flex;
    justify-content:center;
    align-items:center;

    font-size:38px;
    font-weight:bold;
}

.profile-name h2{
    margin-bottom:8px;
}

.profile-name p{
    color:#bbb;
}

.profile-details{
    margin-top:30px;

    display:grid;
    grid-template-columns:repeat(3,1fr);

    gap:25px;
}

.detail-box h4{
    color:#22c55e;
    margin-bottom:8px;
}

/* STATS */

.stats{
    display:grid;
    grid-template-columns:repeat(4,1fr);
    gap:20px;
}

.stat-card{
    background:rgba(255,255,255,0.08);

    border-radius:18px;

    padding:25px;

    backdrop-filter:blur(10px);
}

.stat-card h2{
    margin-top:12px;
    font-size:36px;
}

.stat-card p{
    margin-top:10px;
    color:#ccc;
}

.footer{
    text-align:center;
    color:#ccc;
    margin-top:40px;
}

</style>

</head>

<body>

<div class="overlay">

    <!-- TOPBAR -->

    <div class="topbar">

        <div class="logo">
            IES
        </div>

        <div class="top-right">

            <div class="profile-circle">
                <%= email.substring(0,1).toUpperCase() %>
            </div>

            <form action="LogoutServlet"
                  method="post">

                <button class="logout-btn">
                    Logout
                </button>

            </form>

        </div>

    </div>

    <!-- MAIN -->

    <div class="main">

        <!-- SIDEBAR -->

        <div class="sidebar">

            <h3>Dashboard</h3>

            <ul class="menu">

               <li>
    <a href="userdashboard.jsp" class="active">
         Profile
    </a>
</li>
                <li>
                    <a href="plans.jsp">
                         Plans
                    </a>
                </li>

              

                <li>
                    <a href="transaction.jsp">
                         Transactions
                    </a>
                </li>

                <li>
                    <a href="benefits.jsp">
                         Benefits
                    </a>
                </li>

                <li>
                    <a href="track.jsp">
                         Track Application
                    </a>
                </li>

                <li>
                    <a href="uploadDocuments.jsp">
                         Upload Documents
                    </a>
                </li>

            </ul>

        </div>

        <!-- CONTENT -->

        <div class="content">

            <div class="welcome">

                <h1>
                    Welcome,
                    <%= email %>
                </h1>

                <p>
                    Manage applications, upload documents and track benefits online
                </p>

            </div>

            <!-- PROFILE CARD -->

            <div class="profile-card">

                <div class="profile-top">

                    <div class="profile-img">

                        <%= email.substring(0,1).toUpperCase() %>

                    </div>

                    <div class="profile-name">

                        <h2>
                            <%= email %>
                        </h2>

                        <p>
                            Registered User | Integrated Eligibility System
                        </p>

                    </div>

                </div>

                <div class="profile-details">

                    <div class="detail-box">

                        <h4>Email</h4>

                        <p>
                            <%= email %>
                        </p>

                    </div>

                    <div class="detail-box">

                        <h4>Role</h4>

                        <p>
                            USER
                        </p>

                    </div>

                    <div class="detail-box">

                        <h4>Status</h4>

                        <p>
                            Active
                        </p>

                    </div>

                    <div class="detail-box">

                        <h4>Verification</h4>

                        <p>
                            Documents Verified
                        </p>

                    </div>

                    <div class="detail-box">

                        <h4>Benefits</h4>

                        <p>
                            Benefits Assigned
                        </p>

                    </div>

                </div>

            </div>

            <!-- STATS -->

            <div class="stats">

                <div class="stat-card">

                    <h2>04</h2>

                    <p>
                        Applications Submitted
                    </p>

                </div>

                <div class="stat-card">

                    <h2>02</h2>

                    <p>
                        Pending Verification
                    </p>

                </div>

                <div class="stat-card">

                    <h2>03</h2>

                    <p>
                        Benefits Approved
                    </p>

                </div>

                <div class="stat-card">

                    <h2>₹25K</h2>

                    <p>
                        Benefits Received
                    </p>

                </div>

            </div>

            <div class="footer">

                © 2026 Integrated Eligibility System
                | All Rights Reserved

            </div>

        </div>

    </div>

</div>

</body>
</html>

