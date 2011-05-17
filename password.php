<?php
	function new_password()
	{
			#reset password - make up a password to send them.
			$dict_length = split('/\s/',`wc -l /usr/share/dict/words`);
			$length = $dict_length[0];
			settype($length, "integer");
			$word = '';
			while($word == '' or strlen($word) <= 3 or strlen($word) > 10)
			{
				print "here\n";
				$line = rand(1,$length);
				$cmd = "sed -n '$line"."p' /usr/share/dict/words";
				$word = `$cmd`;
				$word = preg_replace("/'.*/","",$word);
				$word = preg_replace("/.*\..*/","",$word);
				$word = preg_replace("/.*,.*/","",$word);
				$word = preg_replace("/.*\-.*/","",$word);
			}
			$number = rand(1,99);
			$len = strlen($word);
			$pass = ":$word:$len"."$number";
			$pass = preg_replace("/\s/","",$pass);
			$new_password = md5($pass);	
			
			print "Your new password is $pass.";
	}
	
	new_password();
?> 
