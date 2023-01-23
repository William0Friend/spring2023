<?php
$db='sock_database';
$user='root';
$pass='';
$con=mysqli_connect('localhost', $user, $pass) or die("Unable to Connect");
mysqli_select_db($con,$db);
if($con)
{
	echo 'Connected!';
	echo '<br>';
}
	$newChar=$_POST['addNew'];
	$sql=mysqli_query($con,"INSERT INTO charity(charity_id,charity_name) VALUES('','$newChar')");
	if($sql)
	{
		echo 'SUCCESS! New Charity Added<br>';
	}

?>