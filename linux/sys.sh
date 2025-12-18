[Unit]
Description=My Custom Service
After=network.target syslog.target

[Service]
ExecStart=/bin/sleep 350

[Install]
WantedBy=multi-user.target
