<?php

require_once("DBConn.php");

class DataMapper {
	
	
	//has once responsability
	//1. handles all data I/O for a Person Object
	
	protected $owner;
	protected $pipeline;
	
	public function __construct($owner) {
		$this->owner = $owner;
		
		//step 1: connect to DB
		// -> access variables and methods in a object
		// :: access Static variables and methods in a class 
		
		$pipeline = DBConn::getConnection();	
	}
	
	public function loadFromDatabase() {
			
		//step 2: performs a query
		$query = "SELECT * FROM member WHERE id = {$this->owner->id}";
		$cloud = mysql_query($query);
		
		if (mysql_num_rows($cloud) != 1) {
			throw new Exception("There is nobody with ID {$this->owner->id}");
			//return;
		}
		
		$row = mysql_fetch_assoc($cloud);
		
		//step 3: load up data
		$this->owner->first = $row['first'];
		$this->owner->last = $row['last'];
		$this->owner->email = $row['email'];
		$this->owner->phone = $row['phone'];
		
	}
	
	
}


?>