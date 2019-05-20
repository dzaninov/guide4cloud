#!/usr/bin/perl

use MIME::Parser;
use Mail::GnuPG;

$mail_text = do { local $/; <STDIN> };

sub fail
{
    print STDERR @_;
    print $mail_text;
    exit 0;
}

# Get the GPG user for encryption

$gpg_identity = shift
    or fail ("Usage: $0 gpg_identity\n");

# Parse email

$mime_parser = new MIME::Parser();
$mime_parser->output_to_core (1);
$mime_parser->tmp_to_core (1);
$mime_parser->decode_bodies (0);
$mime_parser->ignore_errors (0);

$mime_entity = eval { $mime_parser->parse_data ($mail_text) };

if ($@ || $mime_parser->last_error) {
    fail ("Failed to parse MIME data\n");
}

$mail_header = $mime_entity->head();

print STDERR "From: ", $mail_header->get ('From', 0);
print STDERR "To: ", $mail_header->get ('To', 0);
print STDERR "Subject: ", $mail_header->get ('Subject', 0);

# These will fail to verify after encryption, remove them

foreach ('DKIM-Signature', 'DomainKey-Signature', 'X-Google-DKIM-Signature') {
    $mail_header->delete ($_);
}

# Encrypt email body

$mail_gnupg = new Mail::GnuPG();

if ($mail_gnupg->is_encrypted ($mime_entity)) {
    fail ("Email is already encrypted\n");
}

if ($mail_gnupg->mime_encrypt ($mime_entity, ($gpg_identity)) != 0) {
    fail (@{$mail_gnupg->{last_message}});
}

# Output encrypted email

print $mime_entity->stringify;
exit 0;
