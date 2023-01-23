<?php
include ("../jpgraph.php");
include ("../jpgraph_pie.php");
include ("../jpgraph_pie3d.php");

if ($a1 < 1 && $a2 < 1 && $a3 < 1  && $a4 < 1)
{
$a1=1;
$a2=1;
$a3=1;
$a4=1;
}


// Some data
$data = array($a1,$a2,$a3,$a4);

// Create the Pie Graph.
$graph = new PieGraph(400,300,"auto");
$graph->SetShadow();

// Set A title for the plot
$graph->title->Set("Example 3 3D Pie plot");
$graph->title->SetFont(FF_ARIAL,FS_BOLD,18); 
$graph->title->SetColor("darkblue");
$graph->legend->Pos(0.1,0.3);

// Create 3D pie plot
$p1 = new PiePlot3d($data);
$p1->SetTheme("sand");
$p1->SetCenter(0.4);
$p1->SetSize(80);

// Adjust projection angle
$p1->SetAngle(45);

// As a shortcut you can easily explode one numbered slice with
$p1->ExplodeSlice(3);

// Setup the slice values
$p1->value->SetFont(FF_ARIAL,FS_BOLD,11);
$p1->value->SetColor("navy");

$p1->SetLegends(array("$a1","$a2","$a3","$a4"));

$graph->Add($p1);
$graph->Stroke();

?>


