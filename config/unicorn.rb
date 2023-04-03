# set path to application
app_path = "/root/projects/email_administration_system"
# shared_dir = "#{app_dir}/shared"
working_directory "#{app_path}"
​
​
# Set unicorn options
worker_processes 1
preload_app true
timeout 120
​
# Set up socket location
listen "/tmp/email-admin.sock"
​
# Logging
stderr_path "#{app_path}/log/unicorn.log"
stdout_path "#{app_path}/log/unicorn.log"
​
# Set master PID location
"#{app_path}/tmp/pids/unicorn.pid"