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
				inherit (pkgs.beam.packages.erlang_24)
					erlang
					elixir_1_14
					elixir-ls
					fetchMixDeps;
				elixir = elixir_1_14;
			in {
				packages.mixDeps = fetchMixDeps {
					pname = "mix-deps-btm";
					src = ./btm;
					version = "0.0.1";
					sha256 = "sha256-1rkO0Wl8lIWyB735As/qSTmdkzI991p6G01mA7Nt2yY=";
				};
				packages.mixDevDeps = fetchMixDeps {
					pname = "dev-mix-deps-btm";
					mixEnv="";
					src = ./btm;
					version = "0.0.1";
					sha256 = "sha256-RiHHMV3os4gh/suuatcJoxBMErbEuTDPHTT4t9rAscU=";
				};
				packages.default = pkgs.mixRelease {};

				packages.gtfs = self'.packages.mbta-gtfs;
				# packages.gtfs = self'.packages.nyc-manhattan-gtfs;
				packages.mbta-gtfs = pkgs.fetchzip {
					url = "https://cdn.mbta.com/MBTA_GTFS.zip";
					stripRoot = false;
					hash = "sha256-mJhAs/Nim0wse9d07vyhcjW/VKL+6He3cmq45ukUUXM=";
				};

				packages.denver-rtd-gtfs = pkgs.fetchzip {
					url = "https://www.rtd-denver.com/files/gtfs/google_transit.zip";
					stripRoot = false;
					hash = "sha256-QJjQ4vQp+5JEQe358QTLFUt48uxitz1aJ5yVWzW4kYs=";
				};

				packages.nyc-bronx-gtfs = pkgs.fetchzip {
					url = "http://web.mta.info/developers/data/nyct/bus/google_transit_bronx.zip";
					stripRoot = false;
					hash = "sha256-J1CCWf8hZ+uf7gXm9ku1AKQwSiDcWsuqakfBL0g+4ls=";
				};

				packages.nyc-manhattan-gtfs = pkgs.fetchzip {
					url = "http://web.mta.info/developers/data/nyct/bus/google_transit_manhattan.zip";
					stripRoot = false;
					hash = "sha256-d8R59u5rcrHwDROiCB6V9Dwv6CSGAmp9EKJGaWf5HlM=";
				};

				devshells.default = {
					devshell.startup.link-deps.text = lib.concatStringsSep "\n" [
						"ln ${if (pkgs.hostPlatform.isDarwin) then "-fns" else "-fsT"} ${self'.packages.mixDevDeps} \${PRJ_ROOT:-}/btm/deps"
					];
					devshell.startup.link-gtfs.text = lib.concatStringsSep "\n" [
						"ln ${if (pkgs.hostPlatform.isDarwin) then "-fns" else "-fsT"} ${self'.packages.gtfs} \${PRJ_ROOT:-}/btm/priv/transient/gtfs"
					];
					# devshell.interactive.link-deps.text = lib.concatStringsSep "\n" [
					# 	"echo hi"
					# 	"ln -s ${self'.packages.mixDeps} \${PRJ_ROOT:-}/btm/deps"
					# ];
					packages = [
						elixir
						elixir-ls
						pkgs.fswatch
					] ++ lib.optionals pkgs.stdenv.isLinux [pkgs.inotify-tools];
				};
			};
		};
}
