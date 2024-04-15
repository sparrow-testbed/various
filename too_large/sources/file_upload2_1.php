
<?php
function move($original, $new) {
	copy($original , $new)
	or die("Can not Copy");
	unlink($original)
	or die("Cannot delete");
}

echo("file Name : " . $filename . "<br>\n");
move($filename_name, $filename);

?>
