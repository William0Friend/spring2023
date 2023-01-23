<?php



//Header("Content-type: image/png");


function drawlines($x,$y,$breite,$hoehe,$steps,$richtung)
{

global $image;


$weiss=imagecolorallocate($image,0,0,0);
$schwarz=imagecolorallocate($image,0,0,0);
$andere=imagecolorallocate($image,255,0,255);
$andere2=imagecolorallocate($image,255,110,255);




srand ((double) microtime() * 1000000);
$randval = rand();
      
$sin1=rand(0,360);
$sin2=rand(0,360);
$sin3=rand(0,360);
$sin4=rand(0,360);
$add1=rand(1,12);
$add2=rand(1,12);
$add3=rand(1,12);
$add4=rand(1,12);


$col1_r['start']=rand(0,55);
$col1_r['end']=rand(0,255);
$col1_g['start']=rand(0,55);
$col1_g['end']=rand(0,255);
$col1_b['start']=rand(0,55);
$col1_b['end']=rand(0,200);
 


$myPi=3.14159265358979323846;



//$steps=115;
$speed=1;


//$x=rand(0,$breite);
//$y=rand(0,$hoehe);
//$richtung=rand(0,360);
 
for($i=0;$i<$steps;$i++){

$richtung+=rand(0,40)-20;

$r1=(($col1_r['end']-$col1_r['start'])/$steps)*$i+$col1_r['start'];
$g1=(($col1_g['end']-$col1_g['start'])/$steps)*$i+$col1_g['start'];
$b1=(($col1_b['end']-$col1_b['start'])/$steps)*$i+$col1_b['start'];
$andere=imagecolorallocate($image,$r1,$g1,$b1);

 $newx=$x+(sin(deg2rad($richtung))-cos(deg2rad($richtung)))*$speed;
 $newy=$y+(cos(deg2rad($richtung))+sin(deg2rad($richtung)))*$speed;
 
 
 
 if ($newx<0){ 
 $newx=$newx+$breite;
 $x=$newx;
 }elseif($newx>$breite){
 $newx=$newx-$breite;$x=$newx;}

 if ($newy<0){
 $newy=$newy+$hoehe;
$y=$newy;
 }elseif($newy>$hoehe){
 
 $newy=$newy-$hoehe;
$y=$newy;
 }
 
 if(rand(0,70)==5){
drawlines($newx,$newy,$breite,$hoehe,$steps/2,$richtung);

 }
 
 
imageline($image,$x,$y,$newx,$newy,$andere);
// imagesetpixel($image,$newx,$newy,$andere);

$x=$newx;
$y=$newy;
} 

//imagerectangle($image,0,0,$breite,$hoehe,$andere);
 
}
 
$breite=100;
$hoehe=100;
$image=imagecreate($breite,$hoehe);


ImageInterlace($image,1);

imagecolorset($image,1,0,0,0);
drawlines(rand(0,$breite),rand(0,$hoehe),$breite,$hoehe,100,rand(0,360)) ;
drawlines(rand(0,$breite),rand(0,$hoehe),$breite,$hoehe,30,rand(0,360)) ;
 

 

imagepng($image);
imagedestroy($bild);

?>
        
