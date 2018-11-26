# this define exists for backwards compatiblity only
# as you can now call sshuserconfig::* directly without it
define sshuserconfig(
  $ssh_config_file,
  $ssh_config_dir = undef,
) { }
