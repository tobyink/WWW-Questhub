use strict;
use warnings FATAL => 'all';
use utf8;
use open qw(:std :utf8);

package WWW::Questhub::Script;

use Moo;
use MooX::Cmd;
use WWW::Questhub;
use WWW::Questhub::Util;

use constant { true => !!1, false => !!0 };

sub execute {
    my ($self, $args_ref, $chain_ref) = @_;
    return $self;
}

1;
