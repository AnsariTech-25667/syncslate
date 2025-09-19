import nodemailer from "nodemailer";

export const transporter = nodemailer.createTransport({
  host: process.env.SMTP_HOST!,
  port: Number(process.env.SMTP_PORT || 587),
  secure: false,
  auth: { user: process.env.SMTP_USER!, pass: process.env.SMTP_PASS! }
});

export async function sendBookingEmail(to: string, subject: string, html: string, ics?: Buffer) {
  await transporter.sendMail({
    from: process.env.MAIL_FROM || "no-reply@syncslate.app",
    to, subject, html,
    attachments: ics ? [{ filename: "invite.ics", content: ics, contentType: "text/calendar" }] : []
  });
}
