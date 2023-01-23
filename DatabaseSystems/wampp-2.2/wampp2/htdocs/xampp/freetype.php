<?
Header("Content-type: image/png");
$image = imagecreate(100,20);
$farbe_body=imagecolorallocate($image,0x2c,0x6D,0xAF);
$font_c = imagecolorallocate($image,255,255,255);
Imagettftext($image, 12, 0, 6, 16, $font_c, "../fonts/comic.ttf", "$text");
Imagepng($image);
ImageDestroy($image);
?>