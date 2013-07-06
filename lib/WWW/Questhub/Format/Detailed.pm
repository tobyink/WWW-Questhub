use strict;
use warnings FATAL => 'all';
use utf8;
use open qw(:std :utf8);

package WWW::Questhub::Format::Detailed;

use Moo; with 'WWW::Questhub::Format';
use Term::ANSIColor qw(colored);

sub quest {
    my ($self, $quest) = @_;
    my $output;

    $output .= "id:        " . colored($quest->get_id(), 'yellow') . "\n";
    $output .= "name:      " . colored($quest->get_name(), 'blue') . "\n";
    $output .= "status:    " . colored($quest->get_status(), 'blue') . "\n";
    $output .= "author:    " . $quest->get_author() . "\n";

    my @owners = @{ $quest->get_owners() };

    if (@owners) {
        $output .= "owners:\n";
        foreach (@owners) {
            $output .= " * $_\n";
        }
        $output .= "\n";
    } else {
        $output .= "owners:    " . colored('none', 'blue') . "\n";
    }

    my @tags = @{ $quest->get_tags() };

    if (@tags) {
        $output .= "tags:\n";
        foreach (@tags) {
            $output .= " * " . colored($_, 'magenta') . "\n";
        }
        print "\n";
    } else {
        $output .= "tags:      " . colored('none', 'blue') . "\n";
    }

    $output .= "\n";

    return $output;
}

1;
