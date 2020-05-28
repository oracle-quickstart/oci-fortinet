Content-Type: multipart/mixed; boundary="==OCI=="
MIME-Version: 1.0

--==OCI==
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0

config system global
    set hostname "FortiGate-VM"
    set admintimeout 60
end

--==OCI==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="license"

${license_file}

--==OCI==--