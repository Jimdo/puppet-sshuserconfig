define ssh-userconfig() {

  $unix_user = $title
  $ssh_config_dir_prefix ="/home/${unix_user}/.ssh"
  $ssh_config_file = "${ssh_config_dir_prefix}/config"

  concat { $ssh_config_file :
    owner => $unix_user
  }

}