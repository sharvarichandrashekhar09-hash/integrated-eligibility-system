<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
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

<title>Medicaid Plan Application</title>

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
rgba(0,0,0,.55),
rgba(0,0,0,.55)),
url('https://images.unsplash.com/photo-1454165804606-c3d57bc86b40');

background-size:cover;
background-position:center;
background-repeat:no-repeat;
background-attachment:fixed;

min-height:100vh;

color:white;
}

/* HEADER */

.header{

height:55px;

background:rgba(0,0,0,.35);

backdrop-filter:blur(10px);

display:flex;

justify-content:space-between;

align-items:center;

padding:0 25px;
}

.logo{

font-size:26px;

font-weight:bold;

color:white;
}

/* CONTAINER */

.container{

width:82%;

max-width:1150px;

margin:15px auto;

padding:20px;

border-radius:20px;

background:rgba(255,255,255,.08);

backdrop-filter:blur(15px);

-webkit-backdrop-filter:blur(15px);

box-shadow:0 8px 32px rgba(0,0,0,.25);
}

/* TITLE */

.title{

text-align:center;

font-size:28px;

font-weight:bold;

margin-bottom:5px;
}

.progress{

text-align:center;

font-size:13px;

margin-bottom:15px;

color:#ddd;
}

/* STEP */

.step{

display:none;

max-height:70vh;

overflow-y:auto;

padding-right:8px;
}

.step.active{

display:block;
}

.step::-webkit-scrollbar{

width:6px;
}

.step::-webkit-scrollbar-thumb{

background:#3ddc84;

border-radius:10px;
}

/* FORM */

.form-row{

display:flex;

gap:20px;
}

.column{

flex:1;
}

.form-group{

margin-bottom:12px;
}

/* LABEL */

label{

display:block;

margin-bottom:5px;

font-size:13px;

font-weight:600;

color:#3ddc84;
}

/* INPUTS */

input,
select,
textarea{

width:100%;

padding:8px;

font-size:13px;

background:transparent;

border:none;

border-bottom:1px solid rgba(255,255,255,.4);

color:white;

outline:none;
}

input::placeholder{

color:#ddd;
}

select option{

color:black;
}

textarea{

height:90px;

padding:10px;

border:1px solid rgba(255,255,255,.3);

border-radius:10px;

resize:none;
}

/* BUTTONS */

.button-box{

display:flex;

justify-content:space-between;

align-items:center;

margin-top:15px;
}

.btn{

background:#3ddc84;

color:white;

border:none;

padding:10px 20px;

border-radius:25px;

cursor:pointer;

font-weight:bold;

font-size:13px;

transition:.3s;
}

.btn:hover{

background:#2ec46d;

transform:scale(1.03);
}

/* FOOTER */

.footer{

height:45px;

margin-top:15px;

display:flex;

justify-content:center;

align-items:center;

background:rgba(0,0,0,.35);

backdrop-filter:blur(10px);

color:white;

font-size:12px;
}

/* MOBILE */

@media(max-width:900px){

.container{

width:95%;
}

.form-row{

flex-direction:column;
}

.step{

max-height:none;
}

}

</style>
</head>

<body>

<div class="header" id="mainHeader">

    <div class="logo">
        IES
    </div>

    <div style="
    display:flex;
    gap:15px;">

        <a href="userDashboard.jsp"
        style="
        color:white;
        text-decoration:none;
        font-weight:bold;">
        Dashboard
        </a>

        <a href="plans.jsp"
        style="
        color:white;
        text-decoration:none;
        font-weight:bold;">
        Plans
        </a>

        <a href="track.jsp"
        style="
        color:white;
        text-decoration:none;
        font-weight:bold;">
        Track
        </a>

        <a href="transactions.jsp"
        style="
        color:white;
        text-decoration:none;
        font-weight:bold;">
        Transactions
        </a>

        <a href="index.jsp"
        style="
        color:white;
        text-decoration:none;
        font-weight:bold;">
        Logout
        </a>

    </div>

