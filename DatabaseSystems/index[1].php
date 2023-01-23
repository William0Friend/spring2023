<!DOCTYPE html>
<html>
<head>
<title>Client Form</title>
</head>
<body>
<form id="Client Form" action="db_connection.php" method="post">
<h1>ESU Join the Flock</h1>
<p><span style="font-size: medium;"/>Social Entrepreneurial Club</p>
<img src="East_Stroudsburg_University_logo.png" alt="ESU.EDU" width="104" height="142">
<img src="BoaF_Logotype-2.jpg" alt="Birds of a Feather" width="200" height="142">

<p></p>

<p>
<strong>Name</strong>
<span style="padding-left: 13em;"/>
Credit Card Numbers
<span style="padding-left: 7em;"/>
CVS
<br/>
</p>

<p>
<input name="first" size="6" type="text" />
<span style="padding-left: 1em;"/>
<input name="last" size="13" type="text" />
<span style="padding-left: 2em;"/>
<input name="creditCard" size="24" type="text" />
<span style="padding-left: 3em;"/>
<input name="cvs" size="3" type="text" />
<br/>
<span style="font-size: medium;"/>
First
<span style="padding-left: 4em;"/>
Last
<br/>
<br/>
</p>

<p>
Email
<span style="color: red;"/>
*
<span style="padding-left: 16em;"/>
<span style="color: black;"/>
Password
<br />
<input name="email" size="30" type="text" />
<span style="padding-left: 4em;"/>
<input name="password" size="27" type="text" />
<br/>
<br/>
</p>

<p>
<strong>Phone Number (optional)</strong>
<br />
<input name="phone1" size="3" type="text" />
-
<input name="phone2" size="3" type="text" />
-
<input name="phone3" size="4" type="text" />
</p>

<p>
###
<span style="padding-left: 3em;"/>
###
<span style="padding-left: 3em;"/>
####
<br/><br/>
</p>

<p><strong>Choose the color(s) and size(s) of the pair of sock(s) you would like,<br/>
a matching pair(s) will be donated to a charity of your choice.<br/>
Please make checks payable to ESU and write socks donation in the check memo.</strong></p>

<p>
<span style="padding-left: 2em;"/>
<span style="font-size: x-small;"/>
ESU Colors - Medium - Men (6-8) Women (6-9) Donation ($20) Qty
<input name="qty1" size="2" type="text" />
</p>

<p>
<span style="padding-left: 2em;"/>
<span style="font-size: x-small;">
ESU Colors - Large - Men (9-13) Donation ($20)
<span style="padding-left: 7.5em;"/>
Qty
<input name="qty2" size="2" type="text" />
<span style="padding-left: .2em;"/>
</p>

<p>
<span style="padding-left: 2em;"/>
<span style="font-size: x-small;"/>
Neon Colors - Medium - Men (6-8) Women (6-9) Donation ($20) Qty
<input name="qty3" size="2" type="text" />
</p>

<p><span style="padding-left: 2em;"><span style="font-size: x-small;"> Neon Colors - Large - Men (9-13) Donation ($20)<span style="padding-left: 7.5em;"> Qty <input name="qty4" size="2" type="text" /><span style="padding-left: .2em;"></p>

<p>
    <?php
            $username = "root";
            $password = "";
            $hostname = "localhost";
            $dbname = "sock_database";
           
            $con = mysqli_connect($hostname, $username, $password, $dbname) or die("Connection Failed");
 
            $charityNames = mysqli_query($con,"SELECT charity_name FROM charity");
 
            $charityIDs = mysqli_query($con, "SELECT charity_id FROM charity");
            echo "<select name = \"esuMedChar\" form = \"Client Form\">";
            while ($row = mysqli_fetch_array($charityIDs)){
                $charityArr = mysqli_fetch_array($charityNames);
                echo "<option value = ".$row['charity_id'].">".$charityArr['charity_name']."</option>";
            }
            echo "</select>";
 
            $charityNames = mysqli_query($con,"SELECT charity_name FROM charity");
 
            $charityIDs = mysqli_query($con, "SELECT charity_id FROM charity");
            echo "<select name =\"esuLrgChar\" form = \"Client Form\">";
            while ($row = mysqli_fetch_array($charityIDs)){
                $charityArr = mysqli_fetch_array($charityNames);
                echo "<option value = ".$row['charity_id'].">".$charityArr['charity_name']."</option>";
            }
            echo "</select>";
 
            $charityNames = mysqli_query($con,"SELECT charity_name FROM charity");
 
            $charityIDs = mysqli_query($con, "SELECT charity_id FROM charity");
            echo "<select name =\"neonMedChar\" form = \"Client Form\">";
            while ($row = mysqli_fetch_array($charityIDs)){
                $charityArr = mysqli_fetch_array($charityNames);
                echo "<option value = ".$row['charity_id'].">".$charityArr['charity_name']."</option>";
            }
            echo "</select>";
 
            $charityNames = mysqli_query($con,"SELECT charity_name FROM charity");
 
            $charityIDs = mysqli_query($con,"SELECT charity_id FROM charity");
            echo "<select name =\"neonLrgChar\" form = \"Client Form\">";
            while ($row = mysqli_fetch_array($charityIDs)){
                $charityArr = mysqli_fetch_array($charityNames);
                echo "<option value = ".$row['charity_id'].">".$charityArr['charity_name']."</option>";
            }
            echo "</select>";
        ?>

</p>

<p><span style="padding-left: 2em;"><span style="font-size: x-small;"><strong> Pickup or Delievery</strong></span></span></p>

<p><span style="padding-left: 2em;"><input name="ESURadio" type="radio"/> <span style="font-size: x-small;"> I want to pickup my socks. Socks are available for pick up from the C.R.E.A.T.E Lab<br/> <span style="padding-left: 6em;">(Stroud Hall, Room 107) Tuesdays &amp; Wednesdays 1-4 p.m.</span></span></span></p>

<p><span style="padding-left: 2em;"><input name="ESURadio" type="radio"/> <span style="font-size: x-small;"> I want my socks delivered. Delivery available on campus only. Delivery Tuesdays <br /> <span style="padding-left: 6em;">between 1-4 p.m.</span></span></span></p>


<p><span style="padding-left: 2em;"> <span style="font-size: x-small;">Deliver My Socks (optional) </span></span></p>

<p><span style="padding-left: 2em;"><span style="font-size: x-small;"><strong> Building Name<span style="padding-left: 10em;"> Room#</span></strong></span></span></p>

<p>
<span style="padding-left: 2em;"/>
<input name="building" size="7" type="text" />
<span style="padding-left: 7em;"/>
<input name="room" size="4" type="text" />
<br/>
<hr width=550></hr>
</p>
  
<p><span style="padding-left: 2em;"> For Large Orders<br> <span style="font-size: x-small;"><span style="padding-left: 3em;"> Please contact the C.R.E.A.T.E. Lab at esucreatelab@gmail.com</span></span></br></p>
<span style="padding-left: 2em;"/> <input type="submit" name="submit" value="SUBMIT"/></p>

</form>
</body>
</html>