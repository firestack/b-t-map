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

			perSystem = { pkgs, ... }: {
				devshells.default = {
					packages = [
						pkgs.elixir
						pkgs.elixir-ls
					];
				};
			};
		};
}
