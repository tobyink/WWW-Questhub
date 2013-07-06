use strict;
use warnings FATAL => 'all';
use utf8;
use open qw(:std :utf8);

package WWW::Questhub;

use Carp;
use LWP::UserAgent;
use JSON;
use Moo;
use URI;
use Types::Standard -types;
use WWW::Questhub::Quest;

my $true = 1;
my $false = '';

has agent => (
    is       => "lazy",
    reader   => "__get_agent",
    builder  => "_build_agent",
    init_arg => undef,
    isa      => Str,
);

sub _build_agent {
    my $class = ref($_[0]) || $_[0];
    my $version_text = '';
    eval {
        $version_text = " " . $class->VERSION;
    };
    $class . $version_text;
}

has server => (
    is       => "ro",
    reader   => "__get_server",
    isa      => Str,
    default  => 'http://questhub.io'
);

has ua => (
    is       => "lazy",
    isa      => HasMethods[qw/request/],
    builder  => "_build_ua",
);

sub _build_ua {
    my $self =  shift;
    'LWP::UserAgent'->new( agent => $self->__get_agent );
}

sub get {
    my ($self, $url) = @_;

    my $req = HTTP::Request->new(
        GET => $url,
    );

    my $res = $self->ua->request($req);

    return $res->content if $res->is_success;
}

sub get_quests {
    my ($self, %opts) = @_;

    my $option_user = delete $opts{user};
    my $option_status = delete $opts{status};

    my @unknown_options = keys %opts;
    if (@unknown_options) {
        croak "get_quests() got unknown option: '"
            . join("', '", @unknown_options)
            . "'. Stopped";
    }

    my $url = URI->new($self->__get_server());
    $url->path('/api/quest');
    $url->query_form(
        ( defined $option_user ? ( user => $option_user ) : () ),
        ( defined $option_status ? ( status => $option_status ) : () ),
    );

    my $json = $self->get( $url->as_string() );
    my $data = from_json($json, { utf8 => 1 });

    my @quests;
    foreach my $element (@{$data}) {
        my $quest = WWW::Questhub::Quest->__new(%{$element});
        push @quests, $quest;
    }

    return @quests;
}

1;
