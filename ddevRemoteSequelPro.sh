#!/bin/bash

connectionName="DDEV DB"

#db Data
dbName=
dbUser=
dbPass=
dbHost=

#SSH connection
sshHost=
sshUser=
sshPass=

# if ssh key used use, write location in and set keyUsed to 1
sshKey=""
sshKeyUsed=0

# Portloading Script
portLoader="/Users/benjamin/Documents/Scripts/ddevDBSequelProPortString.sh $sshHost $sshUser $sshPass"

###################################
# CHANGE BLOW HERE AT YOUR OWN RISK!
###################################


regex='([0-9]+)'
s=$($portLoader)
port="0", lastResult="0"
while [[ $s =~ $regex ]]; do
  s=${s#*"${BASH_REMATCH[1]}"}
  if [ $lastResult == "0" ]
  then
    lastResult="${BASH_REMATCH[1]}"
  else
    port="$lastResult"
    lastResult="${BASH_REMATCH[1]}"
  fi
done


spt="<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
	<key>ContentFilters</key>
	<dict/>
	<key>auto_connect</key>
	<true/>
	<key>data</key>
	<dict>
		<key>connection</key>
		<dict>
			<key>database</key>
			<string>$dbName</string>
			<key>host</key>
			<string>$dbHost</string>
			<key>kcid</key>
			<string>2138997249089839482</string>
			<key>name</key>
			<string>$connectionName</string>
			<key>port</key>
			<integer>$port</integer>
			<key>rdbms_type</key>
			<string>mysql</string>
			<key>ssh_host</key>
			<string>$sshHost</string>
			<key>ssh_keyLocation</key>
			<string>$sshKey</string>
			<key>ssh_keyLocationEnabled</key>
			<integer>$sshKeyUsed</integer>
			<key>ssh_user</key>
			<string>$sshUser</string>
			<key>ssh_password</key>
			<string>$sshPass</string>
			<key>sslCACertFileLocation</key>
			<string></string>
			<key>sslCACertFileLocationEnabled</key>
			<integer>0</integer>
			<key>sslCertificateFileLocation</key>
			<string></string>
			<key>sslCertificateFileLocationEnabled</key>
			<integer>0</integer>
			<key>sslKeyFileLocation</key>
			<string>$sshKey</string>
			<key>sslKeyFileLocationEnabled</key>
			<integer>0</integer>
			<key>type</key>
			<string>SPSSHTunnelConnection</string>
			<key>useSSL</key>
			<integer>0</integer>
			<key>user</key>
			<string>$dbUser</string>
			<key>password</key>
			<string>$dbPass</string>
		</dict>
		<key>session</key>
		<dict>
			<key>connectionEncoding</key>
			<string>utf8</string>
			<key>contentPageNumber</key>
			<integer>1</integer>
			<key>contentSortColIsAsc</key>
			<true/>
			<key>contentViewport</key>
			<string>{{0, 0}, {864, 534}}</string>
			<key>isToolbarVisible</key>
			<true/>
			<key>view</key>
			<string>SP_VIEW_CONTENT</string>
			<key>windowVerticalDividerPosition</key>
			<real>300</real>
		</dict>
	</dict>
	<key>encrypted</key>
	<false/>
	<key>format</key>
	<string>connection</string>
	<key>queryFavorites</key>
	<array/>
	<key>queryHistory</key>
	<array/>
	<key>rdbms_type</key>
	<string>mysql</string>
	<key>rdbms_version</key>
	<string>5.5.5-10.2.27-MariaDB-1:10.2.27+maria~bionic-log</string>
	<key>version</key>
	<integer>1</integer>
</dict>
</plist>
"

echo "$spt" > /tmp/sp_maple.spf
open /Applications/Sequel\ Pro.app /tmp/sp_maple.spf
