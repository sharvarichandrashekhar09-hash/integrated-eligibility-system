package com.eligibility.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.eligibility.util.DBConnection;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;



import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Font;
import com.itextpdf.text.Element;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.Document;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;

@WebServlet("/ReceiptServlet")
public class ReceiptServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(

            HttpServletRequest request,

            HttpServletResponse response)

            throws ServletException, IOException {

        try {

            String txnId =

                    request.getParameter(
                    "txn"
                    );

            Connection con =
                    DBConnection.getConnection();

            PreparedStatement ps =

                    con.prepareStatement(

                    "SELECT * FROM payments "
                    + "WHERE transaction_id=?"

                    );

            ps.setString(
                    1,
                    txnId
            );

            ResultSet rs =
                    ps.executeQuery();

            if(rs.next()){

            	response.setContentType("application/pdf");

            	response.setHeader(
            	"Content-Disposition",
            	"attachment;filename=IES_Invoice.pdf"
            	);

            	Document document =
            	new Document();

            	PdfWriter.getInstance(
            	document,
            	response.getOutputStream()
            	);

            	document.open();

            	Font titleFont =
            	new Font(
            	Font.FontFamily.HELVETICA,
            	20,
            	Font.BOLD
            	);

            	Font headerFont =
            	new Font(
            	Font.FontFamily.HELVETICA,
            	12,
            	Font.BOLD
            	);

            	Font normalFont =
            	new Font(
            	Font.FontFamily.HELVETICA,
            	11
            	);

            	Paragraph company =
            	new Paragraph(
            	"INTEGRATED ELIGIBILITY SYSTEM",
            	titleFont
            	);

            	company.setAlignment(
            	Element.ALIGN_CENTER
            	);

            	document.add(company);

            	document.add(
            	new Paragraph(" ")
            	);

            	Paragraph invoice =
            	new Paragraph(
            	"PAYMENT INVOICE",
            	headerFont
            	);

            	invoice.setAlignment(
            	Element.ALIGN_CENTER
            	);

            	document.add(invoice);

            	document.add(
            	new Paragraph(" ")
            	);

            	PdfPTable info =
            	new PdfPTable(2);

            	info.setWidthPercentage(100);

            	info.addCell(
            	new Phrase(
            	"Invoice No",
            	headerFont
            	)
            	);

            	info.addCell(
            	"IES-" +
            	rs.getInt("payment_id")
            	);

            	info.addCell(
            	new Phrase(
            	"Transaction ID",
            	headerFont
            	)
            	);

            	info.addCell(
            	rs.getString(
            	"transaction_id"
            	)
            	);

            	info.addCell(
            	new Phrase(
            	"Date",
            	headerFont
            	)
            	);

            	info.addCell(
            	String.valueOf(
            	rs.getTimestamp(
            	"payment_date"
            	)
            	)
            	);

            	document.add(info);

            	document.add(
            	new Paragraph(" ")
            	);

            	PdfPTable customer =
            	new PdfPTable(2);

            	customer.setWidthPercentage(100);

            	customer.addCell(
            	new Phrase(
            	"Applicant Name",
            	headerFont
            	)
            	);

            	customer.addCell(
            	rs.getString(
            	"user_name"
            	)
            	);

            	customer.addCell(
            	new Phrase(
            	"Email",
            	headerFont
            	)
            	);

            	customer.addCell(
            	rs.getString(
            	"user_email"
            	)
            	);

            	customer.addCell(
            	new Phrase(
            	"Plan Name",
            	headerFont
            	)
            	);

            	customer.addCell(
            	rs.getString(
            	"plan_name"
            	)
            	);

            	document.add(customer);

            	document.add(
            	new Paragraph(" ")
            	);

            	PdfPTable payment =
            	new PdfPTable(4);

            	payment.setWidthPercentage(100);

            	payment.addCell(
            	new Phrase(
            	"Description",
            	headerFont
            	)
            	);

            	payment.addCell(
            	new Phrase(
            	"Mode",
            	headerFont
            	)
            	);

            	payment.addCell(
            	new Phrase(
            	"Status",
            	headerFont
            	)
            	);

            	payment.addCell(
            	new Phrase(
            	"Amount",
            	headerFont
            	)
            	);

            	payment.addCell(
            	"Application Payment"
            	);

            	payment.addCell(
            	rs.getString(
            	"payment_mode"
            	)
            	);

            	payment.addCell(
            	rs.getString(
            	"payment_status"
            	)
            	);

            	payment.addCell(
            	"₹" +
            	rs.getDouble(
            	"amount"
            	)
            	);

            	document.add(payment);

            	document.add(
            	new Paragraph(" ")
            	);

            	Paragraph total =
            	new Paragraph(

            	"TOTAL AMOUNT PAID : ₹"

            	+

            	rs.getDouble(
            	"amount"
            	),

            	new Font(
            	Font.FontFamily.HELVETICA,
            	14,
            	Font.BOLD
            	)

            	);

            	total.setAlignment(
            	Element.ALIGN_RIGHT
            	);

            	document.add(total);

            	document.add(
            	new Paragraph("\n")
            	);

            	Paragraph sign =
            	new Paragraph(
            	"Authorized Signature",
            	headerFont
            	);

            	sign.setAlignment(
            	Element.ALIGN_RIGHT
            	);

            	document.add(sign);

            	document.add(
            	new Paragraph("\n")
            	);

            	Paragraph note =
            	new Paragraph(
            	"This is a computer generated invoice.",
            	normalFont
            	);

            	note.setAlignment(
            	Element.ALIGN_CENTER
            	);

            	document.add(note);

            	document.close();
            }

            rs.close();
            ps.close();
            con.close();

        }

        catch(Exception e){

            e.printStackTrace();

        }

    }

}