# Dotfiles

## Usages

```sh
curl -o- https://raw.githubusercontent.com/lawvs/dotfiles/master/init.sh | bash
```

or

```sh
sudo apt install -y git
git clone https://github.com/lawvs/dotfiles.git
cd dotfiles
sudo ./init.sh
./install.sh
```

Legacy: set and use Zsh as default shell

```sh
chsh -s $(which zsh)
```

## macOS with nix-darwin

This repository contains a nix-darwin setup under `nix/`.

See [nix/README.md](nix/README.md).

## References

- [frantic1048/Vanilla](https://github.com/frantic1048/Vanilla)
- [SukkaW/dotfiles](https://github.com/SukkaW/dotfiles)
- [powerline/fonts](https://github.com/powerline/fonts)
