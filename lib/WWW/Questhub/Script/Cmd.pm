use strict;
use warnings FATAL => 'all';
use utf8;
use open qw(:std :utf8);

package WWW::Questhub::Script::Cmd;

use Moo::Role;
use Getopt::Long qw();
use Module::Runtime qw(use_package_optimistically);

requires 'run';
requires 'option_spec';

has app             => (is => "rwp");
has formatter_class => (is => "rwp", builder => "_build_formatter_class");

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

    if (defined($opts->{format}) and $opts->{format} =~ /^\+(.+)$/) {
        $self->_set_formatter_class($1);
    }
    elsif (defined($opts->{format})) {
        $self->_set_formatter_class("WWW::Questhub::Format::" . $opts->{format});
    }

    $self->run($opts, $args);
}

sub get_formatter {
    my $self = shift;
    return use_package_optimistically($self->formatter_class)->new;
}

sub _build_formatter_class {
    "WWW::Questhub::Format::Compact";
}

1;
