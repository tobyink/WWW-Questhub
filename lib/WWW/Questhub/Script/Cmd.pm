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
requires 'abstract';

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
        'help',
        map { ref($_) ? $_->[0] : $_ } @{$self->option_spec},
    );

    if ($opts->{help}) {
        $self->help;
        exit(0);
    }

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

sub command_name {
    my $self = shift;
    ref($self) =~ /(\w+)$/ and return $1;
    die "could not determine command name!!";
}

sub help {
    my $self = shift;
    my $cmd  = $self->command_name;
    print "Usage: $0 $cmd [options] [arguments]\n\n";
    print $self->abstract, "\n\n";
    print "Options:\n";
    for my $opt (@{ $self->option_spec })
    {
        my ($name, $desc) = ref($opt) ? @$opt : ($opt, 'no description available for this option');
        my ($realname, $param) = split /=/, $name;
        my @names = split /\|/, $realname;
        
        my $names = join ", ", map {
            length($_)==1 && defined($param)  ?  "-$_ $param" :
            length($_)==1                     ?  "-$_" :
            defined($param)                   ?  "--$_=$param" :
                                                 "--$_"
        } @names;
        
        printf("   %-30s  %s\n", $names, $desc);
    }
    print "\n";
}

1;
