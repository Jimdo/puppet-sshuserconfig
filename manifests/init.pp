# this should not be called directly as it's included by the sshuserconfig::* defines
define sshuserconfig(
  $ssh_config_file
) {

  $unix_user = $title
  concat { $ssh_config_file :
    owner => $unix_user
  }
  Concat::Fragment <| target == $ssh_config_file |>
}
