<?php
   $dbhost = 'localhost';
   $dbuser = 'itzikc_switch';
   $dbpass = '981462';
   
   $conn = mysql_connect($dbhost, $dbuser, $dbpass);
   
   if(! $conn ) {
      die('Could not connect: ' . mysql_error());
   }
   
   $sql = 'SELECT * FROM  `switch`';
   mysql_select_db('itzikc_switch');
   $retval = mysql_query( $sql, $conn );
   
   if(! $retval ) {
      die('Could not get data: ' . mysql_error());
   }
   
   while($row = mysql_fetch_array($retval, MYSQL_ASSOC)) 
   {
      $ip = $row['home_ip'];
   }
   echo '<html><center><iframe src="'.$ip.'" width="800" height	= "500" frameborder="0"></iframe></center></html>';

   mysql_close($conn);
?>