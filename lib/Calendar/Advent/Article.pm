package Calendar::Advent::Article;
use Moose;

use autodie;
use Pod::Elemental;
use Pod::Elemental::Transformer::Pod5;
use Pod::Elemental::Transformer::PPIHTML;
use Pod::Xhtml;

has body  => (is => 'ro', isa => 'Str',      required => 1);
has title => (is => 'ro', isa => 'Str',      required => 1);
has date  => (is => 'ro', isa => 'DateTime', required => 1);

sub body_xhtml {
  my ($self) = @_;

  my $body = $self->body;

  my $document = Pod::Elemental->read_string($body);

  Pod::Elemental::Transformer::Pod5->new->transform_node($document);
  Pod::Elemental::Transformer::PPIHTML->new->transform_node($document);

  $body = $document->as_pod_string;

  open my $fh, '<', \$body;

  my $px = Pod::Xhtml->new(
    FragmentOnly => 1,
    MakeIndex    => 0,
    MakeMeta     => 0,
    StringMode   => 1,
    TopHeading   => 2,
    TopLinks     => 0,
  );
  $px->parse_from_filehandle($fh);

  my $string = $px->asString;

  return $string;
}

1;