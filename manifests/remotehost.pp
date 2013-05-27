define ssh-userconfig::remotehost(
  $unix_user,
  $remote_hostname,
  $remote_username,
  $private_key_content,
  $public_key_content,
  $remote_port = 22,
) {

  $ssh_config_dir_prefix ="/home/${unix_user}/.ssh" 
  $ssh_config_file = "${ssh_config_dir_prefix}/config"

  $concat_namespace = "ssh_userconfig_${unix_user}"
  $fragment_name = "${concat_namespace}_${title}"

  $synthesized_privkey_path = "${ssh_config_dir_prefix}/id_rsa_${title}"
  $synthesized_pubkey_path = "${ssh_config_dir_prefix}/id_rsa_${title}.pub"

  concat { $ssh_config_file :
    owner => $unix_user
  }
  
  concat::fragment { $fragment_name :
    target => $ssh_config_file,
    content => "Host ${title}
  HostName ${remote_hostname}
  Port ${remote_port}
  User ${remote_username}
  IdentityFile ${synthesized_privkey_path}"
  }

  file { $ssh_config_dir_prefix :
    ensure  => directory,
    owner   => $unix_user,
    mode    => 700
  }

  file { $synthesized_privkey_path :
    ensure  => present,
    content => $private_key_content,
    owner   => $unix_user,
    mode    => 600,
    require => File[$ssh_config_dir_prefix]
  }

  file { $synthesized_pubkey_path :
    ensure  => present,
    content => $public_key_content,
    owner   => $unix_user,
    mode    => 600,
    require => File[$ssh_config_dir_prefix]
  }

}