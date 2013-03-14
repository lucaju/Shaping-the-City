<?php

class HTMLFormHelper {

	protected $owner;
	
	public function __construct($_owner) {
		$this->owner = $_owner;
	}
	
	public function displayAsWebForm() {
		
		echo '<form id="form" action="" method="post">'."\n";
			echo '<input type="text" class="input-text" name="first" id="first" value="'.$this->owner->first.'" />'."\n";
			echo '<input type="text" class="input-text" name="last" id="last" value="'.$this->owner->last.'" />'."\n";
			echo '<input type="text" class="input-text" name="phone" id="phone" value="'.$this->owner->phone.'" />'."\n";
			echo '<input type="text" class="input-text" name="email" id="email" value="'.$this->owner->email.'" />'."\n";
			echo '<input type="hidden" name="id" id="id" value="'.$this->owner->id.'" /> '."\n";
		echo '</form>';


	}

}


?>