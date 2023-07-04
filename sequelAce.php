#!/opt/homebrew/opt/php@8.1/bin/php
<?php declare(strict_types=1);


$SSH_TARGET = 'maple';
$SSH_COMMAND = 'docker ps | grep \'db\'';
$MYSQL_USER = 'db';
$MYSQL_PASS = 'db';
$MYSQL_DB = 'db';
$FILTER_REGEX = '/((?:[0-9]{1,3}\.){3}[0-9]{1,3}):(\d+?)->3306/m';

$ssh_answer = shell_exec('ssh '. $SSH_TARGET .' "'. $SSH_COMMAND .'" 2>&1');
preg_match_all($FILTER_REGEX, $ssh_answer, $matches, PREG_SET_ORDER, 0);

$ip = $matches[0][1]??'127.0.0.1';
$port = (int)($matches[0][2]??'0');

if (count($matches[0]??[]) <= 2 || $port === 0) {
    echo "DDEV DB PORT NOT FOUND";
    exit();
}

$longInt = random_int(1_000_000_000_000, 9_999_999_999_999);

$payload = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
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
			<key>allowDataLocalInfile</key>
			<integer>0</integer>
			<key>database</key>
			<string>".$MYSQL_DB."</string>
			<key>enableClearTextPlugin</key>
			<integer>0</integer>
			<key>host</key>
			<string>".$ip."</string>
			<key>kcid</key>
			<string>-769920".$longInt."</string>
			<key>name</key>
			<string>maple</string>
			<key>password</key>
			<string>".$MYSQL_PASS."</string>
			<key>port</key>
			<integer>".$port."</integer>
			<key>rdbms_type</key>
			<string>mysql</string>
			<key>ssh_host</key>
			<string>maple</string>
			<key>ssh_keyLocation</key>
			<string>/Users/b.rannow/.ssh/id_ed25519</string>
			<key>ssh_keyLocationEnabled</key>
			<integer>1</integer>
			<key>ssh_password</key>
			<string></string>
			<key>ssh_user</key>
			<string>benjamin</string>
			<key>sslCACertFileLocation</key>
			<string></string>
			<key>sslCACertFileLocationEnabled</key>
			<integer>0</integer>
			<key>sslCertificateFileLocation</key>
			<string></string>
			<key>sslCertificateFileLocationEnabled</key>
			<integer>0</integer>
			<key>sslKeyFileLocation</key>
			<string></string>
			<key>sslKeyFileLocationEnabled</key>
			<integer>0</integer>
			<key>type</key>
			<string>SPSSHTunnelConnection</string>
			<key>useSSL</key>
			<integer>0</integer>
			<key>user</key>
			<string>".$MYSQL_USER."</string>
		</dict>
	</dict>
	<key>encrypted</key>
	<false/>
	<key>format</key>
	<string>connection</string>
	<key>queryFavorites</key>
	<array/>
	<key>rdbms_type</key>
	<string>mysql</string>
	<key>rdbms_version</key>
	<string>5.5.5-10.2.44-MariaDB-1:10.2.44+maria~bionic-log</string>
	<key>version</key>
	<integer>1</integer>
</dict>
</plist>
";

$spfFile = sys_get_temp_dir().'/ddev.spf';
file_put_contents($spfFile, $payload);
exec("open /Applications/Sequel\ Ace.app " . $spfFile);
