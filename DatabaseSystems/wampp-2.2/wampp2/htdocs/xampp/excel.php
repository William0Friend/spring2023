<?php
  include_once "Spreadsheet/Excel/Writer.php";

  $xls =& new Spreadsheet_Excel_Writer();
  $xls->send("test.xls");
  $sheet =& $xls->addWorksheet('Test XLS');
  $sheet->write(0,0,1);
  $sheet->write(0,1,"Test in XAMPP");
  $format =& $xls->addFormat();
  $format->setBold();
  $format->setColor("blue");
  $sheet->write(1,0,2);
  $sheet->write(1,1,$value,$format);
  $xls->close();
?>  

