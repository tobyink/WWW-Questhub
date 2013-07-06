use strict;
use warnings FATAL => "all";
use utf8;
use open qw(:std :utf8);

package WWW::Questhub::Quest;

use Moo;
use Term::ANSIColor qw(colored);
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

    print "# WWW::Questhub::Quest all known info\n";
    print "id:        " . colored($self->get_id(), 'yellow') . "\n";
    print "name:      " . colored($self->get_name(), 'blue') . "\n";
    print "status:    " . colored($self->get_status(), 'blue') . "\n";
    print "author:    " . $self->get_author() . "\n";

    my @owners = @{ $self->get_owners() };

    if (@owners) {
        print "owners:\n";
        foreach (@owners) {
            print " * $_\n";
        }
        print "\n";
    } else {
        print "owners:    " . colored('none', 'blue') . "\n";
    }

    my @tags = @{ $self->get_tags() };

    if (@tags) {
        print "tags:\n";
        foreach (@tags) {
            print " * " . colored($_, 'magenta') . "\n";
        }
        print "\n";
    } else {
        print "tags:      " . colored('none', 'blue') . "\n";
    }

    print "\n";

    return false;
}

1;
