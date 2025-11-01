# Rust Inlay Hints Diagnostic Checklist

Run these commands in Neovim to diagnose why inlay hints aren't showing:

## 1. Check Neovim Version
```vim
:version
```
**Required:** Neovim 0.10.0 or higher for inlay hints support.

---

## 2. Check LSP Status
```vim
:LspInfo
```
**Expected:** You should see `rust_analyzer` in the list of attached clients.

---

## 3. Check rust-analyzer Installation
```vim
:Mason
```
Look for `rust_analyzer` in the list. It should have a checkmark (✓).

If not installed, run:
```vim
:MasonInstall rust-analyzer
```

---

## 4. Manually Enable Inlay Hints
```vim
:lua vim.lsp.inlay_hint.enable(true)
```
Try this after opening a Rust file.

---

## 5. Check Server Capabilities
```vim
:lua vim.print(vim.lsp.get_active_clients()[1].server_capabilities.inlayHintProvider)
```
**Expected:** Should show a table with inlay hint settings, not `nil`.

---

## 6. Check if You're in a Rust Project
```bash
# In terminal, check if Cargo.toml exists in your project root
ls -la Cargo.toml
```
rust-analyzer needs a `Cargo.toml` file to activate properly.

---

## 7. Reload Configuration
After making changes:
```vim
:source ~/.config/nvim/init.lua
```
Or restart Neovim completely.

---

## 8. Restart LSP
```vim
:LspRestart
```
Or use the keymap: `<leader>rs`

---

## 9. Check for Errors
```vim
:messages
```
Look for any error messages related to LSP or rust-analyzer.

---

## 10. Toggle Inlay Hints
Try toggling them on/off:
- Press `<leader>ih` (in normal mode)

Or manually:
```vim
:lua vim.lsp.inlay_hint.enable(true)   -- Enable
:lua vim.lsp.inlay_hint.enable(false)  -- Disable
:lua vim.lsp.inlay_hint.enable(true)   -- Enable again
```

---

## Quick Test File

Create a test Rust file to verify hints are working:

```rust
// test.rs
fn main() {
    let x = 5;
    let y = vec![1, 2, 3];
    let z = y.iter().map(|n| n * 2).collect();
    
    println!("{:?}", z);
}
```

**Expected hints to see:**
- `let x/* : i32 */ = 5;`
- `let y/* : Vec<i32> */ = vec![1, 2, 3];`
- `let z/* : Vec<_> */ = y.iter().map(|n/* : &i32 */| n * 2).collect();`

---

## Common Issues and Solutions

### Issue: "LSP not attached"
**Solution:** Make sure you're in a directory with a `Cargo.toml` file.

### Issue: "rust_analyzer not found"
**Solution:** Run `:MasonInstall rust-analyzer`

### Issue: "Neovim version too old"
**Solution:** Update Neovim to 0.10.0 or higher:
```bash
# Check your package manager for updates
# or download from https://github.com/neovim/neovim/releases
```

### Issue: "Hints briefly appear then disappear"
**Solution:** 
1. Check if another plugin is conflicting
2. Try disabling other LSP-related plugins temporarily

### Issue: "Only some hints show"
**Solution:** Check the rust_analyzer settings in `lspconfig.lua`:
- `inlayHints.typeHints.enable`
- `inlayHints.parameterHints.enable`
- `inlayHints.chainingHints.enable`

Make sure they're all set to `true`.

---

## Still Not Working?

1. Check rust-analyzer logs:
   ```vim
   :lua vim.cmd('e ' .. vim.lsp.get_log_path())
   ```

2. Check health:
   ```vim
   :checkhealth
   ```

3. Try with minimal config to isolate the issue.

4. Make sure Rust and rustup are properly installed:
   ```bash
   rustc --version
   cargo --version
   ```
