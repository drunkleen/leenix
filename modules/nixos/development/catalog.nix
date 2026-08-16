# LEENIX canonical development capability registry.
#
# Single source of truth for the declarative development catalog. Everything
# else in modules/nixos/development/ is DERIVED from this file:
#   - options.nix     generates leenix.development.<category>.<leaf>.enable
#   - assertions.nix  profile-gate / unfree / platform assertions
#   - checks.nix      frozen-count + consistency checks
#   - default.nix     package composition (imported by profiles/development.nix)
#
# Leaf metadata:
#   description      human-readable capability description
#   kind             technical kind (toolchain/sdk/cli/build-system/debugger/
#                    library/gui-framework/code-quality/language-server/
#                    package-manager/database-client/re-tool/numerical-lib/
#                    test-tool/project-support/...)
#   classification   "A" = global Nix-owned package(s)
#                    "E" = project-support (non-empty support implementation)
#   packages         (A leaves) pkgs: -> [ pkg ... ]; Nix-owned implementation
#   support          (E leaves) { runtime = [ "nodejs" "pnpm" ];
#                                 scaffold = { command; argsBeforeName; argsAfterName; }; }
#   platforms        [ "x86_64-linux" "aarch64-linux" ]
#   guarded          package selection uses pkgs.X or null + availableOn
#   unfree           requires nixpkgs.config.allowUnfree (never silently enabled)
#   heavy            large / slow / memory-heavy toolchain (informational)
{
  buildTools = {
    autoconf   = { description = "Autoconf"; kind = "build-system"; classification = "A"; packages = pkgs: [ pkgs.autoconf ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    automake   = { description = "Automake"; kind = "build-system"; classification = "A"; packages = pkgs: [ pkgs.automake ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    bazel      = { description = "Bazel build system"; kind = "build-system"; classification = "A"; packages = pkgs: [ pkgs.bazel ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; };
    cmake      = { description = "CMake build system"; kind = "build-system"; classification = "A"; packages = pkgs: [ pkgs.cmake ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    libtool    = { description = "GNU Libtool"; kind = "build-system"; classification = "A"; packages = pkgs: [ pkgs.libtool ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    meson      = { description = "Meson build system"; kind = "build-system"; classification = "A"; packages = pkgs: [ pkgs.meson ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    ninja      = { description = "Ninja build system"; kind = "build-system"; classification = "A"; packages = pkgs: [ pkgs.ninja ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    pkg-config = { description = "pkg-config"; kind = "build-system"; classification = "A"; packages = pkgs: [ pkgs.pkg-config ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    premake    = { description = "Premake"; kind = "build-system"; classification = "A"; packages = pkgs: [ pkgs.premake ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    scons      = { description = "SCons"; kind = "build-system"; classification = "A"; packages = pkgs: [ pkgs.scons ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    xmake      = { description = "xmake"; kind = "build-system"; classification = "A"; packages = pkgs: [ pkgs.xmake ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
  };
  cloud = {
    ansible   = { description = "Ansible"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.ansible ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    awscli    = { description = "AWS CLI"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.awscli ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    azureCli  = { description = "Azure CLI"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.azure-cli ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; };
    gcloud    = { description = "Google Cloud CLI"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.google-cloud-sdk ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; };
    helm      = { description = "Kubernetes Helm"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.kubernetes-helm ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    k9s       = { description = "k9s"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.k9s ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    kubectl   = { description = "kubectl"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.kubectl ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    opentofu  = { description = "OpenTofu"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.opentofu ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    terraform = { description = "Terraform"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.terraform ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = true; heavy = false; };
  };
  compute = {
    cuda   = { description = "NVIDIA CUDA dev toolchain"; kind = "sdk"; classification = "A"; packages = pkgs: [ pkgs.cudaPackages.cuda_cudart pkgs.cudaPackages.cuda_nvcc ]; platforms = [ "x86_64-linux" ]; guarded = true; unfree = true; heavy = true; };
    opencl = { description = "OpenCL development (loader + headers + info)"; kind = "sdk"; classification = "A"; packages = pkgs: [ pkgs.ocl-icd pkgs.opencl-headers pkgs.clinfo ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    rocm   = { description = "ROCm/HIP dev toolchain"; kind = "sdk"; classification = "A"; packages = pkgs: [ pkgs.rocmPackages.rocminfo pkgs.rocmPackages.rocm-runtime ]; platforms = [ "x86_64-linux" ]; guarded = true; unfree = false; heavy = true; };
  };
  containers = {
    buildah  = { description = "Buildah"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.buildah ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    docker   = { description = "Docker CLI/tooling (never enables the daemon)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.docker ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    k3d      = { description = "k3d"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.k3d ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    kind     = { description = "kind"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.kind ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    minikube = { description = "minikube"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.minikube ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; };
    skopeo   = { description = "Skopeo"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.skopeo ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
  };
  databases = {
    duckdb     = { description = "DuckDB"; kind = "database-client"; classification = "A"; packages = pkgs: [ pkgs.duckdb ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    mariadb    = { description = "MariaDB/MySQL client/dev (package bundles server binaries; no service is enabled)"; kind = "database-client"; classification = "A"; packages = pkgs: [ pkgs.mariadb ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    mongodb    = { description = "MongoDB client/dev (package bundles server; no service is enabled)"; kind = "database-client"; classification = "A"; packages = pkgs: [ pkgs.mongodb ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = true; heavy = false; };
    postgresql = { description = "PostgreSQL client/dev (no service is enabled)"; kind = "database-client"; classification = "A"; packages = pkgs: [ pkgs.postgresql ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    redis      = { description = "Redis client/dev (package bundles server; no service is enabled)"; kind = "database-client"; classification = "A"; packages = pkgs: [ pkgs.redis ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    sqlite     = { description = "SQLite dev (CLI + library + headers)"; kind = "database-client"; classification = "A"; packages = pkgs: [ pkgs.sqlite ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
  };
  debugging = {
    bpftrace  = { description = "bpftrace"; kind = "debugger"; classification = "A"; packages = pkgs: [ pkgs.bpftrace ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    gdb       = { description = "GDB"; kind = "debugger"; classification = "A"; packages = pkgs: [ pkgs.gdb ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    heaptrack = { description = "heaptrack"; kind = "debugger"; classification = "A"; packages = pkgs: [ pkgs.heaptrack ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    hotspot   = { description = "Hotspot"; kind = "debugger"; classification = "A"; packages = pkgs: [ pkgs.hotspot ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    lldb      = { description = "LLDB"; kind = "debugger"; classification = "A"; packages = pkgs: [ pkgs.lldb ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    perf      = { description = "perf"; kind = "debugger"; classification = "A"; packages = pkgs: [ pkgs.linuxPackages.perf ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    rr        = { description = "rr"; kind = "debugger"; classification = "A"; packages = pkgs: [ pkgs.rr ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    strace    = { description = "strace"; kind = "debugger"; classification = "A"; packages = pkgs: [ pkgs.strace ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    valgrind  = { description = "Valgrind"; kind = "debugger"; classification = "A"; packages = pkgs: [ pkgs.valgrind ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
  };
  documentation = {
    doxygen  = { description = "Doxygen"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.doxygen ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    graphviz = { description = "Graphviz"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.graphviz ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    mkdocs   = { description = "MkDocs"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.mkdocs ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    pandoc   = { description = "Pandoc"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.pandoc ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    sphinx   = { description = "Sphinx"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.sphinx ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
  };
  embedded = {
    avrdude        = { description = "AVRDUDE (AVR flashing)"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.avrdude ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    dfu-util       = { description = "dfu-util"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.dfu-util ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    gccArmEmbedded = { description = "GCC ARM Embedded toolchain"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.gcc-arm-embedded ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    openocd        = { description = "OpenOCD"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.openocd ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    picocom        = { description = "picocom (serial dev tool)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.picocom ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    platformio     = { description = "PlatformIO"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.platformio ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; };
  };
  fpga = {
    ghdl      = { description = "GHDL"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.ghdl ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    gtkwave   = { description = "GTKWave"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.gtkwave ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    iverilog  = { description = "Icarus Verilog"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.iverilog ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    nextpnr   = { description = "nextpnr"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.nextpnr ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    verilator = { description = "Verilator"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.verilator ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    yosys     = { description = "Yosys"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.yosys ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
  };
  graphics = {
    epoxy       = { description = "libepoxy"; kind = "library"; classification = "A"; packages = pkgs: [ pkgs.libepoxy ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    glfw        = { description = "GLFW (OpenGL windowing; GL headers as implementation dependency)"; kind = "library"; classification = "A"; packages = pkgs: [ pkgs.glfw pkgs.libGL ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    glm         = { description = "GLM"; kind = "library"; classification = "A"; packages = pkgs: [ pkgs.glm ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    glslang     = { description = "glslang (shader compiler)"; kind = "library"; classification = "A"; packages = pkgs: [ pkgs.glslang ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    opengl      = { description = "OpenGL/EGL/GLES dev environment (libglvnd)"; kind = "library"; classification = "A"; packages = pkgs: [ pkgs.libGL ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    raylib      = { description = "Raylib"; kind = "library"; classification = "A"; packages = pkgs: [ pkgs.raylib ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    sdl2        = { description = "SDL2 (sdl2-compat on SDL3)"; kind = "library"; classification = "A"; packages = pkgs: [ pkgs.SDL2 ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    sdl3        = { description = "SDL3 (current generation)"; kind = "library"; classification = "A"; packages = pkgs: [ pkgs.sdl3 ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    sfml        = { description = "SFML"; kind = "library"; classification = "A"; packages = pkgs: [ pkgs.sfml ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    shaderc     = { description = "shaderc (glslc)"; kind = "library"; classification = "A"; packages = pkgs: [ pkgs.shaderc ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    spirv-tools = { description = "SPIR-V Tools"; kind = "library"; classification = "A"; packages = pkgs: [ pkgs.spirv-tools ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    vulkan      = { description = "Vulkan development (headers/loader/validation layers/tools + shader compilers)"; kind = "sdk"; classification = "A"; packages = pkgs: [ pkgs.vulkan-headers pkgs.vulkan-loader pkgs.vulkan-validation-layers pkgs.vulkan-tools pkgs.glslang pkgs.shaderc ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
  };
  gui = {
    fltk       = { description = "FLTK"; kind = "gui-framework"; classification = "A"; packages = pkgs: [ pkgs.fltk ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    gtk3       = { description = "GTK3"; kind = "gui-framework"; classification = "A"; packages = pkgs: [ pkgs.gtk3 ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    gtk4       = { description = "GTK4"; kind = "gui-framework"; classification = "A"; packages = pkgs: [ pkgs.gtk4 ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    libadwaita = { description = "libadwaita"; kind = "gui-framework"; classification = "A"; packages = pkgs: [ pkgs.libadwaita ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    qt5        = { description = "Qt5"; kind = "gui-framework"; classification = "A"; packages = pkgs: [ pkgs.qt5.qtbase ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    qt6        = { description = "Qt6"; kind = "gui-framework"; classification = "A"; packages = pkgs: [ pkgs.qt6.qtbase ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    wxwidgets  = { description = "wxWidgets"; kind = "gui-framework"; classification = "A"; packages = pkgs: [ pkgs.wxGTK32 ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
  };
  languages = {
    ada        = { description = "Ada (GNAT)"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.gnat ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    c          = { description = "C (clang + lld)"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.clang pkgs.lld ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    clojure    = { description = "Clojure"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.clojure ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    cpp        = { description = "C++ (clang + clang-tools + lld)"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.clang pkgs.clang-tools pkgs.lld ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    crystal    = { description = "Crystal"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.crystal ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    csharp     = { description = "C# / F# (.NET SDK)"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.dotnet-sdk ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; };
    d          = { description = "D (LDC)"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.ldc ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    dart       = { description = "Dart"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.dart ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    elixir     = { description = "Elixir (Erlang via dependency)"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.elixir ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    erlang     = { description = "Erlang/OTP"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.erlang ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    fortran    = { description = "Fortran (gfortran)"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.gfortran ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    go         = { description = "Go"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.go ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    haskell    = { description = "Haskell (GHC + cabal-install)"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.ghc pkgs.cabal-install ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    java       = { description = "Java (JDK)"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.jdk ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    julia      = { description = "Julia"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.julia ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; };
    kotlin     = { description = "Kotlin (compiler + JDK dependency)"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.kotlin pkgs.jdk ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    lua        = { description = "Lua 5.4"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.lua5_4 ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    nim        = { description = "Nim"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.nim ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    node       = { description = "Node.js (npm included)"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.nodejs ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    ocaml      = { description = "OCaml (compiler + dune)"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.ocaml pkgs.dune ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    odin       = { description = "Odin"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.odin ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    pascal     = { description = "Free Pascal"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.fpc ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    perl       = { description = "Perl"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.perl ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    php        = { description = "PHP (with composer dependency)"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.php pkgs.phpPackages.composer ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    python     = { description = "Python 3 (with pip)"; kind = "toolchain"; classification = "A"; packages = pkgs: [ (pkgs.python3.withPackages (ps: [ ps.pip ])) ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    r          = { description = "R"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.R ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    racket     = { description = "Racket"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.racket ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    ruby       = { description = "Ruby (with bundler)"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.ruby pkgs.bundler ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    rust       = { description = "Rust (rustc + cargo)"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.rustc pkgs.cargo ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    scala      = { description = "Scala (compiler + JDK dependency)"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.scala pkgs.jdk ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    scheme     = { description = "Scheme (Chez)"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.chez ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    swift      = { description = "Swift"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.swift ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = true; unfree = false; heavy = true; };
    typescript = { description = "TypeScript (with Node.js dependency)"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.typescript pkgs.nodejs ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    v          = { description = "V"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.vlang ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    zig        = { description = "Zig"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.zig ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
  };
  libraries = {
    boost         = { description = "Boost"; kind = "library"; classification = "A"; packages = pkgs: [ pkgs.boost ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    eigen         = { description = "Eigen"; kind = "library"; classification = "A"; packages = pkgs: [ pkgs.eigen ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    ffmpeg        = { description = "FFmpeg dev libraries"; kind = "library"; classification = "A"; packages = pkgs: [ pkgs.ffmpeg ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    fmt           = { description = "fmt"; kind = "library"; classification = "A"; packages = pkgs: [ pkgs.fmt ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    grpc          = { description = "gRPC"; kind = "library"; classification = "A"; packages = pkgs: [ pkgs.grpc ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    icu           = { description = "ICU (icu4c)"; kind = "library"; classification = "A"; packages = pkgs: [ pkgs.icu4c ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    libevent      = { description = "libevent"; kind = "library"; classification = "A"; packages = pkgs: [ pkgs.libevent ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    libinput      = { description = "libinput"; kind = "library"; classification = "A"; packages = pkgs: [ pkgs.libinput ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    libsodium     = { description = "libsodium"; kind = "library"; classification = "A"; packages = pkgs: [ pkgs.libsodium ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    libusb        = { description = "libusb"; kind = "library"; classification = "A"; packages = pkgs: [ pkgs.libusb1 ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    libuv         = { description = "libuv"; kind = "library"; classification = "A"; packages = pkgs: [ pkgs.libuv ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    libxml2       = { description = "libxml2"; kind = "library"; classification = "A"; packages = pkgs: [ pkgs.libxml2 ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    nlohmann_json = { description = "nlohmann/json"; kind = "library"; classification = "A"; packages = pkgs: [ pkgs.nlohmann_json ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    opencv        = { description = "OpenCV"; kind = "library"; classification = "A"; packages = pkgs: [ pkgs.opencv ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    openssl       = { description = "OpenSSL"; kind = "library"; classification = "A"; packages = pkgs: [ pkgs.openssl ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    protobuf      = { description = "protobuf (incl. protoc)"; kind = "library"; classification = "A"; packages = pkgs: [ pkgs.protobuf ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    spdlog        = { description = "spdlog"; kind = "library"; classification = "A"; packages = pkgs: [ pkgs.spdlog ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    zeromq        = { description = "ZeroMQ"; kind = "library"; classification = "A"; packages = pkgs: [ pkgs.zeromq ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    zlib          = { description = "zlib"; kind = "library"; classification = "A"; packages = pkgs: [ pkgs.zlib ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    zstd          = { description = "zstd"; kind = "library"; classification = "A"; packages = pkgs: [ pkgs.zstd ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
  };
  linters = {
    black      = { description = "Black (Python formatter)"; kind = "code-quality"; classification = "A"; packages = pkgs: [ pkgs.black ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    eslint     = { description = "ESLint"; kind = "code-quality"; classification = "A"; packages = pkgs: [ pkgs.eslint ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    nixfmt     = { description = "nixfmt"; kind = "code-quality"; classification = "A"; packages = pkgs: [ pkgs.nixfmt ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    prettier   = { description = "Prettier"; kind = "code-quality"; classification = "A"; packages = pkgs: [ pkgs.prettier ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    ruff       = { description = "Ruff (Python linter)"; kind = "code-quality"; classification = "A"; packages = pkgs: [ pkgs.ruff ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    shellcheck = { description = "ShellCheck"; kind = "code-quality"; classification = "A"; packages = pkgs: [ pkgs.shellcheck ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    shfmt      = { description = "shfmt"; kind = "code-quality"; classification = "A"; packages = pkgs: [ pkgs.shfmt ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
  };
  lsp = {
    gopls                      = { description = "gopls (Go language server)"; kind = "language-server"; classification = "A"; packages = pkgs: [ pkgs.gopls ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    lua-language-server        = { description = "lua-language-server"; kind = "language-server"; classification = "A"; packages = pkgs: [ pkgs.lua-language-server ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    nil                        = { description = "nil (Nix language server)"; kind = "language-server"; classification = "A"; packages = pkgs: [ pkgs.nil ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    nixd                       = { description = "nixd"; kind = "language-server"; classification = "A"; packages = pkgs: [ pkgs.nixd ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    pyright                    = { description = "Pyright"; kind = "language-server"; classification = "A"; packages = pkgs: [ pkgs.pyright ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    rust-analyzer              = { description = "rust-analyzer"; kind = "language-server"; classification = "A"; packages = pkgs: [ pkgs.rust-analyzer ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    typescript-language-server = { description = "typescript-language-server"; kind = "language-server"; classification = "A"; packages = pkgs: [ pkgs.typescript-language-server ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
  };
  mobile = {
    adb     = { description = "ADB/Fastboot (android-tools)"; kind = "sdk"; classification = "A"; packages = pkgs: [ pkgs.android-tools ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    android = { description = "Android Studio (x86_64-only, unfree)"; kind = "sdk"; classification = "A"; packages = pkgs: [ pkgs.android-studio ]; platforms = [ "x86_64-linux" ]; guarded = true; unfree = true; heavy = true; };
    flutter = { description = "Flutter"; kind = "sdk"; classification = "A"; packages = pkgs: [ pkgs.flutter ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; };
  };
  packageManagers = {
    gradle = { description = "Gradle"; kind = "package-manager"; classification = "A"; packages = pkgs: [ pkgs.gradle ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; };
    maven  = { description = "Maven"; kind = "package-manager"; classification = "A"; packages = pkgs: [ pkgs.maven ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; };
    opam   = { description = "opam"; kind = "package-manager"; classification = "A"; packages = pkgs: [ pkgs.opam ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    pipx   = { description = "pipx"; kind = "package-manager"; classification = "A"; packages = pkgs: [ pkgs.pipx ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    poetry = { description = "Poetry"; kind = "package-manager"; classification = "A"; packages = pkgs: [ pkgs.poetry ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    uv     = { description = "uv"; kind = "package-manager"; classification = "A"; packages = pkgs: [ pkgs.uv ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
  };
  protocols = {
    grpcurl  = { description = "grpcurl (gRPC CLI)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.grpcurl ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    mqtt     = { description = "MQTT client tooling (mosquitto; no broker service)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.mosquitto ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    websocat = { description = "websocat"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.websocat ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
  };
  reverseEngineering = {
    binutils = { description = "binutils (objdump/readelf/nm)"; kind = "re-tool"; classification = "A"; packages = pkgs: [ pkgs.binutils ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    cutter   = { description = "Cutter"; kind = "re-tool"; classification = "A"; packages = pkgs: [ pkgs.cutter ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    ghidra   = { description = "Ghidra"; kind = "re-tool"; classification = "A"; packages = pkgs: [ pkgs.ghidra ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; };
    pahole   = { description = "pahole"; kind = "re-tool"; classification = "A"; packages = pkgs: [ pkgs.pahole ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    radare2  = { description = "radare2"; kind = "re-tool"; classification = "A"; packages = pkgs: [ pkgs.radare2 ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
  };
  scientific = {
    hdf5     = { description = "HDF5"; kind = "numerical-lib"; classification = "A"; packages = pkgs: [ pkgs.hdf5 ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    lapack   = { description = "LAPACK"; kind = "numerical-lib"; classification = "A"; packages = pkgs: [ pkgs.lapack ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    netcdf   = { description = "NetCDF"; kind = "numerical-lib"; classification = "A"; packages = pkgs: [ pkgs.netcdf ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    openblas = { description = "OpenBLAS"; kind = "numerical-lib"; classification = "A"; packages = pkgs: [ pkgs.openblas ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    openmpi  = { description = "OpenMPI"; kind = "numerical-lib"; classification = "A"; packages = pkgs: [ pkgs.openmpi ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
  };
  testing = {
    k6         = { description = "k6 (load testing)"; kind = "test-tool"; classification = "A"; packages = pkgs: [ pkgs.k6 ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    playwright = { description = "Playwright"; kind = "test-tool"; classification = "A"; packages = pkgs: [ pkgs.playwright ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
  };
  virtualization = {
    libvirt      = { description = "libvirt (client tooling; never enables libvirtd)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.libvirt ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    qemu         = { description = "QEMU"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.qemu ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; };
    vagrant      = { description = "Vagrant"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.vagrant ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    virt-manager = { description = "virt-manager"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.virt-manager ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
  };
  web = {
    angular     = { description = "Angular development support (scaffolding)"; kind = "project-support"; classification = "E"; support = { runtime = [ "nodejs" "pnpm" ]; scaffold = { command = "pnpm"; argsBeforeName = [ "dlx" "@angular/cli@latest" "new" ]; argsAfterName = [ ]; }; }; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    astro       = { description = "Astro development support (scaffolding)"; kind = "project-support"; classification = "E"; support = { runtime = [ "nodejs" "pnpm" ]; scaffold = { command = "pnpm"; argsBeforeName = [ "create" "astro" ]; argsAfterName = [ ]; }; }; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    bun         = { description = "Bun (JS runtime/bundler)"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.bun ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    deno        = { description = "Deno (JS/TS runtime)"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.deno ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    nextjs      = { description = "Next.js development support (scaffolding)"; kind = "project-support"; classification = "E"; support = { runtime = [ "nodejs" "pnpm" ]; scaffold = { command = "pnpm"; argsBeforeName = [ "create" "next-app" ]; argsAfterName = [ ]; }; }; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    nuxt        = { description = "Nuxt development support (scaffolding)"; kind = "project-support"; classification = "E"; support = { runtime = [ "nodejs" "pnpm" ]; scaffold = { command = "pnpm"; argsBeforeName = [ "dlx" "nuxi@latest" "init" ]; argsAfterName = [ ]; }; }; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    pnpm        = { description = "pnpm"; kind = "package-manager"; classification = "A"; packages = pkgs: [ pkgs.pnpm ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    react       = { description = "React development support (scaffolding via create-vite)"; kind = "project-support"; classification = "E"; support = { runtime = [ "nodejs" "pnpm" ]; scaffold = { command = "pnpm"; argsBeforeName = [ "create" "vite" ]; argsAfterName = [ "--template" "react-ts" ]; }; }; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    remix       = { description = "Remix development support (scaffolding)"; kind = "project-support"; classification = "E"; support = { runtime = [ "nodejs" "pnpm" ]; scaffold = { command = "pnpm"; argsBeforeName = [ "create" "remix" ]; argsAfterName = [ ]; }; }; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    solid       = { description = "Solid development support (scaffolding)"; kind = "project-support"; classification = "E"; support = { runtime = [ "nodejs" "pnpm" ]; scaffold = { command = "pnpm"; argsBeforeName = [ "create" "solid" ]; argsAfterName = [ ]; }; }; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    svelte      = { description = "Svelte development support (scaffolding via sv)"; kind = "project-support"; classification = "E"; support = { runtime = [ "nodejs" "pnpm" ]; scaffold = { command = "pnpm"; argsBeforeName = [ "create" "sv" ]; argsAfterName = [ ]; }; }; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    tailwindcss = { description = "Tailwind CSS (v3 CLI)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.tailwindcss ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    vite        = { description = "Vite development support (scaffolding; not globally installed)"; kind = "project-support"; classification = "E"; support = { runtime = [ "nodejs" "pnpm" ]; scaffold = { command = "pnpm"; argsBeforeName = [ "create" "vite" ]; argsAfterName = [ ]; }; }; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    vue         = { description = "Vue development support (scaffolding)"; kind = "project-support"; classification = "E"; support = { runtime = [ "nodejs" "pnpm" ]; scaffold = { command = "pnpm"; argsBeforeName = [ "create" "vue" ]; argsAfterName = [ ]; }; }; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    yarn        = { description = "Yarn"; kind = "package-manager"; classification = "A"; packages = pkgs: [ pkgs.yarn ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
  };
  webAssembly = {
    binaryen   = { description = "Binaryen"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.binaryen ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    emscripten = { description = "Emscripten"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.emscripten ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = true; };
    wabt       = { description = "WABT"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.wabt ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    wasm-pack  = { description = "wasm-pack"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.wasm-pack ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    wasmer     = { description = "Wasmer"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.wasmer ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
    wasmtime   = { description = "Wasmtime"; kind = "toolchain"; classification = "A"; packages = pkgs: [ pkgs.wasmtime ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; };
  };
}
