<?php
$db='sock_database';
$user='root';
$pass='';
$con=mysqli_connect('localhost', $user, $pass,$db) or die("Unable to Connect");
if($con)
{
	echo 'Connected!<br>';
}
if(isset($_POST['submit']))
{
	//Credit Card Information
	$creditCard=$_POST['creditCard'];
	$cvs=$_POST['cvs'];
	$sql1=mysqli_query($con,"INSERT INTO creditcard(cc_num, cc_cvs) VALUES('$creditCard','$cvs');");
	if($sql1)
	{
		echo 'Credit Card Info Posted<br>';
	}
	else
	{
		echo 'not success<br>';
	}
	$sql=mysqli_query($con,"SET @cc_id = LAST_INSERT_ID();");
	if($sql)
	{
		echo 'CC_ID set<br>';
	}
	
	//Varibles for customer table
	$first=$_POST['first'];
	$last=$_POST['last'];
	$email=$_POST['email'];
	$phone1=$_POST['phone1'];
	$phone2=$_POST['phone2'];
	$phone3=$_POST['phone3'];
	$fullPhone=$phone1.''.$phone2.''.$phone3;
	$password=$_POST['password'];

	//Customer Information Table
	$sql=("INSERT INTO customer(cus_fname,cus_lname,cus_phone_num,cus_email,cus_pword) 
	VALUES('$first','$last','$fullPhone','$email','$password')");
	$query=mysqli_query($con,$sql);
	if($query)
	{
		echo 'Customer Info Posted<br>';
	}
	else
	{
		echo 'not success<br>';
	}
	$sql = mysqli_query($con,"SET @cus_id = LAST_INSERT_ID();");
	if($sql)
	{
		echo 'Cus_ID set<br>';
	}
	//Order Table
	$delivery=$_POST['ESURadio'];
	$building=$_POST['building'];
	$room=$_POST['room'];
	if($building && $room)
	{
		$sql=mysqli_query($con,"INSERT INTO ordersocks(cus_id,cc_id, ord_delivery_type,ord_building_name,ord_room_num) VALUES(@cus_id,@cc_id,
			'Delivery','$building','$room')");
		echo 'Order Scheduled for Delivery<br>';
	}
	else
	{
		$building="Stroud Hall";
		$room="107";
		$sql=mysqli_query($con,"INSERT INTO ordersocks(cus_id,cc_id,ord_delivery_type,ord_building_name,ord_room_num) VALUES(@cus_id,@cc_id,'Pick-Up', 
			'$building','$room')");
		echo 'Order Scheduled for Pick-Up<br>';
	}
	$sql=mysqli_query($con,"SET @ord_id = LAST_INSERT_ID();");
	if($sql)
	{
		echo 'Ord_ID set<br>';
	}
	//Charity Info inserted into Transasction Table
	$esuMed=$_POST['esuMedChar'];
	$esuLrg=$_POST['esuLrgChar'];
	$neonMed=$_POST['neonMedChar'];
	$neonLrg=$_POST['neonLrgChar'];

	if($_POST['qty1']>0)
	{
		$sock_id=1;
		$qty=$_POST['qty1'];
		$sql=mysqli_query($con, "INSERT INTO transactions(ord_id,sock_id,trans_quant,charity_id) VALUES(@ord_id,'$sock_id','$qty','$esuMed')");
		echo 'ESU Medium Socks Ordered<br>';
		echo "Charity: ".$esuMed." ";
		echo "Quantity Ordered: ".$qty."<br>";
	}

	if($_POST['qty2']>0)
	{
		$sock_id=2;
		$qty=$_POST['qty2'];
		$sql=mysqli_query($con,"INSERT INTO transactions(ord_id,sock_id,trans_quant,charity_id) VALUES(@ord_id,'$sock_id','$qty','$esuLrg')");
		echo 'ESU Large Socks Ordered<br>';
		echo "Charity: ".$esuLrg." ";
		echo "Quantity Ordered: ".$qty."<br>";
	}

	if($_POST['qty3']>0)
	{
		$sock_id=3;
		$qty=$_POST['qty3'];
		$sql=mysqli_query($con, "INSERT INTO transactions(ord_id,sock_id,trans_quant,charity_id) VALUES(@ord_id,'$sock_id','$qty','$neonMed')");
		echo 'Neon Medium Socks Ordered<br>';
		echo "Charity: ".$neonMed." ";
		echo "Quantity Ordered: ".$qty."<br>";
	}
	
	if($_POST['qty4']>0)
	{
		$sock_id=4;
		$qty=$_POST['qty4'];
		$sql=mysqli_query($con, "INSERT INTO transactions(ord_id,sock_id,trans_quant,charity_id) VALUES(@ord_id,'$sock_id','$qty','$neonLrg')");
		echo 'Neon Large Socks Ordered<br>';
		echo "Charity: ".$neonLrg." ";
		echo "Quantity Ordered: ".$qty."<br>";
	}
}
?>