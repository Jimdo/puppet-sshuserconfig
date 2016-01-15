#
#
#
define sshuserconfig::key (
  $user,
  $ensure                 = 'present',
  $key_name               = undef,
  $private_key_source     = undef,
  $private_key_content    = undef,
  $public_key_source      = undef,
  $public_key_content     = undef,
  $ssh_config_dir         = undef,
) {

  if $ssh_config_dir == undef {
    $ssh_config_dir_prefix = "/home/${user}/.ssh"
  } else {
    $ssh_config_dir_prefix = $ssh_config_dir
  }

  $ssh_config_file = "${ssh_config_dir_prefix}/config"

  if ($key_name != undef) {
    $synthesized_privkey_path = "${ssh_config_dir_prefix}/${key_name}"
    $synthesized_pubkey_path = "${ssh_config_dir_prefix}/${key_name}.pub"
  } else {
    $synthesized_privkey_path = "${ssh_config_dir_prefix}/id_rsa_${title}"
    $synthesized_pubkey_path = "${ssh_config_dir_prefix}/id_rsa_${title}.pub"
  }

  # private key
  if ($private_key_source != undef and $private_key_content != undef) {
    fail ("[${name}] private key source and content may not both be set")
  } elsif ($private_key_source == undef and $private_key_content == undef) {
    $private_ensure = 'absent'
  } else {
    $private_ensure = $ensure
  }

  file { "privateKey_${name}" :
    ensure  => $private_ensure,
    path    => $synthesized_privkey_path,
    content => $private_key_content,
    source  => $private_key_source,
    owner   => $user,
    group   => $user,
    mode    => '0600',
  }

  # public key
  if ($public_key_source != undef and $public_key_content != undef) {
    fail ("[${name}] public key source and content may not both be set")
  } elsif ($public_key_source == undef and $public_key_content == undef) {
    $public_ensure = 'absent'
  } else {
    $public_ensure = $ensure
  }

  file { "publicKey_${name}" :
    ensure  => $public_ensure,
    path    => $synthesized_pubkey_path,
    content => $public_key_content,
    source  => $public_key_source,
    owner   => $user,
    group   => $user,
    mode    => '0600',
  }
}
