<?php
$db='sock_database';
$user='root';
$pass='';
$con=mysqli_connect('localhost', $user, $pass) or die("Unable to Connect");
mysqli_select_db($con,$db);
if($con)
{
	echo 'Connected!';
	echo '<br><br>';
}
//Total Socks Sold
if(isset($_GET['total']))
{
	$sql=mysqli_query($con,"SELECT charity_id,SUM(trans_quant) AS 'Total' FROM transactions GROUP BY charity_id WITH ROLLUP");
	if($sql)
	{
		echo 'SUCCESS!<br>Total Socks Sold Displayed<br>';
		while($row=mysqli_fetch_array($sql))
		{
			if($row['charity_id']==NULL)
			{
				echo 'Total: '.$row['Total'].'<br>';
			}
		}
	}
}
//Total Each Charity
if(isset($_GET['totalCharity']))
{
	$sql=mysqli_query($con,"SELECT charity_id,SUM(trans_quant) AS 'Total' FROM transactions GROUP BY charity_id");
	if($sql)
	{
		echo 'SUCCESS!<br>Total Socks Sold By Each Charity Displayed<br>';
		$sql1=mysqli_query($con,"SELECT charity_id,charity_name FROM Charity");
		while($row1=mysqli_fetch_array($sql1))
		{
			echo 'Charity ID: '.$row1['charity_id'].' ';
			echo "Charity Name: ".$row1['charity_name'].'<br>';
		}
		while($row=mysqli_fetch_array($sql))
		{
			echo 'Charity: '.$row['charity_id'].' ';
			echo 'Total: '.$row['Total'].'<br>';
		}
	}
}
//Large Sock Quantitiy
if(isset($_GET['esuLarge']))
{
	$sql=mysqli_query($con,"SELECT sock_id,SUM(trans_quant) AS 'LargeTotal' FROM transactions WHERE sock_id=2");
	if($sql)
	{
		echo 'SUCCESS! Number of ESU Large Socks Displayed<br>';

		while($row=mysqli_fetch_array($sql))
		{
			echo 'Total of ESU Large Socks Sold: '.$row['LargeTotal']."<br>";
		}
	}
	else
	{
		echo 'Could Not Pull Data<br>';
	}
}
//Gets User Information When Given Email
if(isset($_GET['UserInformation']))
{
	$email=$_GET['UserInformation'];
	$sql=mysqli_query($con,"SELECT * FROM customer WHERE cus_email='$email'");
	$query_executed=mysqli_fetch_assoc($sql);
		if($sql)
		{
			echo 'SUCCESS! Customer Info Displayed<br>';
			echo 'Name: '.$query_executed['cus_fname']." ";
			echo $query_executed['cus_lname']."<br>";
			echo 'Phone Number: '.$query_executed['cus_phone_num']."<br>";
			echo 'Email: '.$query_executed['cus_email']."<br>";
			echo 'Password: '.$query_executed['cus_pword']."<br>";
		}
		else
		echo 'not success<br>';
	$sql=mysqli_query($con,"SELECT cc_num FROM ordersocks 
		join creditcard
		on creditcard.cc_id = ordersocks.cc_id
		 WHERE cus_id=".$query_executed['cus_id']);
	$row=mysqli_fetch_array($sql);
		echo 'Credit Card Number: '.$row['cc_num']."<br>";
}
//Prints out socks for delivery
if(isset($_GET['socksDelivery']))
{
	$sql=mysqli_query($con,"SELECT ord_id,cus_id,ord_delivery_type,ord_building_name,ord_room_num FROM ordersocks WHERE ord_delivery_type='delivery'");
	if($sql)
	{
		echo 'SUCCESS! Delivery Data Displayed<br>';
		while($row=mysqli_fetch_array($sql))
		{
			echo "Order Id: ".$row['ord_id']."<br>";
			echo "Building Name: ".$row['ord_building_name']."<br>";
			echo "Room Number: ".$row['ord_room_num'].'<br>';
		}
	}
	else
	{
		echo 'Could Not Pull Data<br>';
	}
}

?>
