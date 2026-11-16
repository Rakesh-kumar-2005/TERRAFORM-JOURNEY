locals {
  primary_user_data = <<-EOF
   #!?bin/bash
   apt-get update -y
   apt-get install nginx -y
   systemctl start nginx
   systemctl enable nginx
   echo "<h1>Welcome to the Primary Region ${var.primary_region}</h1>" > /var/www/html/index.html
   echo "<h2>Private ip :- ${hostname -I}</h2>" >> /var/www/html/index.html
EOF
 
  secondary_user_data = <<-EOF
   #!?bin/bash
   apt-get update -y
   apt-get install nginx -y
   systemctl start nginx
   systemctl enable nginx
   echo "<h1>Welcome to the Secondary Region ${var.secondary_region}</h1>" > /var/www/html/index.html
   echo "<h2>Private ip :- ${hostname -I}</h2>" >> /var/www/html/index.html
EOF

}