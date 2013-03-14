<?php
	
	$db_pipeline = mysql_pconnect('localhost', 'fluxoart_pipelin', 'shapingTheCity');
	$success = mysql_select_db('fluxoart_shaping_cities');
	
	if(!$success) {
		echo "<p>Sorry. An error occurred</p>";
	}
?>