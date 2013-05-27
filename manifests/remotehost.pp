define ssh-userconfig::remotehost(
  $unixuser,
  $remote_hostname,
  $remote_username,
  $remote_port = 22
) {

  $ssh_config_dir_prefix ="/home/${unixuser}/.ssh" 
  $ssh_config_file = "/home/${unixuser}/.ssh/config"
  $fragment_name = "ssh_userconfig_${unixuser}_${title}"
  $synthesized_privkey_path = "${ssh_config_dir_prefix}/id_rsa_${title}"
  
  concat::fragment { $fragment_name :
    target => $ssh_config_file,
    content => "Host ${title}
  HostName ${remote_hostname}
  Port ${remote_port}
  User ${remote_username}
  IdentityFile ${synthesized_privkey_path}"
  }

}
