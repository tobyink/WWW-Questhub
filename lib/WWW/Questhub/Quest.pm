use strict;
use warnings FATAL => "all";
use utf8;
use open qw(:std :utf8);

package WWW::Questhub::Quest;

use Moo;
use Types::Standard -types;
use WWW::Questhub::Util;

use constant { true => !!1, false => !!0 };

has id => (
    is       => "ro",
    reader   => "get_id",
    required => true,
    init_arg => "_id",
    isa      => Str,
);

has name => (
    is       => "ro",
    reader   => "get_name",
    required => true,
    isa      => Str,
);

has author => (
    is       => "ro",
    reader   => "get_author",
    required => true,
    isa      => Str,
);

has owners => (
    is       => "ro",
    reader   => "get_owners",
    required => true,
    init_arg => "team",
    isa      => ArrayRef[Str],
);

has tags => (
    is       => "ro",
    reader   => "get_tags",
    isa      => ArrayRef[Str],
    default  => sub { [] },
);

has status => (
    is       => "ro",
    reader   => "get_status",
    required => true,
    isa      => Enum[ WWW::Questhub::Util::__get_known_quest_states() ],
);

sub __new {
    my $class = shift;
    $class->new(@_)
}

sub print_info {
    my $self = shift;
    require WWW::Questhub::Format::Detailed;
    print "# WWW::Questhub::Quest all known info\n";
    print 'WWW::Questhub::Format::Detailed'->new->quest($self);
}

1;
