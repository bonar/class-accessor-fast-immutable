
package Class::Accessor::Fast::Immutable;

use strict;
use warnings;

use Sub::Install;

our $VERSION = '0.01';

sub Class::Accessor::Fast::make_immutable {
    my $self = shift;
    foreach my $name (keys %$self) {
        Sub::Install::reinstall_sub({
            code => sub {
                return $self->{$name} if 1 == @_;
                $_[0]->_croak("this accessor [$name] is readonly.");
            },
            into => ref($self),
            as   => $name,
        });
    }
    return $self;
}

1;

__END__

=head1 NAME

Class::Accessor::Fast::Immutable - make C::A::F object immutable

=head1 SYNOPSIS

    package Your::Module;
    use base 'Class::Accessor::Fast';
    __PACKAGE__->mk_accessors(qw/
        foo
        bar
    /);
    1;

    package main;
    use Class::Accessor::Fast::Immutablize;

    my $x = Your::Module->new({ foo => 1 });
    $x->make_immutable();
    $x->foo(2); # croak!

=head1 DESCRIPTION

This module make your Class::Accessor::Fast object immutable 
after bless() by reinstalling readonly accessor. It is usefull 
in these case:

  sub new {
      my ($class, %arg) = @_;
      my $self = bless {}, $class;
  
      # call some method
      $self->build(\%arg);
  
      return $self;
  }

After bless(), you cannot modify accessors that is created by 
mk_ro_accessors. so you have to create accessors by mk_accessors,
but those accessors make your object mutable(rw).

This constructer returns immutable object with this code:

  return $self->make_immutable;

You can also make other object immutable:

  use Class::Accessor::Fast::Immutablize;
  use Foo::Bar; # Foo::Bar use base C::A::F
  my $foobar = Foo::Bar->new();
  $foobar->make_immutable;

This module create method "make_immutable" in namespace of 
Class::Accessor::Fast. 

=head1 NOTE

make_immutable() cannot make object immutable enough when the object 
containts other object or references. 

=head1 AUTHOR

Nakano Kyohei (bonar) <bonar@cpan.com>

=head1 SEE ALSO

L<Class::Accessor::Fast>

=cut

