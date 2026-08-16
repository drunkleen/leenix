# Host development policy control panel — every accepted catalog leaf is
# explicitly listed, alphabetically ordered, all false by default.
#
# DATA / POLICY ONLY: booleans. Package implementation and capability metadata
# live in modules/nixos/development/catalog.nix. profiles.development (the
# master gate) is owned by variables/profiles.nix.
# Only flip leaves to true after enabling profiles.development.
{
  development = {
    buildTools = {
      autoconf = false;
      automake = false;
      bazel = false;
      cmake = true;
      libtool = false;
      meson = true;
      ninja = false;
      pkg-config = false;
      premake = false;
      scons = false;
      xmake = false;
    };
    cloud = {
      ansible = false;
      awscli = false;
      azureCli = false;
      gcloud = false;
      helm = false;
      k9s = false;
      kubectl = false;
      opentofu = false;
      terraform = false;
    };
    compute = {
      cuda = false;
      opencl = false;
      rocm = false;
    };
    containers = {
      buildah = false;
      docker = false;
      k3d = false;
      kind = false;
      minikube = false;
      skopeo = false;
    };
    databases = {
      duckdb = false;
      mariadb = false;
      mongodb = false;
      postgresql = false;
      redis = false;
      sqlite = false;
    };
    debugging = {
      bpftrace = false;
      gdb = false;
      heaptrack = false;
      hotspot = false;
      lldb = false;
      perf = false;
      rr = false;
      strace = false;
      valgrind = false;
    };
    documentation = {
      doxygen = false;
      graphviz = false;
      mkdocs = false;
      pandoc = false;
      sphinx = false;
    };
    embedded = {
      avrdude = false;
      dfu-util = false;
      gccArmEmbedded = false;
      openocd = false;
      picocom = false;
      platformio = false;
    };
    fpga = {
      ghdl = false;
      gtkwave = false;
      iverilog = false;
      nextpnr = false;
      verilator = false;
      yosys = false;
    };
    graphics = {
      epoxy = false;
      glfw = false;
      glm = false;
      glslang = false;
      opengl = false;
      raylib = false;
      sdl2 = false;
      sdl3 = false;
      sfml = false;
      shaderc = false;
      spirv-tools = false;
      vulkan = false;
    };
    gui = {
      fltk = false;
      gtk3 = false;
      gtk4 = false;
      libadwaita = false;
      qt5 = false;
      qt6 = false;
      wxwidgets = false;
    };
    languages = {
      ada = false;
      c = true;
      clojure = false;
      cpp = false;
      crystal = false;
      csharp = false;
      d = false;
      dart = false;
      elixir = false;
      erlang = false;
      fortran = false;
      go = false;
      haskell = false;
      java = false;
      julia = false;
      kotlin = false;
      lua = true;
      nim = false;
      node = false;
      ocaml = false;
      odin = false;
      pascal = false;
      perl = false;
      php = false;
      python = true;
      r = false;
      racket = false;
      ruby = false;
      rust = true;
      scala = false;
      scheme = false;
      swift = false;
      typescript = false;
      v = false;
      zig = false;
    };
    libraries = {
      boost = false;
      eigen = false;
      ffmpeg = false;
      fmt = false;
      grpc = false;
      icu = false;
      libevent = false;
      libinput = false;
      libsodium = false;
      libusb = false;
      libuv = false;
      libxml2 = false;
      nlohmann_json = false;
      opencv = false;
      openssl = false;
      protobuf = false;
      spdlog = false;
      zeromq = false;
      zlib = false;
      zstd = false;
    };
    linters = {
      black = true;
      eslint = true;
      nixfmt = true;
      prettier = true;
      ruff = false;
      shellcheck = false;
      shfmt = false;
    };
    lsp = {
      gopls = true;
      lua-language-server = true;
      nil = false;
      nixd = false;
      pyright = true;
      rust-analyzer = true;
      typescript-language-server = false;
    };
    mobile = {
      adb = false;
      android = false;
      flutter = false;
    };
    packageManagers = {
      gradle = false;
      maven = false;
      opam = false;
      pipx = false;
      poetry = false;
      uv = false;
    };
    protocols = {
      grpcurl = false;
      mqtt = false;
      websocat = false;
    };
    reverseEngineering = {
      binutils = false;
      cutter = false;
      ghidra = false;
      pahole = false;
      radare2 = false;
    };
    scientific = {
      hdf5 = false;
      lapack = false;
      netcdf = false;
      openblas = false;
      openmpi = false;
    };
    testing = {
      k6 = false;
      playwright = false;
    };
    virtualization = {
      libvirt = true;
      qemu = false;
      vagrant = false;
      virt-manager = true;
    };
    web = {
      angular = false;
      astro = false;
      bun = false;
      deno = false;
      nextjs = false;
      nuxt = false;
      pnpm = false;
      react = false;
      remix = false;
      solid = false;
      svelte = false;
      tailwindcss = false;
      vite = false;
      vue = false;
      yarn = false;
    };
    webAssembly = {
      binaryen = false;
      emscripten = false;
      wabt = false;
      wasm-pack = false;
      wasmer = false;
      wasmtime = false;
    };
  };
}
