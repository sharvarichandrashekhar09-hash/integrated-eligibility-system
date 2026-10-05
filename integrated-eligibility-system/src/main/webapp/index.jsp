<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>IES - Integrated Eligibility System</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;font-family:'Segoe UI',sans-serif}
body{background:#f8fffa;color:#222}
header{position:sticky;top:0;z-index:1000;background:#22c55e;padding:15px 40px;display:flex;justify-content:space-between;align-items:center;box-shadow:0 2px 10px rgba(0,0,0,.15)}
.logo{font-size:32px;font-weight:bold;color:#fff}
nav a{color:#fff;text-decoration:none;margin-left:10px;padding:10px 18px;border-radius:25px;transition:.3s}
nav a.active,nav a:hover{background:#16a34a}
.hero{height:85vh;background:linear-gradient(rgba(0,0,0,.45),rgba(0,0,0,.45)),url('https://images.unsplash.com/photo-1517048676732-d65bc937f952?w=1600');background-size:cover;background-position:center;display:flex;align-items:center;justify-content:center;text-align:center;color:#fff}
.hero h1{font-size:60px;margin-bottom:15px}
.hero p{font-size:22px;margin-bottom:25px}
.btn{display:inline-block;background:#22c55e;color:white;padding:14px 28px;border-radius:30px;text-decoration:none;font-weight:bold;transition:.3s}
.btn:hover{transform:translateY(-3px);background:#16a34a}
.slider{width:90%;margin:50px auto;background:white;border-radius:25px;overflow:hidden;box-shadow:0 10px 30px rgba(0,0,0,.15)}
.slide{height:420px;color:white;display:flex;flex-direction:column;justify-content:center;align-items:center;text-align:center;background-size:cover;background-position:center}
.slide h2{font-size:50px}
.slide p{font-size:22px;margin:15px 0}
.section{padding:70px 40px}
.title{text-align:center;font-size:40px;color:#166534;margin-bottom:40px}
.cards{display:grid;grid-template-columns:repeat(auto-fit,minmax(240px,1fr));gap:25px}
.card{background:white;padding:25px;border-radius:20px;text-align:center;box-shadow:0 5px 20px rgba(0,0,0,.1);transition:.3s}
.card:hover{transform:translateY(-10px)}
.card img{width:100%;height:180px;object-fit:cover;border-radius:15px}
.card h3{margin:15px 0;color:#166534}
.stats{display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:20px}
.stat{background:#22c55e;color:white;padding:30px;border-radius:20px;text-align:center}
.stat h2{font-size:45px}
.about{background:#ecfdf5;text-align:center;border-radius:25px;padding:40px}
footer{background:#14532d;color:white;padding:50px 30px}
.footer-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:20px}
.footer-grid h3{margin-bottom:15px}
.footer-grid p{margin-bottom:8px}
</style>
</head>
<body>

<header>
<div class="logo">IES</div>
<nav>
<a href="index.jsp" class="active">Home</a>
<a href="#about">About Us</a>
<a href="plans.jsp">Plans</a>
<a href="auth.jsp">Login</a>
<a href="auth.jsp">Register</a>
</nav>
</header>

<section class="hero">
<div>
<h1>Integrated Eligibility System</h1>
<p>Discover, Apply and Track Government Benefits from One Platform</p>
<a href="plans.jsp" class="btn">Explore Plans</a>
</div>
</section>

<div class="slider">
<div class="slide" id="slide">
<h2 id="planTitle">SNAP</h2>
<p id="planDesc">Food Assistance Program</p>
<a href="plans.jsp" class="btn">View Plan</a>
</div>
</div>

<section class="section">
<h2 class="title">Government Benefit Programs</h2>
<div class="cards">
<div class="card">
<img src="https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=800">
<h3>SNAP</h3><p>Food Assistance Support</p>
</div>
<div class="card">
<img src="https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?w=800">
<h3>CCAP</h3><p>Child Care Assistance</p>
</div>
<div class="card">
<img src="https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=800">
<h3>Medicaid</h3><p>Healthcare Support</p>
</div>
<div class="card">
<img src="https://images.unsplash.com/photo-1516574187841-cb9cc2ca948b?w=800">
<h3>Medicare</h3><p>Senior Citizen Healthcare</p>
</div>
</div>
</section>

<section class="section">
<h2 class="title">IES Statistics</h2>
<div class="stats">
<div class="stat"><h2>5+</h2><p>Benefit Plans</p></div>
<div class="stat"><h2>1000+</h2><p>Applications</p></div>
<div class="stat"><h2>500+</h2><p>Approved Cases</p></div>
<div class="stat"><h2>24/7</h2><p>Online Access</p></div>
</div>
</section>

<section class="section" id="about">
<div class="about">
<h2 class="title">About IES</h2>
<p>
Integrated Eligibility System helps citizens discover government programs,
submit applications online, upload documents, track approvals and receive benefits
through a single secure platform.
</p>
</div>
</section>

<footer>
<div class="footer-grid">
<div>
<h3>Integrated Eligibility System</h3>
<p>One Platform. Multiple Benefits.</p>
</div>
<div>
<h3>Quick Links</h3>
<p>Home</p><p>Plans</p><p>About Us</p><p>Login</p>
</div>
<div>
<h3>Programs</h3>
<p>SNAP</p><p>CCAP</p><p>Medicaid</p><p>Medicare</p><p>QHP</p>
</div>
<div>
<h3>Contact</h3>
<p>support@ies.gov</p>
<p>Pune, Maharashtra</p>
</div>
</div>
<p style="text-align:center;margin-top:30px">© 2026 Integrated Eligibility System</p>
</footer>

<script>
const plans=[
["SNAP","Food Assistance Program","https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=1600"],
["CCAP","Child Care Assistance Program","https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?w=1600"],
["Medicaid","Medical Support Program","https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=1600"],
["Medicare","Senior Citizen Healthcare","https://images.unsplash.com/photo-1516574187841-cb9cc2ca948b?w=1600"],
["QHP","Qualified Health Plan","https://images.unsplash.com/photo-1584515933487-779824d29309?w=1600"]
];
let i=0;
function changeSlide(){
const s=plans[i];
document.getElementById("planTitle").innerText=s[0];
document.getElementById("planDesc").innerText=s[1];
document.getElementById("slide").style.backgroundImage="linear-gradient(rgba(0,0,0,.45),rgba(0,0,0,.45)),url('"+s[2]+"')";
i=(i+1)%plans.length;
}
changeSlide();
setInterval(changeSlide,3000);
</script>

</body>
</html>