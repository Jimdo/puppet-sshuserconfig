#
#
#
define sshuserconfig::remotehost(
  $unix_user,
  $remote_hostname,
  $remote_username,
  $private_key_content,
  $public_key_content,
  $ensure              = 'present',
  $remote_port         = 22,
  $ssh_config_dir      = undef,
  $connect_timeout     = undef,
) {

  if $ssh_config_dir == undef {
    $ssh_config_dir_prefix = "/home/${unix_user}/.ssh"
  } else {
    $ssh_config_dir_prefix = $ssh_config_dir
  }

  $ssh_config_file = "${ssh_config_dir_prefix}/config"

  $concat_namespace = "ssh_userconfig_${unix_user}"
  $fragment_name = "${concat_namespace}_${title}"

  $synthesized_privkey_path = "${ssh_config_dir_prefix}/id_rsa_${title}"
  $synthesized_pubkey_path = "${ssh_config_dir_prefix}/id_rsa_${title}.pub"

  $config_options = {
    'ConnectTimeout' => $connect_timeout,
    'Port'           => $remote_port,
    'User'           => $remote_username,
    'HostName'       => $remote_hostname,
    'IdentityFile'   => $synthesized_privkey_path,
  }

  sshuserconfig::config { $name:
    ensure         => $ensure,
    user           => $unix_user,
    host           => $title,
    options        => $config_options,
    ssh_config_dir => $ssh_config_dir,
  }
  sshuserconfig::key { $name:
    ensure              => $ensure,
    user                => $unix_user,
    key_name            => "id_rsa_${title}",
    private_key_content => $private_key_content,
    public_key_content  => $public_key_content,
    ssh_config_dir      => $ssh_config_dir,
  }
}
