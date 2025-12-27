mklink /j "%AppData%\..\Local\nvim" "%UserProfile%\dotfiles\nvim\.config\nvim";
mklink "%UserProfile%\.wezterm.lua" "%UserProfile%\dotfiles\wezterm\.wezterm.lua";

REM // Ripgrep, gcc
winget install BurntSushi.ripgrep.MSVC LLVM.LLVM
