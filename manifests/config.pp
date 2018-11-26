#
#
#
define sshuserconfig::config (
  $user,
  $host,
  $ensure               = 'present',
  $options              = {},
  $ssh_config_dir       = undef,
  $order                = undef
) {

  if $ssh_config_dir == undef {
    $ssh_config_dir_prefix = "/home/${user}/.ssh"
  } else {
    $ssh_config_dir_prefix = $ssh_config_dir
  }

  $ssh_config_file = "${ssh_config_dir_prefix}/config"

  $concat_namespace = "ssh_userconfig_${user}"
  $fragment_name = "${concat_namespace}_${title}"

  ensure_resource(
    'concat',
    $ssh_config_file,
    {
      ensure => $ensure,
      owner  => $user,
      group  => $user,
      mode   => '0600'
    }
  )

  # preperation for default options to be set for all keys
  $default_options = {}
  $merged_options = merge($default_options, $options)

  concat::fragment { $fragment_name :
    target  => $ssh_config_file,
    content => template('sshuserconfig/fragment.erb'),
    order   => $order
  }
}
