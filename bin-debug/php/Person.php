<?php

require_once("DataMapper.php");
require_once("HTMLFormHelper.php");

class Person {
	
	//properties
	public $id;
	public $first;
	public $last;
	public $email;
	public $phone;
	
	protected $dataMapper;
	protected $htmlHelper;
	
	public function __construct($id = null) {
		
		$this->dataMapper = new DataMapper($this);
		$this->htmlHelper = new HTMLFormHelper($this);
		
		if (is_null($id)) return;
		
		$this->id = $id;
		
		//autoload if we have a legitimate ID
		$this->dataMapper->loadFromDatabase();
		
	}
	
	public function __toString() {
		
		$string = $this->getFullName();
		$string = $string . "\n\temail: ". $this->email;
		$string = $string . "\n\tphone: ". $this->phone. "\n";
		
		return $string;
	}
	
	public function getFullName() {
		return $this->first." ".$this->last;
	}
	
	
	public function show() {
	
		echo '<div class="person">';
		echo '<p><span class="name">'.$this->getFullName().'</span></p>';
		echo '<p><span class="phone">📞 '.$this->phone.'</span> ';
		echo '<span class="email">📮<a href="mailto:"'.$this->email.'" class="email">'.$this->email.'</a></span></br></p>';
		echo '</div>';
	
	}
	
	public function displayAsWebForm() {
		$this->htmlHelper->displayAsWebForm();
	}
	
}



?>

