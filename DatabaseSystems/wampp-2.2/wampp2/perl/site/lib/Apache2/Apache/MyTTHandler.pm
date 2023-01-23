package Apache::MyTTHandler;
use strict;
use Template;
use Apache::Const -compile => ':common';
sub handler {
  my $r = shift;
  my $config = {
                INCLUDE_PATH => 'C:/Apache2/tt2',
		INTERPOLATE => 1,
		POST_CHOMP => 1,
		EVAL_PERL => 1,
	       };
  my $template = Template->new($config) or do {
    $r->warn(Template->error());
    return Apache::SERVER_ERROR;
  };
  
  my $vars = { var => \%ENV };
  my $input = 'printenv.html';
  $template->process($input, $vars, $r) or do {
    $r->log_reason($template->error());
    return Apache::SERVER_ERROR;
  };
  return Apache::OK;
}

1;
