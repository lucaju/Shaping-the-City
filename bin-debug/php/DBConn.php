<?php

class DBConn {
	
	private static $pipeline;
	
	public static function getConnection() {
	
		//if I have no connection, build one
		if (empty(self::$pipeline)) {
		
			self::$pipeline = mysql_pconnect('localhost', 'fluxoart_pipelin', 'shapingTheCity');
			mysql_select_db('fluxoart_shaping_cities');
		}
		
		return self::$pipeline;
	}
	
	
	
}

?>