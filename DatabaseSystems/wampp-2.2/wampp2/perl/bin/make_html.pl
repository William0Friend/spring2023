use Pod::Master;
my $pm = Pod::Master->new( {verbose => 1} );
$pm->UpdatePOD();
$pm->UpdateTOC(0);

