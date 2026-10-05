<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
String email =
(String)session.getAttribute("userEmail");

if(email==null){

response.sendRedirect("auth.jsp");
return;

}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Plans</title>
<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:'Segoe UI',sans-serif;
}

body{
    background:
    linear-gradient(rgba(2,8,25,.78),
    rgba(2,8,25,.78)),
    url('https://images.unsplash.com/photo-1516574187841-cb9cc2ca948b?w=1600');

    background-size:cover;
    background-position:center;
    background-attachment:fixed;

    color:white;

    overflow:hidden;
}

/* HEADER */

.header{
    position:fixed;

    top:0;
    left:0;
    right:0;

    height:65px;

    background:rgba(6,16,31,.82);

    backdrop-filter:blur(15px);

    border-bottom:1px solid rgba(255,255,255,.08);

    display:flex;

    justify-content:space-between;

    align-items:center;

    padding:0 25px;

    z-index:1000;
}

.logo{
    color:#18d26e;
    font-size:24px;
    font-weight:bold;
}

.header-buttons a{

    text-decoration:none;

    color:white;

    background:#18d26e;

    padding:10px 18px;

    border-radius:25px;

    margin-left:10px;

    font-size:14px;

    transition:.3s;
}

.header-buttons a:hover{

    background:#13b35c;
}

/* MAIN */

.main{

    display:flex;

    margin-top:65px;

    height:calc(100vh - 105px);
}

/* SIDEBAR */

.sidebar{

    width:220px;

    background:rgba(5,12,25,.75);

    backdrop-filter:blur(15px);

    border-right:1px solid rgba(255,255,255,.08);

    padding:20px;
}

.sidebar a{

    display:block;

    text-decoration:none;

    color:white;

    padding:12px 15px;

    margin-bottom:10px;

    border-radius:10px;

    transition:.3s;
}

.sidebar a:hover{

    background:#18d26e;
}

.active{

    background:#18d26e;
}

/* CONTENT */

.content{

    flex:1;

    padding:15px;

    overflow:hidden;
}

.page-title{

    font-size:30px;

    font-weight:bold;

    margin-bottom:15px;
}

/* SEARCH + PLANS LAYOUT */

.grid{

    display:flex;

    gap:15px;

    height:calc(100vh - 170px);
}

/* SEARCH BOX */

.searchpanel{

    width:280px;

    min-width:280px;

    min-height:220px;

    background:rgba(255,255,255,0.05);

    backdrop-filter:blur(12px);

    border:1px solid rgba(255,255,255,0.12);

    border-radius:15px;

    padding:25px;

    display:flex;

    flex-direction:column;

    gap:15px;
}
.searchpanel h3{

    margin-bottom:10px;
}

.searchpanel input{

    width:100%;

    padding:14px;

    border:none;

    border-radius:10px;

    font-size:15px;

    outline:none;
}

/* SCROLLABLE PLANS */

.plans{

    flex:1;

    overflow-y:auto;

    height:calc(100vh - 190px);

    padding-right:8px;
}

.plans::-webkit-scrollbar{

    width:8px;
}

.plans::-webkit-scrollbar-thumb{

    background:#18d26e;

    border-radius:20px;
}

/* PLAN CARD */

.card{

    display:flex;

    gap:15px;

    background:rgba(255,255,255,0.04);

    backdrop-filter:blur(10px);

    border:1px solid rgba(24,210,110,0.18);

    border-radius:15px;

    padding:15px;

    margin-bottom:15px;

    min-height:180px;

    transition:.3s;
}

.card:hover{

    border-color:#18d26e;

    box-shadow:0 0 20px rgba(24,210,110,.20);
}

/* CARD IMAGE */

.card img{

    width:130px;

    height:130px;

    border-radius:10px;

    object-fit:cover;
}

/* CARD INFO */

.info{

    flex:1;

    display:flex;

    flex-direction:column;
}

.info h3{

    color:#18d26e;

    font-size:17px;

    margin-bottom:8px;
}

.info p{

    font-size:13px;

    line-height:1.6;

    margin-bottom:8px;
}

.info ul{

    margin-left:18px;

    margin-bottom:10px;
}

.info li{

    margin-bottom:5px;

    font-size:13px;
}

/* APPLY BUTTON */

.apply{

    margin-top:auto;

    width:130px;

    background:#18d26e;

    color:white;

    border:none;

    padding:10px;

    border-radius:25px;

    cursor:pointer;

    font-weight:bold;

    transition:.3s;
}

.apply:hover{

    background:#13b35c;

    transform:scale(1.03);
}

/* FOOTER */

