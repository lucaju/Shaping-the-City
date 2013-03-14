<html>
<head>
	<meta http-equiv='Content-Type' content='text/html; charset=utf-8'>
	<title>Birds Club!</title>
	<link rel="stylesheet" conten="text/css" href="style.css">
</head>
<body>

<?php

require_once("Person.php");

for ($i = 1; $i < 20; $i++ ) {

	try {
		$p = new Person($i);
		//echo "$p";
		$p->show();
	} catch (Exception $e) {
		echo $e->getMessage()."\n";	
	}
	
	echo '<p class="wrapper">-----------------------------</p>';
}

?>

</body>
</html>