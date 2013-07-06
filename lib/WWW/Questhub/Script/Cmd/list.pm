use strict;
use warnings FATAL => 'all';
use utf8;
use open qw(:std :utf8);

package WWW::Questhub::Script::Cmd::list;

use Carp;
use Moo; with 'WWW::Questhub::Script::Cmd';
use MooX::Cmd;
use Term::ANSIColor qw(colored);
use Types::Standard -types;

use constant { true => !!1, false => !!0 };

sub option_spec {
    return [
        [ "owner=s"   => "the quest's owner" ],
        [ "status=s"  => "the quest status (open/completed/abandoned)" ],
        [ "tags=s"    => "quest tags prefixed by + or -" ],
    ];
}

sub run {
    my ($self, $opts, $args) = @_;

    my $option_user       = $opts->{owner};
    my $option_status     = $opts->{status};
    my @option_with_tags;
    my @option_without_tags;

    if ($opts->{tags}) {
        my @tags = split /(?=[\+-])/, $opts->{tags};
        foreach my $tag (@tags) {
            if ($tag =~ /^\+(.+)$/) {
                push @option_with_tags, $1;
            } elsif ($tag =~ /^\-(.+)/) {
                push @option_without_tags, $1;
            } else {
                croak "Error. Incorrect tag '$tag'\n";
                exit 1;
            }
        }
    }

    my $wq = WWW::Questhub->new();

    my @quests = $wq->get_quests(
        ( defined $option_user ? ( user => $option_user ) : () ),
        ( defined $option_status ? ( status => $option_status ) : () ),
    );

    my $filtered_quests = $self->_filter_quests_by_tags(\@quests, \@option_with_tags, \@option_without_tags);

    foreach my $quest (@$filtered_quests) {

        my $tags = '';
        foreach my $tag (@{ $quest->get_tags() }) {
            $tags .= colored($tag, 'magenta') . ", ";
        }
        $tags = substr($tags, 0, length($tags) - 2);
        $tags .= " " if length($tags) > 0;

        print colored($quest->get_id(), 'yellow')
            . " "
            . colored($quest->get_status(), 'blue')
            . " "
            . $tags
            . $quest->get_name()
            . "\n"
            ;
    }
}

sub _filter_quests_by_tags {
    my $self                = shift;
    my @quests              = @{$_[0]};
    my @option_with_tags    = @{$_[1]};
    my @option_without_tags = @{$_[2]};
    
    my @filtered_quests;
    
    if (@option_with_tags == 0 and @option_without_tags == 0) {
        @filtered_quests = @quests;
    } else {
        foreach my $quest (@quests) {

            my $quest_has_plus_tag = false;
            CHECK_HAS_PLUS_TAG:
            foreach my $tag (@{ $quest->get_tags() }) {
                my $tmp = WWW::Questhub::Util::__in_array($tag, @option_with_tags);
                if ($tmp) {
                    $quest_has_plus_tag = true;
                    last CHECK_HAS_PLUS_TAG;
                }
            }

            my $quest_has_minus_tag = false;
            CHECK_HAS_MINUS_TAG:
            foreach my $tag (@{ $quest->get_tags() }) {
                my $tmp = WWW::Questhub::Util::__in_array($tag, @option_without_tags);
                if ($tmp) {
                    $quest_has_minus_tag = true;
                    last CHECK_HAS_MINUS_TAG;
                }
            }

            if (@option_with_tags != 0 and @option_without_tags == 0) {
                if ($quest_has_plus_tag) {
                    push @filtered_quests, $quest;
                }
            } elsif (@option_with_tags == 0 and @option_without_tags != 0) {
                if (not $quest_has_minus_tag) {
                    push @filtered_quests, $quest;
                }
            } else {
                if ($quest_has_plus_tag and not $quest_has_minus_tag) {
                    push @filtered_quests, $quest;
                }
            }
        }
    }
    
    return \@filtered_quests;
}

1;
