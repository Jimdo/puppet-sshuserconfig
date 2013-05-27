# Install/configure something here
class skeleton(
  $command = '/bin/true'
){
  # Replace this with meaningful resources
  exec { 'sample_command': command => $command }
}
