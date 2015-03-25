class base(
  $common_packages = ['tmux', 'curl', 'wget', 'rsync', 'unzip', 'htop'],
  $update_packages = {}
){
   ensure_packages($common_packages)
   create_resources('Package', $update_packages, {'ensure' => 'latest'})
}
