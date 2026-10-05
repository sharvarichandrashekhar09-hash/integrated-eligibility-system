
package com.eligibility.servlet;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.Random;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/CaptchaServlet")
public class CaptchaServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)

            throws ServletException, IOException {

        int width = 220;
        int height = 70;

        BufferedImage image =
                new BufferedImage(
                        width,
                        height,
                        BufferedImage.TYPE_INT_RGB
                );

        Graphics2D g =
                image.createGraphics();

        // Background

        g.setColor(new Color(230,240,250));
        g.fillRect(0,0,width,height);

        // Random captcha text

        String chars =
                "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";

        Random random =
                new Random();

        StringBuilder captcha =
                new StringBuilder();

        for(int i=0;i<8;i++){

            captcha.append(
                    chars.charAt(
                            random.nextInt(chars.length())
                    )
            );
        }

        // Save captcha in session

        HttpSession session =
                request.getSession();

        session.setAttribute(
                "captcha",
                captcha.toString()
        );

        // Noise Lines

        for(int i=0;i<15;i++){

            g.setColor(new Color(
                    random.nextInt(255),
                    random.nextInt(255),
                    random.nextInt(255)
            ));

            int x1 =
                    random.nextInt(width);

            int y1 =
                    random.nextInt(height);

            int x2 =
                    random.nextInt(width);

            int y2 =
                    random.nextInt(height);

            g.drawLine(x1,y1,x2,y2);
        }

        // Draw captcha characters

        g.setFont(
                new Font(
                        "Arial",
                        Font.BOLD,
                        38
                )
        );

        for(int i=0;i<captcha.length();i++){

            g.setColor(new Color(
                    random.nextInt(100),
                    random.nextInt(100),
                    random.nextInt(100)
            ));

            int angle =
                    random.nextInt(30)-15;

            g.rotate(
                    Math.toRadians(angle),
                    25 + (i*22),
                    45
            );

            g.drawString(
                    String.valueOf(
                            captcha.charAt(i)
                    ),

                    20 + (i*22),
                    45
            );

            g.rotate(
                    Math.toRadians(-angle),
                    25 + (i*22),
                    45
            );
        }

        // Dots Noise

        for(int i=0;i<100;i++){

            g.setColor(new Color(
                    random.nextInt(255),
                    random.nextInt(255),
                    random.nextInt(255)
            ));

            int x =
                    random.nextInt(width);

            int y =
                    random.nextInt(height);

            g.fillOval(x,y,2,2);
        }

        g.dispose();

        response.setContentType("image/png");

        ImageIO.write(
                image,
                "png",
                response.getOutputStream()
        );
    }
}

