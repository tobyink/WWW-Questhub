use strict;
use warnings FATAL => 'all';
use utf8;
use open qw(:std :utf8);

package WWW::Questhub::Script;

use Moo;
use MooX::Cmd;
use WWW::Questhub::Util;

use constant { true => !!1, false => !!0 };

has questhub => (
    is       => "lazy",
    builder  => "_build_questhub",
);

sub _build_questhub
{
    require WWW::Questhub;
    'WWW::Questhub'->new()
}

sub execute {
    my ($self, $args_ref, $chain_ref) = @_;
    return $self;
}

1;
