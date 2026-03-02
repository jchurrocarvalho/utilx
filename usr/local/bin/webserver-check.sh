#!/bin/bash

#
# Released under MIT License
# Copyright (c) 2018-2025 Jose Manuel Churro Carvalho
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software 
# and associated documentation files (the "Software"), to deal in the Software without restriction, 
# including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
# and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

# Print the OS release information
echo "### OS Release Information ###"
cat /etc/os-release

# Find directories related to Apache or httpd
echo "# Apache/HTTPD Directories"
find /etc -type d \( -name 'httpd' -o -name 'apache2' \)

# List running httpd processes
echo "# Running httpd processes"
ps aux | grep '[h]ttpd'

# List running nginx processes
echo "# Running nginx processes"
ps aux | grep '[n]ginx'

# List running lighttpd processes
echo "# Running lighttpd processes"
ps aux | grep '[l]ighttpd'

# List running Docker processes
echo "# Running Docker processes"
ps aux | grep '[d]ocker'

# Check installed packages for Apache, nginx, lighttpd and Docker
echo "# Installed Web Server Packages"
rpm -qa | grep -E 'httpd|nginx|lighttpd'

echo "# Installed Docker packages"
rpm -qa | grep -E 'docker'

echo "# Installed Apache packages"
rpm -qa | grep -E 'apache|apache2'

# List Apache configuration files
echo "# Apache configuration files"
if [ -d /etc/httpd ]; then
    ls /etc/httpd/conf.d/
    ls /etc/httpd/conf/
elif [ -d /etc/apache2 ]; then
    ls /etc/apache2/sites-available/
    ls /etc/apache2/sites-enabled/
fi

# Check for other potential web servers
echo "# Checking for other web servers"
ps aux | grep -E '[t]omcat|[j]etty|[p]ython3?-m http.server'

# List all network services listening on ports typically used by web servers
echo "# Network Services listening on common web server ports"
ss -tuln | grep -E ':80|:443|:8080|:8443'

retvalue=$?

exit "$retvalue"

