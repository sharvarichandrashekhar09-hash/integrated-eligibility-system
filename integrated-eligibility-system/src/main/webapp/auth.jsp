
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>IES Authentication</title>

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:Arial,sans-serif;
}

body{
    height:100vh;
    background:url('https://images.unsplash.com/photo-1520607162513-77705c0f0d4a?q=80&w=1470&auto=format&fit=crop')
    no-repeat center center/cover;
    overflow:hidden;
}

.overlay{
    width:100%;
    height:100vh;
    background:rgba(0,0,0,0.55);
}

.navbar{
    width:100%;
    padding:18px 40px;
    display:flex;
    justify-content:space-between;
    align-items:center;
    background:rgba(0,0,0,0.35);
}

.logo{
    color:white;
    font-size:34px;
    font-weight:bold;
}

.nav-links{
    display:flex;
    gap:15px;
}

.nav-links a{
    text-decoration:none;
    color:white;
    background:#3a3a3a;
    padding:10px 22px;
    border-radius:25px;
    font-size:14px;
    font-weight:bold;
}

.container{
    width:100%;
    display:flex;
    justify-content:center;
    align-items:center;
    margin-top:30px;
}

.auth-box{
    width:850px;
    min-height:650px;
    background:rgba(255,255,255,0.10);
    backdrop-filter:blur(12px);
    border-radius:30px;
    padding:30px 40px;
    color:white;
    overflow-y:auto;
}

.toggle-btns{
    width:320px;
    height:55px;
    background:#222;
    margin:auto;
    border-radius:40px;
    display:flex;
    overflow:hidden;
}

.toggle-btns button{
    width:50%;
    border:none;
    cursor:pointer;
    font-size:17px;
    font-weight:bold;
    color:white;
    background:transparent;
    transition:0.4s;
}

.toggle-btns button.active{
    background:#22c55e;
}

.form-box{
    margin-top:30px;
}

.form-box h1{
    text-align:center;
    margin-bottom:30px;
}

.input-group{
    margin-bottom:18px;
}

.input-group label{
    display:block;
    margin-bottom:8px;
    font-size:14px;
    font-weight:bold;
}

.input-group input,
.input-group select{
    width:100%;
    padding:14px;
    border:none;
    border-bottom:2px solid rgba(255,255,255,0.4);
    background:transparent;
    color:white;
    font-size:15px;
    outline:none;
}

.input-group input::placeholder{
    color:#ddd;
}

.input-group select{
    background:#111;
}

.row{
    display:flex;
    gap:20px;
}

.row .input-group{
    width:50%;
}

.submit-btn{
    width:180px;
    padding:14px;
    border:none;
    border-radius:35px;
    background:#22c55e;
    color:white;
    font-size:16px;
    font-weight:bold;
    cursor:pointer;
}

.center-btn{
    display:flex;
    justify-content:center;
    margin-top:20px;
}

.otp-btn{
    margin-top:30px;
    width:140px;
    height:48px;
    border:none;
    border-radius:30px;
    background:#22c55e;
    color:white;
    font-weight:bold;
    cursor:pointer;
}

#registerForm{
    display:none;
}

#otpSection{
    display:none;
}

.footer{
    width:100%;
    text-align:center;
    color:white;
    position:absolute;
    bottom:10px;
    font-size:14px;
}

</style>

</head>

<body>

