<?php
	echo("File Name : " . $filename . "<br>\n");
echo("start<br>\n<pre>");
$fp = fopen($filename_name, "r");
$in = fread($fp, 4096);
echo($in);
fclose($fp);
unlink($filename_name);
echo("</pre>\nend\n");

?>
