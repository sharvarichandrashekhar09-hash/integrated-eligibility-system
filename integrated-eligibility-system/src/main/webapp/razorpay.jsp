<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<!DOCTYPE html>
<html>
<head>

<title>Processing Payment</title>

<script src=
"https://checkout.razorpay.com/v1/checkout.js">
</script>

</head>

<body>

<h2 align="center">

Opening Razorpay...

</h2>

<script>

var options = {

key:

"key:

"rzp_live_SvsHUVeOv5ukRp",

amount:

<%=request.getAttribute(
"amount"
)%>*100,

currency:

"INR",

name:

"Integrated Eligibility System",

description:

"Application Fee",

order_id:

"<%=request.getAttribute(
"orderId"
)%>",

handler:

function(response){

window.location=

"PaymentSuccessServlet"

+

"?paymentId="

+

response.razorpay_payment_id

+

"&orderId="

+

response.razorpay_order_id

+

"&applicationId="

+

"<%=request.getAttribute(
"applicationId"
)%>"

+

"&userName="

+

"<%=request.getAttribute(
"userName"
)%>"

+

"&email="

+

"<%=request.getAttribute(
"email"
)%>"

+

"&planId="

+

"<%=request.getAttribute(
"planId"
)%>"

+

"&planName="

+

"<%=request.getAttribute(
"planName"
)%>"

+

"&amount="

+

"<%=request.getAttribute(
"amount"
)%>";

}

};

var rzp =

new Razorpay(
options
);

rzp.open();

</script>

</body>
</html>