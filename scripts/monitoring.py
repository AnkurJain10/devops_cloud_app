import subprocess
import smtplib
import re

from email.mime.text import MIMEText
disk_threshold = 10
cpu_threshold = 10
partition = "/"

def report_disk_via_email(usage):
	msg = MIMEText("Server running out of disk space. Current usage = %s percent" %usage)
	msg["Subject"] = "Low disk space warning!"
	msg["From"] = "ubuntu@ec2-<serverIP>.compute-1.amazonaws.com"
	msg["To"] = "<receiver email>"
	#subprocess.Popen(["sendmail","-v","ankur10@terpmail.umd.edu"], stdout=subprocess.PIPE)
	with smtplib.SMTP("localhost") as server:
		server.ehlo()
		server.starttls()
		server.sendmail("ubuntu@ec2-<serverIP>.compute-1.amazonaws.com","<receiver email>",msg.as_string())


def report_cpu_via_email(usage):
	msg = MIMEText("Server CPU usage is very high! CPU usage over the last 5 mins = %s percent" %usage)

	msg["Subject"] = "High CPU utilization warning!"
	msg["From"] = "ubuntu@ec2-<serverIP>.compute-1.amazonaws.com"
	msg["To"] = "<receiver email>"
	with smtplib.SMTP("localhost") as server:
		server.ehlo()
		server.starttls()
		server.sendmail("ubuntu@ec2-<serverIP>.compute-1.amazonaws.com","<receiver email>",msg.as_string())

def check_disk_usage():
	df = subprocess.Popen(["df","-h"], stdout=subprocess.PIPE)
	for line in df.stdout:
		splitline = line.decode().split()
		if splitline[5] == partition:
			if int(splitline[4][:-1]) > disk_threshold:
				report_disk_via_email(splitline[4][:-1])

def check_cpu_usage():
	df = subprocess.Popen(["uptime"], stdout=subprocess.PIPE)
	for line in df.stdout:
		splitline = str(line.decode())
		splitline = re.split(', | ',splitline)
		if float(splitline[11])>cpu_threshold:
			report_cpu_via_email(splitline[11])

check_disk_usage()
check_cpu_usage()
