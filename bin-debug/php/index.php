<html>
<head>
	<meta http-equiv='Content-Type' content='text/html; charset=utf-8'>
	<title>Birds Club!</title>
	<link rel="stylesheet" conten="text/css" href="style.css">
</head>
<body>

<?php

require_once("Person.php");


try {
	$p = new Person(1);
	//echo "$p";
	//$p->displayAsWebForm();
} catch (Exception $e) {
	echo $e->getMessage()."\n";
	exit;	
}

$p->displayAsWebForm();

?>

</body>
</html>