</div>

<div class="container">

<div class="title">
Medicaid Plan Application
</div>

<form action="MedicaidApplicationServlet" method="post">

<input type="hidden"
name="plan_id"
value="PLN-003">

<input type="hidden"
name="user_email"
value="<%= session.getAttribute("userEmail") %>">




<!-- STEP 1 -->

<div class="step active" id="step1">

<div class="progress">
Step 1 of 3
</div>

<div class="form-row">

<div class="column">

<div class="form-group">
<label>What is your full name? *</label>
<input type="text" name="full_name" required>
</div>

<div class="form-group">
<label>What is your gender? *</label>
<select name="gender" required>
<option value="">Select Gender</option>
<option value="Male">Male</option>
<option value="Female">Female</option>
<option value="Other">Other</option>
</select>
</div>

<div class="form-group">
<label>What is your Aadhaar number? *</label>
<input type="text" name="aadhaar" required>
</div>

<div class="form-group">
<label>What is your residential address? *</label>
<input type="text" name="address" required>
</div>

<div class="form-group">
<label>Are you an Indian citizen? *</label>
<select name="indian_citizen" required>
<option value="">Select</option>
<option value="Yes">Yes</option>
<option value="No">No</option>
</select>
</div>

</div>

<div class="column">

<div class="form-group">
<label>What is your date of birth? *</label>
<input type="date" name="dob" required>
</div>

<div class="form-group">
<label>What is your mobile number? *</label>
<input type="text" name="mobile" required>
</div>

<div class="form-group">
<label>What is your annual family income? *</label>
<input type="text" name="annual_income" required>
</div>

<div class="form-group">
<label>Does your income exceed Medicaid eligibility limits? *</label>
<select name="income_exceed" required>
<option value="">Select</option>
<option value="Yes">Yes</option>
<option value="No">No</option>
</select>
</div>

<div class="form-group">
<label>Do you currently have private health insurance? *</label>
<select name="private_insurance" required>
<option value="">Select</option>
<option value="Yes">Yes</option>
<option value="No">No</option>
</select>
</div>

</div>

</div>

<div class="button-box">

<div></div>

<button
type="button"
class="btn"
onclick="nextStep()">

Next →

</button>

</div>

</div>


<!-- STEP 2 -->

<div class="step" id="step2">

<div class="progress">
Step 2 of 3
</div>

<div class="form-row">

<div class="column">

<div class="form-group">
<label>How many family members live in your household? *</label>

<input type="number"
name="family_members"
min="1"
required>

</div>

<div class="form-group">
<label>Do you suffer from any serious illness? *</label>

<select name="serious_illness" required>

<option value="">Select</option>
<option value="Yes">Yes</option>
<option value="No">No</option>

</select>

</div>

<div class="form-group">
<label>Do you have any disability? *</label>

<select name="disability" required>

<option value="">Select</option>
<option value="Yes">Yes</option>
<option value="No">No</option>

</select>

</div>

<div class="form-group">
<label>Are you a senior citizen? *</label>

<select name="senior_citizen" required>

<option value="">Select</option>
<option value="Yes">Yes</option>
<option value="No">No</option>

</select>

</div>

<div class="form-group">
<label>Have you been hospitalized recently? *</label>

<select name="hospitalized" required>

<option value="">Select</option>
<option value="Yes">Yes</option>
<option value="No">No</option>

</select>

</div>

</div>

<div class="column">

<div class="form-group">
<label>Do you require treatment support assistance? *</label>

<select name="treatment_support" required>

<option value="">Select</option>
<option value="Yes">Yes</option>
<option value="No">No</option>

</select>

</div>

<div class="form-group">
<label>What type of medical support do you require? *</label>

<input type="text"
name="medical_support_type"
required>

</div>

<div class="form-group">
<label>Have you undergone surgery in the past? *</label>

<select name="surgery" required>

<option value="">Select</option>
<option value="Yes">Yes</option>
<option value="No">No</option>

</select>

</div>