<div class="overlay">

    <div class="navbar">

        <div class="logo">
            IES
        </div>

        <div class="nav-links">
            <a href="#">Home</a>
            <a href="#">About</a>
        </div>

    </div>

    <div class="container">

        <div class="auth-box">

            <div class="toggle-btns">

                <button class="active"
                    id="loginToggle"
                    onclick="showLogin()">

                    Login

                </button>

                <button id="registerToggle"
                    onclick="showRegister()">

                    Registration

                </button>

            </div>

            <!-- LOGIN -->

            <div id="loginForm"
                 class="form-box">

                <h1>Login Account</h1>

                <form action="LoginServlet"
                      method="post">

                    <div class="input-group">

                        <label>
                            Employee Type *
                        </label>

                        <select name="employee_type"
                                id="employeeType"
                                onchange="toggleCaptcha()"
                                required>

                            <option value="">
                                Select Role
                            </option>

                            <option>User</option>
                            <option>CaseWorker</option>
                            <option>Admin</option>

                        </select>

                    </div>

                    <div class="input-group">

                        <label>Email *</label>

                        <input type="email"
                               name="email"
                               placeholder="Enter Email"
                               required>

                    </div>

                    <div class="input-group">

                        <label>Password *</label>

                        <input type="password"
                               name="password"
                               placeholder="Enter Password"
                               required>

                    </div>

                    <!-- CAPTCHA -->

                    <div id="captchaSection"
                         style="display:none;">

                        <div style="
                            display:flex;
                            align-items:center;
                            gap:15px;
                        ">

                            <img src="CaptchaServlet"
                                 id="captchaImage"
                                 style="
                                 border-radius:10px;
                                 border:2px solid white;
                            ">

                            <button type="button"
                                    onclick="refreshCaptcha()"
                                    style="
                                    padding:12px;
                                    border:none;
                                    border-radius:8px;
                                    background:#22c55e;
                                    color:white;
                                    cursor:pointer;
                                    font-weight:bold;
                            ">

                                ↻

                            </button>

                        </div>

                        <div class="input-group"
                             style="margin-top:15px;">

                            <input type="text"
                                   name="captchaInput"
                                   placeholder="Enter Captcha">

                        </div>

                    </div>

                    <div class="center-btn">

                        <button type="submit"
                                class="submit-btn">

                            Login

                        </button>

                    </div>

                </form>

            </div>

            <!-- REGISTRATION -->

            <div id="registerForm"
                 class="form-box">

                <h1>Create Account</h1>

                <form action="RegisterServlet"
                      method="post">

                    <div class="input-group">

                        <label>
                            Employee Type *
                        </label>

                        <select name="employee_type"
                                required>

                            <option value="">
                                Select Role
                            </option>

                            <option>User</option>
                            <option>CaseWorker</option>

                        </select>

                    </div>

                    <div class="row">

                        <div class="input-group">

                            <label>
                                First Name *
                            </label>

                            <input type="text"
                                   name="first_name"
                                   placeholder="Enter First Name"
                                   required>

                        </div>

                        <div class="input-group">

                            <label>
                                Middle Name *
                            </label>

                            <input type="text"
                                   name="middle_name"
                                   placeholder="Enter Middle Name"
                                   required>

                        </div>

                    </div>

                    <div class="input-group">

                        <label>
                            Surname *
                        </label>

                        <input type="text"
                               name="surname"
                               placeholder="Enter Surname"
                               required>

                    </div>

                    <div class="row">

                        <div class="input-group">

                            <label>
                                Gender *
                            </label>

                            <select name="gender"
                                    required>

                                <option value="">
                                    Select Gender
                                </option>

                                <option>Male</option>
                                <option>Female</option>
                                <option>Other</option>

                            </select>

                        </div>

                        <div class="input-group">

                            <label>
                                Date Of Birth *
                            </label>

                            <input type="date"
                                   name="dob"
                                   required>

                        </div>

                    </div>

                    <div class="row">

                        <div class="input-group">

                            <label>Email *</label>

                            <input type="email"
                                   id="email"
                                   name="email"
                                   placeholder="Enter Email"
                                   required>

                        </div>

                        <div style="
                            display:flex;
                            align-items:end;
                        ">

                            <button type="button"
                                    class="otp-btn"
                                    onclick="sendOTP()">

                                Send OTP

                            </button>

                        </div>

                    </div>

                    <div id="otpSection">

                        <div class="input-group">

                            <label>
                                Verify OTP *
                            </label>

                            <input type="text"
                                   name="otp"
                                   placeholder="Enter OTP">

                        </div>

                    </div>

                    <div class="input-group">

                        <label>
                            Mobile *
                        </label>

                        <input type="text"
                               name="mobile"
                               maxlength="10"
                               placeholder="Enter Mobile Number"
                               required>

                    </div>

                    <div class="input-group">

                        <label>
                            Password *
                        </label>

                        <input type="password"
                               name="password"
                               placeholder="Enter Password"
                               required>

                    </div>

                    <div class="center-btn">

                        <button type="submit"
                                class="submit-btn">

                            Registration

                        </button>

                    </div>

                </form>

            </div>

        </div>

    </div>

    <div class="footer">
        © 2026 Integrated Eligibility System
        | All Rights Reserved
    </div>

</div>

<script>

function showLogin(){

    document.getElementById(
        "loginForm"
    ).style.display="block";

    document.getElementById(
        "registerForm"
    ).style.display="none";

    document.getElementById(
        "loginToggle"
    ).classList.add("active");

    document.getElementById(
        "registerToggle"
    ).classList.remove("active");
}

function showRegister(){

    document.getElementById(
        "loginForm"
    ).style.display="none";

    document.getElementById(
        "registerForm"
    ).style.display="block";

    document.getElementById(
        "registerToggle"
    ).classList.add("active");

    document.getElementById(
        "loginToggle"
    ).classList.remove("active");
}

function sendOTP(){

    let email =
        document.getElementById(
            "email"
        ).value;

    if(email==""){

        alert("Enter Email First");
        return;
    }

    let xhr =
        new XMLHttpRequest();

    xhr.open(
        "POST",
        "SendOtpServlet",
        true
    );

    xhr.setRequestHeader(
        "Content-type",
        "application/x-www-form-urlencoded"
    );

    xhr.onreadystatechange =
        function(){

        if(xhr.readyState==4
            && xhr.status==200){

            let response =
                xhr.responseText;

            if(response.trim()=="success"){

                alert(
                    "OTP Sent Successfully"
                );

                document.getElementById(
                    "otpSection"
                ).style.display="block";

            } else {

                alert(
                    "Failed To Send OTP"
                );
            }
        }
    };

    xhr.send(
        "email="+email
    );
}

function toggleCaptcha(){

    let role =
        document.getElementById(
            "employeeType"
        ).value;

    if(role=="Admin"){

        document.getElementById(
            "captchaSection"
        ).style.display="block";

    } else {

        document.getElementById(
            "captchaSection"
        ).style.display="none";
    }
}

function refreshCaptcha(){

    document.getElementById(
        "captchaImage"
    ).src =
        "CaptchaServlet?dummy="
        + Math.random();
}

</script>

</body>
</html>
