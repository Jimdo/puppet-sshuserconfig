define sshuserconfig::remotehost(
  $unix_user,
  $remote_hostname,
  $remote_username,
  $private_key_content,
  $public_key_content,
  $remote_port = 22,
  $ssh_config_dir = undef
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

  concat::fragment { $fragment_name :
    target => $ssh_config_file,
    content => "Host ${title}
  HostName ${remote_hostname}
  Port ${remote_port}
  User ${remote_username}
  IdentityFile ${synthesized_privkey_path}\n\n"
  }

  file { $synthesized_privkey_path :
    ensure  => present,
    content => $private_key_content,
    owner   => $unix_user,
    mode    => 600
  }

  file { $synthesized_pubkey_path :
    ensure  => present,
    content => $public_key_content,
    owner   => $unix_user,
    mode    => 600
  }

}
