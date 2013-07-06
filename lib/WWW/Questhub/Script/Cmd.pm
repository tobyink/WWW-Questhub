use strict;
use warnings FATAL => 'all';
use utf8;
use open qw(:std :utf8);

package WWW::Questhub::Script::Cmd;

use Moo::Role;
use Getopt::Long qw();

requires 'run';
requires 'option_spec';

has app => (is => "rwp");

sub execute {
    my ($self, $args_ref, $chain_ref) = @_;
    $self->_set_app( $chain_ref->[0] );

    my $opts = {};
    my $args = [@$args_ref];
    Getopt::Long::GetOptionsFromArray(
        $args,
        $opts,
        map { ref($_) ? $_->[0] : $_ } @{$self->option_spec},
    );

    $self->run($opts, $args);
}

1;
