{
  nixpkgs,
  customPkgs,
  nixCats,
  neovim-nightly-overlay,
  nvim-treesitter-main,
}:
let
  inherit (nixCats) utils;
  luaPath = ./.;
  forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
  # the following extra_pkg_config contains any values
  # which you want to pass to the config set of nixpkgs
  # import nixpkgs { config = extra_pkg_config; inherit system; }
  # will not apply to module imports
  # as that will have your system values
  extra_pkg_config = {
    allowUnfree = true;
  };
  # management of the system variable is one of the harder parts of using flakes.

  # so I have done it here in an interesting way to keep it out of the way.
  # It gets resolved within the builder itself, and then passed to your
  # categoryDefinitions and packageDefinitions.

  # this allows you to use ${pkgs.stdenv.hostPlatform.system} whenever you want in those sections
  # without fear.

  dependencyOverlays = # (import ./overlays inputs) ++
    [
      # This overlay grabs all the inputs named in the format
      # `plugins-<pluginName>`
      # Once we add this overlay to our nixpkgs, we are able to
      # use `pkgs.neovimPlugins`, which is a set of our plugins.
      # (utils.standardPluginOverlay inputs)
      # add any other flake overlays here.

      # when other people mess up their overlays by wrapping them with system,
      # you may instead call this function on their overlay.
      # it will check if it has the system in the set, and if so return the desired overlay
      # (utils.fixSystemizedOverlay inputs.codeium.overlays
      #   (system: inputs.codeium.overlays.${system}.default)
      # )
      nvim-treesitter-main.overlays.default
    ];

  # see :help nixCats.flake.outputs.categories
  # and
  # :help nixCats.flake.outputs.categoryDefinitions.scheme
  categoryDefinitions =
    {
      pkgs,
      settings,
      categories,
      extra,
      name,
      mkPlugin,
      ...
    }@packageDef:
    {
      # to define and use a new category, simply add a new list to a set here,
      # and later, you will include categoryname = true; in the set you
      # provide when you build the package using this builder function.
      # see :help nixCats.flake.outputs.packageDefinitions for info on that section.

      # lspsAndRuntimeDeps:
      # this section is for dependencies that should be available
      # at RUN TIME for plugins. Will be available to PATH within neovim terminal
      # this includes LSPs
      lspsAndRuntimeDeps = with pkgs; {
        general = [
          universal-ctags
          curl
          # NOTE:
          # lazygit
          # Apparently lazygit when launched via snacks cant create its own config file
          # but we can add one from nix!
          (pkgs.writeShellScriptBin "lazygit" ''
            exec ${pkgs.lazygit}/bin/lazygit --use-config-file ${pkgs.writeText "lazygit_config.yml" ""} "$@"
          '')
          ripgrep
          fd
          stdenv.cc.cc
          lua-language-server
          nil # I would go for nixd but lazy chooses this one idk
          stylua
          xclip
          gcc
          rustup
          gnumake
          tree-sitter
          github-copilot-cli
          imagemagick
          # lldb
          # vscode-js-debug
          # python312Packages.debugpy
        ]
        ++ [
          customPkgs.${pkgs.stdenv.hostPlatform.system}.tidal-language-server
        ];
      };

      # NOTE: lazy doesnt care if these are in startupPlugins or optionalPlugins
      # also you dont have to download everything via nix if you dont want.
      # but you have the option, and that is demonstrated here.
      startupPlugins = with pkgs.vimPlugins; {
        general = [
          blink-copilot
          friendly-snippets
          github-nvim-theme
          LazyVim
          nvim-lspconfig
          nvim-navic
          nvim-treesitter.withAllGrammars
          nvim-treesitter-textobjects
          nvim-ts-autotag
          nvim-ts-context-commentstring
          rustaceanvim
          treesj
          vim-illuminate
          vim-startuptime
          {
            plugin = blink-cmp;
            name = "blink.cmp";
          }
          {
            plugin = copilot-lua;
            name = "copilot.lua";
          }
          {
            plugin = crates-nvim;
            name = "crates.nvim";
          }
          {
            plugin = dial-nvim;
            name = "dial.nvim";
          }
          {
            plugin = flash-nvim;
            name = "flash.nvim";
          }
          {
            plugin = gitsigns-nvim;
            name = "gitsigns.nvim";
          }
          {
            plugin = grug-far-nvim;
            name = "grug-far.nvim";
          }
          {
            plugin = harpoon2;
            name = "harpoon";
          }
          {
            plugin = inc-rename-nvim;
            name = "inc-rename.nvim";
          }
          {
            plugin = indent-blankline-nvim;
            name = "indent-blankline.nvim";
          }
          {
            plugin = kulala-nvim;
            name = "kulala.nvim";
          }
          {
            plugin = lazydev-nvim;
            name = "lazydev.nvim";
          }
          {
            plugin = lazy-lsp-nvim;
            name = "lazy-lsp.nvim";
          }
          {
            plugin = lazy-nvim;
            name = "lazy.nvim";
          }
          {
            plugin = lualine-nvim;
            name = "lualine.nvim";
          }
          {
            plugin = mini-ai;
            name = "mini.ai";
          }
          {
            plugin = mini-comment;
            name = "mini.comment";
          }
          {
            plugin = mini-hipatterns;
            name = "mini.hipatterns";
          }
          {
            plugin = mini-icons;
            name = "mini.icons";
          }
          {
            plugin = mini-move;
            name = "mini.move";
          }
          {
            plugin = mini-pairs;
            name = "mini.pairs";
          }
          {
            plugin = mini-surround;
            name = "mini.surround";
          }
          {
            plugin = noice-nvim;
            name = "noice.nvim";
          }
          {
            plugin = nui-nvim;
            name = "nui.nvim";
          }
          {
            plugin = obsidian-nvim;
            name = "obsidian.nvim";
          }
          {
            plugin = octo-nvim;
            name = "octo.nvim";
          }
          {
            plugin = oil-nvim;
            name = "oil.nvim";
          }
          {
            plugin = overseer-nvim;
            name = "overseer.nvim";
          }
          {
            plugin = persistence-nvim;
            name = "persistence.nvim";
          }
          {
            plugin = plenary-nvim;
            name = "plenary.nvim";
          }
          {
            plugin = refactoring-nvim;
            name = "refactoring.nvim";
          }
          {
            plugin = render-markdown-nvim;
            name = "render-markdown.nvim";
          }
          {
            plugin = smear-cursor-nvim;
            name = "smear-cursor.nvim";
          }
          {
            plugin = snacks-nvim;
            name = "snacks.nvim";
          }
          {
            plugin = substitute-nvim;
            name = "substitute.nvim";
          }
          {
            plugin = todo-comments-nvim;
            name = "todo-comments.nvim";
          }
          {
            plugin = trouble-nvim;
            name = "trouble.nvim";
          }
          {
            plugin = ts-comments-nvim;
            name = "ts-comments.nvim";
          }
          {
            plugin = which-key-nvim;
            name = "which-key.nvim";
          }
          {
            plugin = yanky-nvim;
            name = "yanky.nvim";
          }
        ];
      };

      # not loaded automatically at startup.
      # use with packadd and an autocommand in config to achieve lazy loading
      # NOTE: this template is using lazy.nvim so, which list you put them in is irrelevant.
      # startupPlugins or optionalPlugins, it doesnt matter, lazy.nvim does the loading.
      # I just put them all in startupPlugins. I could have put them all in here instead.
      optionalPlugins = { };

      # shared libraries to be added to LD_LIBRARY_PATH
      # variable available to nvim runtime
      sharedLibraries = {
        general = with pkgs; [
          # libgit2
        ];
      };

      # environmentVariables:
      # this section is for environmentVariables that should be available
      # at RUN TIME for plugins. Will be available to path within neovim terminal
      environmentVariables = {
        test = {
          CATTESTVAR = "It worked!";
        };
      };

      # If you know what these are, you can provide custom ones by category here.
      # If you dont, check this link out:
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
      extraWrapperArgs = {
        general = [
          ''--run 'mkdir -p "''${HOME}/.config/nvim"' ''
        ];
      };

      # lists of the functions you would have passed to
      # python.withPackages or lua.withPackages

      # get the path to this python environment
      # in your lua config via
      # vim.g.python3_host_prog
      # or run from nvim terminal via :!<packagename>-python3
      python3.libraries = {
        test = [ (_: [ ]) ];
      };
      # populates $LUA_PATH and $LUA_CPATH
      extraLuaPackages = {
        test = [ (_: [ ]) ];
      };
    };

  # And then build a package with specific categories from above here:
  # All categories you wish to include must be marked true,
  # but false may be omitted.
  # This entire set is also passed to nixCats for querying within the lua.

  # see :help nixCats.flake.outputs.packageDefinitions
  packageDefinitions = {
    # These are the names of your packages
    # you can include as many as you wish.
    nvim =
      {
        pkgs,
        name,
        mkPlugin,
        ...
      }:
      {
        # they contain a settings set defined above
        # see :help nixCats.flake.outputs.settings
        settings = {
          suffix-path = true;
          suffix-LD = true;
          wrapRc = true;
          # IMPORTANT:
          # your alias may not conflict with your other packages.
          # aliases = [ "vim" ];
          neovim-unwrapped = neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.neovim;
          hosts.python3.enable = true;
          hosts.node.enable = true;
        };
        # and a set of categories that you want
        # (and other information to pass to lua)
        categories = {
          general = true;
          test = false;
        };
        extra = { };
      };
    # an extra test package with normal lua reload for fast edits
    # nix doesnt provide the config in this package, allowing you free reign to edit it.
    # then you can swap back to the normal pure package when done.
    testnvim =
      { pkgs, mkPlugin, ... }:
      {
        settings = {
          suffix-path = true;
          suffix-LD = true;
          wrapRc = false;
          unwrappedCfgPath = utils.mkLuaInline "os.getenv('HOME') .. '/.config/nvim'";
          neovim-unwrapped = neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.neovim;
        };
        categories = {
          general = true;
          test = false;
        };
        extra = { };
      };
  };
  # In this section, the main thing you will need to do is change the default package name
  # to the name of the packageDefinitions entry you wish to use as the default.
  defaultPackageName = "nvim";
