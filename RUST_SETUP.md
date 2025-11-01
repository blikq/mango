# Rust LSP Configuration Guide

This document explains the Rust analyzer configuration that has been added to your Neovim setup.

## Files Modified

1. `lua/blikq/plugins/lsp/lspconfig.lua` - Added comprehensive rust_analyzer settings
2. `lua/blikq/plugins/lsp/mason.lua` - Added rust_analyzer to ensure_installed list

## Key Features Enabled

### 1. Inlay Hints (Type Annotations)
The most visible feature - shows data types inline in your code without you having to hover over variables.

**Enabled Settings:**
- **Type hints**: Shows the type of variables (e.g., `let x: i32 = 5`)
- **Parameter hints**: Shows parameter names in function calls (e.g., `func(param: value)`)
- **Chaining hints**: Shows types in method chains (e.g., `vec.iter().map().collect()`)

**Configuration location:** `inlayHints` section

### 2. Cargo Integration
- **allFeatures = true**: Loads all features from Cargo.toml
- **buildScripts**: Enables support for build.rs scripts (commented out by default)

### 3. Code Checking
- **check.command = "clippy"**: Uses clippy (Rust's linter) instead of basic cargo check
- Provides more helpful warnings and suggestions

### 4. Completion Enhancements
- **autoimport**: Automatically imports items when you complete them
- **postfix completions**: Enable shortcuts like `.if`, `.match`, `.iter`
- **callable snippets**: Auto-fills function arguments in completions

### 5. Code Lens
Shows inline actions above functions/structs:
- References count
- Implementations
- Run/Debug buttons for tests and main functions

### 6. Proc Macros
Full support for procedural macros (derive macros, attribute macros, etc.)

### 7. Hover Actions
Enhanced documentation popup with:
- Type information
- References and implementations links
- Run/Debug options

## Commented Out Options

Many advanced options are included but commented out. These can be enabled by uncommenting them:

### Cargo Options
```lua
-- loadOutDirsFromCheck = true,
-- buildScripts = { enable = true },
-- features = {}, -- Specify specific features
```

### Clippy Extra Arguments
```lua
-- check = {
--   command = "clippy",
--   extraArgs = { "--all", "--", "-W", "clippy::all" },
-- },
```

### Diagnostics
```lua
-- disabled = { "unresolved-proc-macro" },
-- experimental = { enable = true },
```

### Rustfmt
```lua
-- rustfmt = {
--   extraArgs = {},
--   overrideCommand = nil,
-- },
```

## Usage Tips

### Viewing Inlay Hints
Inlay hints should appear automatically when rust_analyzer is running. They show:
- Variable types: `let x/* : i32 */ = 5;`
- Function parameter names: `func(/* param: */ value)`
- Closure return types: `|x| /* -> i32 */ x + 1`

### Toggle Inlay Hints (if needed)
You can toggle hints on/off with the new keymap:
- **`<leader>ih`** - Toggle inlay hints on/off

Or manually in command mode:
```vim
:lua vim.lsp.inlay_hint.enable(true)  -- Enable
:lua vim.lsp.inlay_hint.enable(false) -- Disable
```

### Code Actions
Use `<leader>ca` (default binding) to see available code actions like:
- Import suggestions
- Add missing match arms
- Fill in struct fields
- And more!

### Hover Documentation
Press `K` (default) over any symbol to see:
- Type information
- Documentation
- Links to implementations

## Prerequisites

### Required
1. **Rust installed**: `rustc`, `cargo`, etc.
2. **rust-analyzer**: Will be installed via Mason
3. **Neovim 0.8+**: For inlay hints support (0.10+ recommended)

### Optional but Recommended
1. **rustfmt**: For code formatting (usually comes with rustup)
2. **clippy**: For linting (usually comes with rustup)

### Installation
When you open Neovim, Mason will automatically install rust_analyzer:
```
:Mason
```

Or manually:
```
:MasonInstall rust-analyzer
```

## Testing the Setup

1. Create a simple Rust file:
```rust
fn main() {
    let numbers = vec![1, 2, 3, 4, 5];
    let doubled: Vec<_> = numbers
        .iter()
        .map(|x| x * 2)
        .collect();
    
    println!("{:?}", doubled);
}
```

2. Open it in Neovim and you should see:
   - Inlay type hints appearing
   - Code completion working
   - Hover documentation available (press `K`)
   - Code actions available (press `<leader>ca`)

## Troubleshooting

### Inlay hints not showing?
1. **Check Neovim version**: Inlay hints require Neovim 0.10+
   ```vim
   :version
   ```
   
2. **Check if LSP is attached**: 
   ```vim
   :LspInfo
   ```
   Make sure rust_analyzer is attached and running.

3. **Manually enable inlay hints**:
   ```vim
   :lua vim.lsp.inlay_hint.enable(true)
   ```

4. **Check rust-analyzer status**:
   ```vim
   :checkhealth
   ```

5. **Restart LSP**:
   - Use `<leader>rs` or
   ```vim
   :LspRestart
   ```

6. **Check if hints are supported**:
   ```vim
   :lua =vim.lsp.get_active_clients()[1].server_capabilities.inlayHintProvider
   ```
   Should return a table, not `nil`.

7. **Make sure you're in a Rust project**: rust-analyzer needs a `Cargo.toml` file to work properly.

### Slow performance?
Some options can be adjusted if rust_analyzer is slow:
- Reduce `inlayHints.maxLength`
- Disable some code lens options
- Use `cargo.features` instead of `cargo.allFeatures`

### Errors about unresolved proc macros?
Uncomment this line to disable those warnings:
```lua
disabled = { "unresolved-proc-macro" },
```

## Further Customization

The configuration in `lspconfig.lua` has many commented options. Review them and uncomment what you need. Key sections to explore:

1. **cargo**: Fine-tune which features to load
2. **checkOnSave.extraArgs**: Add custom clippy rules
3. **rustfmt**: Custom formatting options
4. **diagnostics.disabled**: Hide annoying warnings

## Resources

- [rust-analyzer Manual](https://rust-analyzer.github.io/manual.html)
- [rust-analyzer Configuration](https://rust-analyzer.github.io/manual.html#configuration)
- [Original Guide](https://rsdlt.github.io/posts/rust-nvim-ide-guide-walkthrough-development-debug/)
