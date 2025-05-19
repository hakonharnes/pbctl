# pbctl

Command-line interface to the MacOS pasteboard. A modern replacement for `pbcopy`/`pbpaste` that understands arbitrary binary data.

> [!WARNING]
> This is a work in progress. Features and usage may change in future versions.

## Features

- Copy data (from files or stdin) to the MacOS pasteboard with type auto-detection or manual override.
- Paste data (to files or stdout) from the pasteboard, with type or output file extension inference.
- List available types and inspect pasteboard items.
- Display pasteboard statistics and clear the clipboard.
- Supports multiple named pasteboards (general, find, font, ruler, drag).

## Requirements

- MacOS 11.0 or later

## Installation

### Homebrew

```sh
brew install hakonharnes/tap/pbctl
```

### Build from source

```sh
git clone https://github.com/hakonharnes/pbctl.git
cd pbctl
swift build -c release
cp .build/release/pbctl /usr/local/bin/
```

## Command reference

- `pbctl paste` Paste data from the pasteboard.
- `pbctl copy` Copy data into the pasteboard.
- `pbctl clear` Clear the pasteboard contents.
- `pbctl types` List all available types in the pasteboard.
- `pbctl status` Show pasteboard statistics and details.

## Usage

### Auto-mode

```sh
# Paste the clipboard into a file
pbctl > screenshot.png  # implicit ‘paste’ (stdout redirected)

# Copy the output of a command
ls -la | pbctl # implicit ‘copy’ (stdin is a pipe)

# Explicit verbs (always understood)
pbctl copy    < file.pdf
pbctl paste   --type text/plain  > note.txt
```

### Paste

```sh
# Paste clipboard contents to stdout
pbctl paste > output.txt

# Paste clipboard contents as a file (type inferred from extension)
pbctl paste -o output.png

# Paste specific type to a file
pbctl paste -o output.txt -t text/plain

# Specify a pasteboard
pbctl paste --pasteboard find
```

### Copy

```sh
# Copy file contents to the clipboard (auto type detection)
pbctl copy -i input.png

# Copy file with explicit MIME type or UTI
pbctl copy -i input.txt -t text/plain
pbctl copy -i image.heic -t public.heic

# Copy from stdin
cat file.pdf | pbctl copy

# Specify a pasteboard
pbctl copy -i input.txt --pasteboard find
```

### Clear

```sh
# Clear the clipboard
pbctl clear
```

### Types

```sh
# List all available types in the clipboard
pbctl types
```

### Status

```sh
# Show clipboard statistics
pbctl status
```

## License

This project is licensed under the MIT License.

## Disclaimer

This is early-stage software. Use at your own risk. Feedback and contributions welcome!
