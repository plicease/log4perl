package Log::Dispatch::Buffer;

##################################################
# Log dispatcher writing to a string buffer
# For testing.
##################################################

use Log::Dispatch::Output;
use base qw( Log::Dispatch::Output );
use fields qw( stderr );

    # This is a dirty trick for testing: Keep track
    # of the entire object population. So we'll 
    # be able to access the buffers even if the
    # objects are created behind our back -- as
    # long as we remember the order in which
    # they've been created:
    # $Log::Dispatch::Buffer::POPULATION[0] is
    # the first one etc.
    # The DESTROY method below cleans up afterwards.

our @POPULATION = ();

##################################################
sub new {
##################################################
    my $proto = shift;
    my $class = ref $proto || $proto;
    my %params = @_;

    my $self = bless {}, $class;

    $self->_basic_init(%params);
    $self->{stderr} = exists $params{stderr} ? $params{stderr} : 1;
    $self->{buffer} = "";

    push @POPULATION, $self;

    return $self;
}

##################################################
sub log_message {   
##################################################
    my $self = shift;
    my %params = @_;

    $self->{buffer} .= $params{message};
}

##################################################
sub buffer {   
##################################################
    my($self, $new) = @_;

    if(defined $new) {
        $self->{buffer} = $new;
    }

    return $self->{buffer};
}

##################################################
sub reset {   
##################################################
    my($self) = @_;

    $self->{buffer} = "";
}

##################################################
sub DESTROY {   
##################################################
    my($self) = @_;

    return unless defined $self;

    @POPULATION = grep { defined $_ && $_ != $self } @POPULATION;
}

1;