in

# see :help nixCats.flake.outputs.exports
forEachSystem (
  system:
  let
    # the builder function that makes it all work
    nixCatsBuilder = utils.baseBuilder luaPath {
      inherit
        nixpkgs
        system
        dependencyOverlays
        extra_pkg_config
        ;
    } categoryDefinitions packageDefinitions;
    defaultPackage = nixCatsBuilder defaultPackageName;
    # this is just for using utils such as pkgs.mkShell
    # The one used to build neovim is resolved inside the builder
    # and is passed to our categoryDefinitions and packageDefinitions
    pkgs = import nixpkgs { inherit system; };
  in
  {
    # these outputs will be wrapped with ${system} by utils.eachSystem

    # this will make a package out of each of the packageDefinitions defined above
    # and set the default package to the one passed in here.
    packages = utils.mkAllWithDefault defaultPackage;

    # choose your package for devShell
    # and add whatever else you want in it.
    devShells = {
      default = pkgs.mkShell {
        name = defaultPackageName;
        packages = [ defaultPackage ];
        inputsFrom = [ ];
        shellHook = "";
      };
    };

  }
)
// (
  let
    # we also export a nixos module to allow reconfiguration from configuration.nix
    nixosModule = utils.mkNixosModules {
      moduleNamespace = [ defaultPackageName ];
      inherit
        defaultPackageName
        dependencyOverlays
        luaPath
        categoryDefinitions
        packageDefinitions
        extra_pkg_config
        nixpkgs
        ;
    };
    # and the same for home manager
    homeModule = utils.mkHomeModules {
      moduleNamespace = [ defaultPackageName ];
      inherit
        defaultPackageName
        dependencyOverlays
        luaPath
        categoryDefinitions
        packageDefinitions
        extra_pkg_config
        nixpkgs
        ;
    };
  in
  {

    # these outputs will be NOT wrapped with ${system}

    # this will make an overlay out of each of the packageDefinitions defined above
    # and set the default overlay to the one named here.
    overlays = utils.makeOverlays luaPath {
      inherit nixpkgs dependencyOverlays extra_pkg_config;
    } categoryDefinitions packageDefinitions defaultPackageName;

    nixosModules.default = nixosModule;
    homeModules.default = homeModule;

    inherit utils nixosModule homeModule;
    inherit (utils) templates;
  }
)