.footer{

    position:fixed;

    left:0;
    right:0;
    bottom:0;

    height:40px;

    background:rgba(6,16,31,.82);

    backdrop-filter:blur(15px);

    border-top:1px solid rgba(255,255,255,.08);

    display:flex;

    align-items:center;

    justify-content:center;

    font-size:13px;
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
<a href="plans.jsp"
           class="active">
            Plans
        </a>
        
                    
                
                    <a href="transaction.jsp">
                        Transactions
                    </a>
                

                
                    <a href="benefits.jsp">
                        Benefits
                    </a>
              

               
                    <a href="track.jsp">
                        Track Application
                    </a>
                
                    <a href="uploadDocuments.jsp">
                         Upload Documents
                    </a>
                
                
                <a href="index.jsp">
                       LogOut
                    </a>
        
    </div>

</div>


    <div class="content">

        <div class="page-title">
            Explore Plans
        </div>

        <div class="grid">

            <div class="searchpanel">

                <h3>
                    Search Plans
                </h3>

                <input type="text"
                       placeholder="Search Plan">

                <br><br>

                <p>
                    Browse all government
                    assistance plans.
                </p>

            </div>

            <div class="plans">

                <!-- SNAP -->

                <div class="card">

                    <img src="https://images.unsplash.com/photo-1542838132-92c53300491e?w=500">

                    <div class="info">

                        <h3>
                            SNAP Assistance Program
                        </h3>

                        <p>
                            Food support for
                            low income families.
                        </p>

                        <ul>

                            <li>
                                Income ≤ ₹2,50,000
                            </li>

                            <li>
                                Family Size ≥ 4
                            </li>

                            <li>
                                No Government Employee
                            </li>

                        </ul>

                        <a href="snap.jsp">

                            <button class="apply">
                                Apply Now
                            </button>

                        </a>

                    </div>

                </div>

                <!-- CHILD CARE -->

                <div class="card">

                    <img src="https://images.unsplash.com/photo-1516627145497-ae6968895b74?w=500">

                    <div class="info">

                        <h3>
                            Child Care Assistance
                        </h3>

                        <p>
                            Child nutrition,
                            daycare and health support.
                        </p>

                        <ul>

                            <li>
                                Income ≤ ₹2,00,000
                            </li>

                            <li>
                                Child 6 Months - 6 Years
                            </li>

                            <li>
                                Single Parent /
                                Both Working
                            </li>

                        </ul>

                        <a href="childcare.jsp">

                            <button class="apply">
                                Apply Now
                            </button>

                        </a>

                    </div>

                </div>

                <!-- MEDICAID -->

                <div class="card">

                    <img src="https://images.unsplash.com/photo-1579684385127-1ef15d508118?w=500">

                    <div class="info">

                        <h3>
                            Medicaid
                        </h3>

                        <p>
                            Free healthcare support
                            and hospitalization.
                        </p>

                        <ul>

                            <li>
                                Income ≤ ₹3,00,000
                            </li>

                            <li>
                                No Private Insurance
                            </li>

                            <li>
                                Cashless Treatment
                            </li>

                        </ul>

                        <a href="medicaid.jsp">

                            <button class="apply">
                                Apply Now
                            </button>

                        </a>

                    </div>

                </div>

                <!-- MEDICARE -->

                <div class="card">

                    <img src="https://images.unsplash.com/photo-1584515933487-779824d29309?w=500">

                    <div class="info">

                        <h3>
                            Medicare
                        </h3>

                        <p>
                            Healthcare support
                            for senior citizens.
                        </p>

                        <ul>

                            <li>
                                Age ≥ 60
                            </li>

                            <li>
                                Income ≤ ₹3,00,000
                            </li>

                            <li>
                                Regular Checkups
                            </li>

                        </ul>

                        <a href="medicare.jsp">

                            <button class="apply">
                                Apply Now
                            </button>

                        </a>

                    </div>

                </div>

                <!-- QHP -->

                <div class="card">

                    <img src="https://images.unsplash.com/photo-1450101499163-c8848c66ca85?w=500">

                    <div class="info">

                        <h3>
                            Qualified Health Plan
                        </h3>

                        <p>
                            Subsidized health
                            insurance coverage.
                        </p>

                        <ul>

                            <li>
                                Income ₹3L - ₹8L
                            </li>

                            <li>
                                Basic / Standard / Premium
                            </li>

                            <li>
                                Hospital Coverage
                            </li>

                        </ul>

                        <a href="qualifiedhealthplan.jsp">

                            <button class="apply">
                                Apply Now
                            </button>

                        </a>

                    </div>

                </div>

            </div>

        </div>

    </div>



<div class="footer">

    © 2026 Integrated Eligibility System

</div>

</body>
</html>