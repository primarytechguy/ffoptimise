# ffoptimise for macOS — Installation and Usage Guide

This guide explains how to:
- Install Homebrew (macOS package manager)
- Install FFmpeg using Homebrew
- Install the ffoptimise.pkg (bundled optimiseVideos.sh for easy installation)
- Use the ffoptimise command to optimise videos

Tested on macOS (Intel and Apple Silicon).

## 1) Install Homebrew

Homebrew is the recommended way to install FFmpeg.

- Open Terminal and run:

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

- Follow on-screen instructions. After installation, ensure your PATH includes Homebrew’s bin directory:
  - Apple Silicon (M1/M2/M3):
    ```
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
    ```
  - Intel:
    Typically already on PATH. If needed:
    ```
    echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.zprofile
    source ~/.zprofile
    ```

- Verify:
  ```
  brew --version
  ```

## 2) Install FFmpeg using Homebrew

```
brew update
brew install ffmpeg
```

Verify FFmpeg is available:
```
ffmpeg -version
```

If not found, open a new terminal window or re-load your shell profile:
```
source ~/.zprofile  # or ~/.zshrc / ~/.bash_profile depending on your shell
```

## 3) Install ffoptimise.pkg

The ffoptimise.pkg installs a small wrapper so you can run the optimiser as a simple `ffoptimise` command from any directory.

- If you have the package file:
  - Double‑click `ffoptimise.pkg` and follow the installer prompts; or
  - Install via Terminal (replace the path with the actual location):
    ```
    sudo installer -pkg "/path/to/ffoptimise.pkg" -target /
    ```

- After installation, the `ffoptimise` executable is placed on your PATH (commonly `/usr/local/bin/ffoptimise` on Intel or `/opt/homebrew/bin/ffoptimise` on Apple Silicon if linked there). If Terminal can’t find `ffoptimise`, see Troubleshooting below.

- Verify installation:
  ```
  ffoptimise -h
  ```

## 4) How to use `ffoptimise`

The `ffoptimise` command wraps the optimiseVideos.sh script. It optimises all .mp4 and .mov files in a directory, saving results to an `optimised` subfolder. Output files are always `.mp4`.

### Basic usage

```
ffoptimise [input_directory] [--delete-audio|--no-audio]
ffoptimise -h | --help
```

- `input_directory` (optional): Folder containing source videos. If omitted, you’ll be prompted to use the current directory or paste another path.
- By default, audio is preserved. Use `--delete-audio` to remove audio, or `--no-audio` to explicitly keep it.
- If not provided via flags, the script interactively asks whether to delete audio and asks you to choose a CRF.

### Encoding details

- Rescales to fit within 1920x1080 while preserving aspect ratio (even dimensions)
- Video codec: `libx265` (HEVC), preset `slow`, `-tag:v hvc1`, `-movflags faststart`
- Quality: CRF between 18 (best quality) and 34 (smallest size). Default: 24
- Audio (when kept): AAC at 128k
- Output directory: `<input_directory>/optimised`

### Examples

- Optimise the current directory (interactive prompts will ask about audio and CRF):
  ```
  ffoptimise
  ```

- Optimise a specific folder, keep audio, and accept the default CRF:
  ```
  ffoptimise "/Users/you/Videos/ProjectX" --no-audio
  ```

- Optimise a folder and delete audio tracks:
  ```
  ffoptimise "/Users/you/Videos/ProjectX" --delete-audio
  ```

During interactive mode, you’ll see prompts like:
- Use current directory? (y/n)
- Delete audio from videos? (y/n) [default: n]
- Choose CRF (18–34, lower=better). Press Enter for default [24]

### What gets processed

- Input formats: `.mp4` and `.mov` (case-insensitive)
- Output files: Always `.mp4` in `optimised` subfolder, keeping original base name

## Troubleshooting

- `ffoptimise: command not found`
  - Ensure the install location is on your PATH. For example:
    - Apple Silicon (zsh):
      ```
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
      eval "$(/opt/homebrew/bin/brew shellenv)"
      ```
    - Intel:
      ```
      echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.zprofile
      source ~/.zprofile
      ```
  - Open a new Terminal window and try again.

- `ffmpeg not found` inside the script
  - Install or re-install via Homebrew: `brew install ffmpeg`
  - Make sure your shell session has updated PATH (open a new terminal or `source ~/.zprofile`).

- Permission issues with the pkg or binary
  - Re-run the installer with sudo as shown above.

## Uninstall (optional)

Depending on how `ffoptimise.pkg` is built, it likely installs a single binary/symlink:
- Common path: `/usr/local/bin/ffoptimise` (Intel) or Homebrew-linked path on Apple Silicon.
- You can remove it with:
  ```
  sudo rm -f /usr/local/bin/ffoptimise
  sudo rm -f /opt/homebrew/bin/ffoptimise
  ```

Note: If the pkg also added other files, consult its documentation for full uninstall steps.

---

If you run into issues, please share the exact command and error output so we can help troubleshoot.
