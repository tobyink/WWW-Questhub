use strict;
use warnings FATAL => 'all';
use utf8;
use open qw(:std :utf8);

package WWW::Questhub::Format::Compact;

use Moo; with 'WWW::Questhub::Format';
use Term::ANSIColor qw(colored);

sub quest {
    my ($self, $quest) = @_;
    
    my $tags = '';
    foreach my $tag (@{ $quest->get_tags() }) {
        $tags .= colored($tag, 'magenta') . ", ";
    }
    $tags = substr($tags, 0, length($tags) - 2);
    $tags .= " " if length($tags) > 0;

    return colored($quest->get_id(), 'yellow')
        . " "
        . colored($quest->get_status(), 'blue')
        . " "
        . $tags
        . $quest->get_name()
        . "\n"
        ;
}

1;
