define sshuserconfig(
  $ssh_config_dir = undef
) {

  $unix_user = $title
  if $ssh_config_dir == undef {
    $ssh_config_dir_prefix = "/home/${unix_user}/.ssh"
  } else {
    $ssh_config_dir_prefix = $ssh_config_dir
  }
  $ssh_config_file = "${ssh_config_dir_prefix}/config"

  concat { $ssh_config_file :
    owner => $unix_user
  }

}
