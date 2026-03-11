-- Clangd language server configuration for C/C++
return {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--query-driver=/usr/bin/g++", -- Adjust this path to your compiler if needed
    "--enable-config",  -- Allow project-specific configuration
    "--fallback-style=llvm",
  },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
  root_markers = { ".clangd", ".clang-tidy", ".clang-format", "compile_commands.json", "compile_flags.txt", "configure.ac", ".git" },
  init_options = {
    compilationDatabasePath = "build", -- If your compile_commands.json is in a build subdirectory
    fallbackFlags = { "-std=c++17" }, -- Adjust to your C++ standard
  },
}
