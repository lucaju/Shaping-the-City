<?php

require_once("Person.php");

try {
	$p = new Person(1000);
	echo "$p";
} catch (Exception $e) {
	echo $e->getMessage()."\n";	
}



?>