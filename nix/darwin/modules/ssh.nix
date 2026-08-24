{ username, ... }:
{
  services.openssh = {
    enable = true;
    extraConfig = ''
      PubkeyAuthentication yes
      PasswordAuthentication no
      KbdInteractiveAuthentication no
      AuthenticationMethods publickey
      PermitRootLogin no
      AllowUsers ${username}
    '';
  };
}
