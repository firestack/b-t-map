{
	description = "virtual environments";

	inputs.devshell.url = "github:numtide/devshell";
	inputs.devshell.inputs.nixpkgs.follows = "/nixpkgs";

	inputs.flake-parts.url = "github:hercules-ci/flake-parts";
	inputs.flake-parts.inputs.nixpkgs-lib.follows = "/nixpkgs";

	outputs = inputs@{ self, flake-parts, devshell, nixpkgs }:
		flake-parts.lib.mkFlake { inherit inputs; } {
			imports = [
				devshell.flakeModule
			];

			systems = [
				"aarch64-darwin"
				"aarch64-linux"
				"i686-linux"
				"x86_64-darwin"
				"x86_64-linux"
			];

			perSystem = { pkgs, lib, self', ... }: let
				inherit (pkgs.beam.packages.erlang_26) erlang elixir_1_15 elixir-ls fetchMixDeps;
				elixir = elixir_1_15;
			in {
				packages.mixDeps = fetchMixDeps {
					pname = "mix-deps-btm";
					src = ./btm;
					version = "0.0.1";
					sha256 = "sha256-1rkO0Wl8lIWyB735As/qSTmdkzI991p6G01mA7Nt2yY=";
				};
				packages.mixDevDeps = fetchMixDeps {
					pname = "dev-mix-deps-btm";
					mixEnv="dev";
					src = ./btm;
					version = "0.0.1";
					sha256 = "sha256-9cxvP5b2TdxPbu8dW8Tu+xD38p04+6I0ux88re4mzj0=";
				};
				devshells.default = {
					# devshell.startup.link-deps.text = lib.concatStringsSep "\n" [
					# 	"ln -fsT ${self'.packages.mixDevDeps} \${PRJ_ROOT:-}/btm/deps"
					# ];
					packages = [
						erlang
						elixir
						elixir-ls
						# pkgs.inotify-tools
					] ++ lib.optionals pkgs.stdenv.isLinux [pkgs.inotify-tools];
				};
			};
		};
}
