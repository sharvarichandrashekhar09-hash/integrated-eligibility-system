<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%
String email = (String)session.getAttribute("userEmail");
if(email==null){
    response.sendRedirect("auth.jsp");
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SNAP Plan Application</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;font-family:'Segoe UI',sans-serif;}
html,body{height:100%;}
body{
background:linear-gradient(rgba(0,0,0,.55),rgba(0,0,0,.55)),
url('https://images.unsplash.com/photo-1454165804606-c3d57bc86b40');
background-size:cover;background-position:center;
background-repeat:no-repeat;background-attachment:fixed;
min-height:100vh;color:white;
display:flex;flex-direction:column;
}
.header{height:50px;background:rgba(0,0,0,.35);backdrop-filter:blur(10px);
display:flex;justify-content:space-between;align-items:center;padding:0 25px;flex-shrink:0;}
.logo{font-size:24px;font-weight:bold;color:white;}
.main{flex:1;display:flex;align-items:center;justify-content:center;padding:12px 0;}
.container{width:82%;max-width:1150px;padding:18px 24px;border-radius:20px;
background:rgba(255,255,255,.08);backdrop-filter:blur(15px);
-webkit-backdrop-filter:blur(15px);box-shadow:0 8px 32px rgba(0,0,0,.25);}
.title{text-align:center;font-size:22px;font-weight:bold;margin-bottom:3px;}
.progress{text-align:center;font-size:12px;margin-bottom:12px;color:#ddd;}
.step{display:none;}
.step.active{display:block;}
.form-row{display:flex;gap:20px;align-items:flex-start;}
.column{flex:1;}
.form-group{margin-bottom:9px;}
label{display:block;margin-bottom:3px;font-size:12px;font-weight:600;color:#3ddc84;}
input,select,textarea{width:100%;padding:6px 4px;font-size:12px;
background:transparent;border:none;border-bottom:1px solid rgba(255,255,255,.4);
color:white;outline:none;}
input::placeholder{color:#ddd;}
select option{color:black;}
.button-box{display:flex;justify-content:space-between;align-items:center;margin-top:12px;}
.btn{background:#3ddc84;color:white;border:none;padding:8px 18px;
border-radius:25px;cursor:pointer;font-weight:bold;font-size:12px;transition:.3s;}
.btn:hover{background:#2ec46d;transform:scale(1.03);}
.footer{height:40px;display:flex;justify-content:center;align-items:center;
background:rgba(0,0,0,.35);backdrop-filter:blur(10px);color:white;font-size:12px;flex-shrink:0;}
@media(max-width:900px){.container{width:95%;}.form-row{flex-direction:column;}}
.reason-group{margin-top:8px;display:flex;flex-direction:column;gap:10px;}
.reason-item{display:flex;align-items:center;gap:10px;color:white;font-size:13px;font-weight:500;}
.reason-item input[type="checkbox"]{width:16px;height:16px;accent-color:#3ddc84;cursor:pointer;flex-shrink:0;}
.reason-item span{color:white;font-size:13px;font-weight:500;}
</style>
</head>
<body>

<div class="header" id="mainHeader">
    <div class="logo">IES</div>
    <div style="display:flex;gap:15px;">
        <a href="userDashboard.jsp" style="color:white;text-decoration:none;font-weight:bold;">Dashboard</a>
        <a href="plans.jsp" style="color:white;text-decoration:none;font-weight:bold;">Plans</a>
        <a href="track.jsp" style="color:white;text-decoration:none;font-weight:bold;">Track</a>
        <a href="transaction.jsp" style="color:white;text-decoration:none;font-weight:bold;">Transactions</a>
        <a href="index.jsp" style="color:white;text-decoration:none;font-weight:bold;">Logout</a>
    </div>
</div>

<div class="main">
<div class="container">

    <div class="title">SNAP PLAN APPLICATION</div>

    <form action="SnapApplicationServlet" method="post">

        <input type="hidden" name="plan_id" value="PLN-001">
        <input type="hidden" name="user_email" value="<%= session.getAttribute("userEmail") %>">

        <!-- STEP 1 -->
        <div class="step active" id="step1">
            <div class="progress">Step 1 of 3</div>
            <div class="form-row">
                <div class="column">
                    <div class="form-group">
                        <label>Full name *</label>
                        <input type="text" name="full_name" placeholder="Enter full name" required>
                    </div>
                    <div class="form-group">
                        <label>Gender *</label>
                        <select name="gender" required>
                            <option value="">Select gender</option>
                            <option value="Male">Male</option>
                            <option value="Female">Female</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Aadhaar number *</label>
                        <input type="text" name="aadhaar" maxlength="12" placeholder="12-digit Aadhaar" required>
                    </div>
                    <div class="form-group">
                        <label>Residential address *</label>
                        <input type="text" name="address" placeholder="Enter address" required>
                    </div>
                    <div class="form-group">
                        <label>State *</label>
                        <input type="text" name="state" placeholder="Enter state" required>
                    </div>
                </div>
                <div class="column">
                    <div class="form-group">
                        <label>Date of birth *</label>
                        <input type="date" name="dob" required>
                    </div>
                    <div class="form-group">
                        <label>Mobile number *</label>
                        <input type="text" name="mobile" maxlength="10" placeholder="10-digit number" required>
                    </div>
                    <div class="form-group">
                        <label>District *</label>
                        <input type="text" name="district" placeholder="Enter district" required>
                    </div>
                    <div class="form-group">
                        <label>City *</label>
                        <input type="text" name="city" placeholder="Enter city" required>
                    </div>
                    <div class="form-group">
                        <label>Number of family members *</label>
                        <input type="number" name="family_members" min="1" placeholder="Total members" required>
                    </div>
                </div>
            </div>
            <div class="button-box">
                <div></div>
                <button type="button" class="btn" onclick="nextStep()">Next →</button>
            </div>
        </div>

        <!-- STEP 2 -->
        <div class="step" id="step2">
            <div class="progress">Step 2 of 3</div>
            <div class="form-row">
                <div class="column">
                    <div class="form-group">
                        <label>Do all family members live together? *</label>
                        <select name="living_together" required>
                            <option value="">Select</option>
                            <option value="Yes">Yes</option>
                            <option value="No">No</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Annual family income *</label>
                        <input type="text" name="annual_income" placeholder="Enter annual income" required>
                    </div>
                    <div class="form-group">
                        <label>Is anyone employed in a government job? *</label>
                        <select name="government_job" required>
                            <option value="">Select</option>
                            <option value="Yes">Yes</option>
                            <option value="No">No</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Do you have a ration card? *</label>
                        <select name="ration_card" required>
                            <option value="">Select</option>
                            <option value="Yes">Yes</option>
                            <option value="No">No</option>
                        </select>
                    </div>
                </div>
                <div class="column">
                    <div class="form-group">
                        <label>Number of children *</label>
                        <input type="number" name="children_count" min="0" placeholder="0" required>
                    </div>
                    <div class="form-group">
                        <label>Is there any senior citizen in the family? *</label>
                        <select name="senior_citizen" required>
                            <option value="">Select</option>
                            <option value="Yes">Yes</option>
                            <option value="No">No</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Is there any disabled member in the family? *</label>
                        <select name="disabled_member" required>
                            <option value="">Select</option>
                            <option value="Yes">Yes</option>
                            <option value="No">No</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Monthly household expense *</label>
                        <input type="text" name="monthly_expense" placeholder="Enter monthly expense" required>
                    </div>
                </div>
            </div>
            <div class="button-box">
                <button type="button" class="btn" onclick="previousStep()">← Back</button>
                <button type="button" class="btn" onclick="nextStep()">Next →</button>
            </div>
        </div>

        <!-- STEP 3 -->
        <div class="step" id="step3">
            <div class="progress">Step 3 of 3</div>
            <div class="form-row">
                <div class="column">
                    <div class="form-group">
                        <label>House type *</label>
                        <select name="house_type" required>
                            <option value="">Select</option>
                            <option value="Owned">Owned</option>
                            <option value="Rented">Rented</option>
                            <option value="Government">Government</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Are all details correct? *</label>
                        <select name="details_correct" required>
                            <option value="">Select</option>
                            <option value="Yes">Yes</option>
                            <option value="No">No</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Allow government verification? *</label>
                        <select name="government_verification" required>
                            <option value="">Select</option>
                            <option value="Yes">Yes</option>
                            <option value="No">No</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Will you update information regularly? *</label>
                        <select name="update_information" required>
                            <option value="">Select</option>
                            <option value="Yes">Yes</option>
                            <option value="No">No</option>
                        </select>
                    </div>
                </div>
                <div class="column">
                    <div class="form-group">
                        <label>Why are you applying for this benefit? *</label>
                        <div class="reason-group">
                            <div class="reason-item">
                                <input type="checkbox" name="reason" value="Rice (5 kg per person)">
                                <span>Rice (5 kg per person)</span>
                            </div>
                            <div class="reason-item">
                                <input type="checkbox" name="reason" value="Wheat (3 kg per person)">
                                <span>Wheat (3 kg per person)</span>
                            </div>
                            <div class="reason-item">
                                <input type="checkbox" name="reason" value="Sugar (1 kg per family)">
                                <span>Sugar (1 kg per family)</span>
                            </div>
                            <div class="reason-item">
                                <input type="checkbox" name="reason" value="Oil (1 litre per family)">
                                <span>Oil (1 litre per family)</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="button-box">
                <button type="button" class="btn" onclick="previousStep()">← Back</button>
                <div style="display:flex;gap:10px;">
                    <button type="button" class="btn" onclick="printApplication()">Print</button>
                    <button type="submit" class="btn">Submit Application</button>
                </div>
            </div>
        </div>

    </form>

</div>
</div>

<div class="footer">© 2026 Integrated Eligibility System</div>

<script>
let currentStep = 1;

function nextStep(){
    if(currentStep < 3){
        document.getElementById("step"+currentStep).classList.remove("active");
        currentStep++;
        document.getElementById("step"+currentStep).classList.add("active");
    }
}

function previousStep(){
    document.getElementById("step"+currentStep).classList.remove("active");
    currentStep--;
    document.getElementById("step"+currentStep).classList.add("active");
    if(currentStep == 1){
        document.getElementById("mainHeader").style.display="flex";
    }
}

function printApplication(){
    var step1 = document.getElementById("step1");
    var step2 = document.getElementById("step2");
    var step3 = document.getElementById("step3");
    step1.style.display="block";
    step2.style.display="block";
    step3.style.display="block";
    window.print();
    location.reload();
}
</script>
</body>
</html>
