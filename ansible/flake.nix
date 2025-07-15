{
  description = "Ansible ENV";

  # Flake inputs
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  # Flake outputs
  outputs = { self, nixpkgs }:
    let
      # The systems supported for this flake
      supportedSystems = [
        "x86_64-linux" # 64-bit Intel/AMD Linux
        "aarch64-linux" # 64-bit ARM Linux
        "x86_64-darwin" # 64-bit Intel macOS
        "aarch64-darwin" # 64-bit ARM macOS
      ];

      # Helper to provide system-specific attributes
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          # The Nix packages provided in the environment
          # Add any you need here
          packages = with pkgs; [
            cowsay
            ansible
            ansible-lint
            awscli2
            python3Packages.dnspython
            python3Packages.molecule
            python3Packages.molecule-plugins
            python3Packages.ansible-builder
            python3Packages.ansible-runner
            sshpass
          ];

          # Set any environment variables for your dev shell
          # env = {
          #   OBJC_DISABLE_INITIALIZE_FORK_SAFETY="YES"; # https://github.com/ansible/ansible/issues/76322
          # };

          # Add any shell logic you want executed any time the environment is activated
          shellHook = ''
          '';
        };
      });
    };
}
