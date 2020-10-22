# see https://docs.github.com/articles/generating-an-ssh-key/

ssh-keygen -t rsa -b 4096 -f $HOME/.ssh/id_rsa_github -y

echo 'Host github.com
  Hostname github.com
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/id_rsa_github
' > $HOME/.ssh/config

read -s -k '?Press enter to testing your SSH connection.'

ssh -T git@github.com

