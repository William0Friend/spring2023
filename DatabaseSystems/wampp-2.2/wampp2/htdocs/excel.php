<?php
  include_once "Spreadsheet/Excel/Writer.php";

  $xls =& new Spreadsheet_Excel_Writer();
  $xls->send("test.xls");
  $sheet =& $xls->addWorksheet('Test results');
  $sheet->write(0,0,12);
  $sheet->write(0,1,"Hallo, ich bin ein Text");
  $format =& $xls->addFormat();
  $format->setBold();
  $format->setColor("green");
  $sheet->write(1,1,"Hallo, ich bin formatiert",$format);
  $xls->close();
?>  