<div class="form-group">
<label>Do you take regular medicines? *</label>

<select name="regular_medicine" required>

<option value="">Select</option>
<option value="Yes">Yes</option>
<option value="No">No</option>

</select>

</div>

<div class="form-group">
<label>Which hospital do you normally visit for treatment? *</label>

<input type="text"
name="hospital_name"
required>

</div>

</div>

</div>

<div class="button-box">

<button
type="button"
class="btn"
onclick="previousStep()">

← Back

</button>

<button
type="button"
class="btn"
onclick="nextStep()">

Next →

</button>

</div>

</div>




<!-- STEP 3 -->

<div class="step" id="step3">

<div class="progress">
Step 3 of 3
</div>

<div class="form-row">

<div class="column">

<div class="form-group">
<label>Do you receive treatment from a Government Hospital? *</label>

<select name="government_hospital" required>

<option value="">Select</option>
<option value="Yes">Yes</option>
<option value="No">No</option>

</select>

</div>

<div class="form-group">
<label>Are you currently enrolled in any Government Health Scheme? *</label>

<select name="government_scheme" required>

<option value="">Select</option>
<option value="Yes">Yes</option>
<option value="No">No</option>

</select>

</div>

<div class="form-group">
<label>Do you have access to a cashless treatment facility? *</label>

<select name="cashless_facility" required>

<option value="">Select</option>
<option value="Yes">Yes</option>
<option value="No">No</option>

</select>

</div>

<div class="form-group">
<label>Do you possess any health card for medical benefits? *</label>

<select name="health_card" required>

<option value="">Select</option>
<option value="Yes">Yes</option>
<option value="No">No</option>

</select>

</div>

<div class="form-group">
<label>What is your approximate monthly medical expense? *</label>

<input type="text"
name="medical_expense"
required>

</div>

</div>

<div class="column">

<div class="form-group">
<label>Is there any disabled member in your family? *</label>

<select name="disabled_member" required>

<option value="">Select</option>
<option value="Yes">Yes</option>
<option value="No">No</option>

</select>

</div>

<div class="form-group">
<label>Do you agree to medical verification of your information? *</label>

<select name="medical_verification" required>

<option value="">Select</option>
<option value="Yes">Yes</option>
<option value="No">No</option>

</select>

</div>

<div class="form-group">
<label>Are all details provided by you correct? *</label>

<select name="details_correct" required>

<option value="">Select</option>
<option value="Yes">Yes</option>
<option value="No">No</option>

</select>

</div>

<div class="form-group">
<label>Do you allow Government verification of your application? *</label>

<select name="government_verification" required>

<option value="">Select</option>
<option value="Yes">Yes</option>
<option value="No">No</option>

</select>

</div>

<div class="form-group">
<label>Please explain why you are applying for Medicaid assistance. *</label>

<textarea
name="reason"
rows="5"
required></textarea>

</div>

</div>

</div>

<div class="button-box">

<button
type="button"
class="btn"
onclick="previousStep()">

← Back

</button>

<div>

<button
type="button"
class="btn"
onclick="window.print()">

Print

</button>

<button
type="submit"
class="btn">

Submit Application

</button>

</div>

</div>

</div>

</form>
</div>
<div class="footer">

© 2026 Integrated Eligibility System

</div>



<script>

let currentStep = 1;

function nextStep(){

    if(currentStep < 3){

        document.getElementById(
        "step"+currentStep
        ).classList.remove("active");

        currentStep++;

        document.getElementById(
        "step"+currentStep
        ).classList.add("active");
    }

    if(currentStep > 1){

        document.getElementById(
        "mainHeader"
        ).style.display="none";
    }
}

function previousStep(){

    document.getElementById(
    "step"+currentStep
    ).classList.remove("active");

    currentStep--;

    document.getElementById(
    "step"+currentStep
    ).classList.add("active");

    if(currentStep == 1){

        document.getElementById(
        "mainHeader"
        ).style.display="flex";
    }
}

</script>
</body>
</html>