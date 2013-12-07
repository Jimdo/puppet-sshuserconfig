define sshuserconfig(
  $unix_user = $title,
  $ssh_config_dir = undef
) {

  if $ssh_config_dir == undef {
    $ssh_config_dir_prefix = "/home/${unix_user}/.ssh"
  } else {
    $ssh_config_dir_prefix = $ssh_config_dir
  }
  $ssh_config_file = "${ssh_config_dir_prefix}/config"

  file { $ssh_config_dir :
    ensure => 'directory',
    owner => $unix_user,
    mode => 755
  }

  concat { $ssh_config_file :
    owner => $unix_user
  }

}
