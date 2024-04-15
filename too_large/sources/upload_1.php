<html>
<head>
<title>File Upload Result</title>
</head>
<body>
<?php
function do_upload($FileName, $orgname) { 

	// NOTE WINDOWS USERS! 
	// You must use "\\" instead of "\" in your paths! 
	$upload_path = "/user2/jsbaek/xecureweb_ver4/demo/file/fileup/"; 
	$file = basename($FileName); 
	
	if ( $FileName == "none" ) { 
		$error_msg = "You did not specify a file for uploading."; 
		return; 
	} 
	$newfile = $upload_path . $orgname;
	echo $FileName . "<br>";
	echo $newfile . "<br>";
	if (!copy($FileName, $newfile)) {
		$error_msg = "failed to copy $file...\n";
		return; 
	} 
} 
do_upload($userfile[0], $userfile_name[0]); 
do_upload($userfile[1], $userfile_name[1]); 
?> 
<TABLE> 
<TR> 
<TD>USER FILE:</TD><TD><?php  echo $userfile[0]; ?></TD> 
</TR> 
<TR> 
<TD>USER FILE NAME:</TD><TD><?php  echo $userfile_name[0]; ?></TD> 
</TR> 
<TR> 
<TD>USER FILE SIZE:</TD><TD><?php  echo $userfile_size[0]; ?></TD> 
</TR> 
<TR> 
<TD>USER FILE TYPE:</TD><TD><?php echo $userfile_type[0]; ?></TD> 
</TR> 
</TABLE><BR> 
<TABLE> 
<TR> 
<TD>USER FILE:</TD><TD><?php  echo $userfile[1]; ?></TD> 
</TR> 
<TR> 
<TD>USER FILE NAME:</TD><TD><?php  echo $userfile_name[1]; ?></TD> 
</TR> 
<TR> 
<TD>USER FILE SIZE:</TD><TD><?php  echo $userfile_size[1]; ?></TD> 
</TR> 
<TR> 
<TD>USER FILE TYPE:</TD><TD><?php echo $userfile_type[1]; ?></TD> 
</TR> 
</TABLE> 
<?php 
if ( $error_msg ) { 
	echo "<B> $error_msg </B>"; 
} 
else { 
	echo "<B> File upload successful! </B>"; 
} 
?> 
</BODY> 
</HTML> 


