<?php



Header("Content-type: image/png");


function drawlines($breite,$hoehe)
{



$image=imagecreate($breite,$hoehe);


ImageInterlace($image,1);

imagecolorset($image,1,0,0,0);

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


$col1_r['start']=rand(0,255);
$col1_r['end']=rand(0,255);
$col1_g['start']=rand(0,255);
$col1_g['end']=rand(0,255);
$col1_b['start']=rand(0,255);
$col1_b['end']=rand(0,255);
$col2_r['start']=rand(0,255);
$col2_r['end']=rand(0,255);
$col2_g['start']=rand(0,255);
$col2_g['end']=rand(0,255);
$col2_b['start']=rand(0,255);
$col2_b['end']=rand(0,255);

 


$myPi=3.14159265358979323846;



$steps=35;

 
for($i=0;$i<$steps;$i++){
$r1=(($col1_r['end']-$col1_r['start'])/$steps)*$i+$col1_r['start'];
$g1=(($col1_g['end']-$col1_g['start'])/$steps)*$i+$col1_g['start'];
$b1=(($col1_b['end']-$col1_b['start'])/$steps)*$i+$col1_b['start'];

$andere=imagecolorallocate($image,$r1,$g1,$b1);
$andere2=imagecolorallocate($image,$r1,$g1,$b1);
 
$sin1+=$add1;
$sin2+=$add2;
$sin3+=$add3;
$sin4+=$add4;


$x1=sin(deg2rad($sin1))*($breite/2)+($breite/2);
$x2=cos(deg2rad($sin2))*($breite/2)+($breite/2);
$y1=sin(deg2rad($sin3))*($hoehe/2)+($hoehe/2);
$y2=cos(deg2rad($sin4))*($hoehe/2)+($hoehe/2);

imageline($image,$x1,$y1,$x2,$y2,$andere);
imageline($image,$x1+1 ,$y1,$x2+1 ,$y2,$andere2);
 imagesetpixel($image,$x1,$y1,$andere);

}

return $image;


}
$bild=drawlines(165,170);

imagepng($bild);
imagedestroy($bild);

?>
        
