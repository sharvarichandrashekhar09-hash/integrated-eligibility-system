
package com.eligibility.util;

import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class EmailUtility {

    // Sender Email
    private static final String FROM_EMAIL =
            "aptikarjui@gmail.com";

    // Gmail App Password
    private static final String PASSWORD =
            "wlxanshxqwgcstrp";

    public static boolean sendOTP(String toEmail,
                                  String otp) {

        boolean flag = false;

        Properties props = new Properties();

        props.put(
                "mail.smtp.auth",
                "true"
        );

        props.put(
                "mail.smtp.starttls.enable",
                "true"
        );

        props.put(
                "mail.smtp.host",
                "smtp.gmail.com"
        );

        props.put(
                "mail.smtp.port",
                "587"
        );

        Session session = Session.getInstance(
                props,

                new Authenticator() {

                    protected PasswordAuthentication
                    getPasswordAuthentication() {

                        return new PasswordAuthentication(
                                FROM_EMAIL,
                                PASSWORD
                        );
                    }
                }
        );

        try {

            Message message =
                    new MimeMessage(session);

            message.setFrom(
                    new InternetAddress(FROM_EMAIL)
            );

            message.setRecipients(
                    Message.RecipientType.TO,

                    InternetAddress.parse(toEmail)
            );

            message.setSubject(
                    "IES Registration OTP"
            );

            message.setText(

                    "Your OTP is : "
                    + otp +

                    "\n\nValid For 10 Minutes."

            );

            Transport.send(message);

            flag = true;

        } catch (Exception e) {

            e.printStackTrace();
        }

        return flag;
    }
    public static void sendMail(

            String toEmail,

            String subject,

            String body)

            throws Exception {

        Properties props =
        new Properties();

        props.put(
        "mail.smtp.auth",
        "true"
        );

        props.put(
        "mail.smtp.starttls.enable",
        "true"
        );

        props.put(
        "mail.smtp.host",
        "smtp.gmail.com"
        );

        props.put(
        "mail.smtp.port",
        "587"
        );

        Session session =
        Session.getInstance(

        props,

        new Authenticator(){

            protected PasswordAuthentication
            getPasswordAuthentication(){

                return new PasswordAuthentication(

                FROM_EMAIL,

                PASSWORD

                );

            }

        }

        );

        Message message =
        new MimeMessage(session);

        message.setFrom(

        new InternetAddress(
        FROM_EMAIL
        )

        );

        message.setRecipients(

        Message.RecipientType.TO,

        InternetAddress.parse(
        toEmail
        )

        );

        message.setSubject(
        subject
        );

        message.setText(
        body
        );

        Transport.send(
        message
        );

    }
}

