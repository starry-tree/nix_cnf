{pkgs,username, ...}: {
  imports = [
    ../../home/core.nix

    # ../../home/fcitx5
    # ../../home/i3
    ../../home/programs
    # ../../home/rofi
    ../../home/shell
  ];

  programs.git = {
    userName = "starry_tree";
    userEmail = "starry_tree@qq.com";
  };
}
