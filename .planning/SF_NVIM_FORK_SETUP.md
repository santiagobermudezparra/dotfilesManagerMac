# sf.nvim Fork Setup Guide

## Problem Fixed
- **Bug**: `nvim --headless` crashes with "Sf: Empty table" error in `org.lua:192`
- **Root cause**: Plugin calls `is_table_empty()` after org fetch, throws error if no orgs available
- **Fixed in**: `lua/sf/org.lua` (3 locations)

## Changes Applied
```diff
File: lua/sf/org.lua

1. Line 192 - store_orgs() function:
   - REMOVED: U.is_table_empty(H.orgs)  [causes crash on empty org list]

2. Line 132 - set_target_org() function:
   - CHANGED: U.is_table_empty(H.orgs)  [error-throwing validation]
   - TO: if vim.tbl_isempty(H.orgs) then return U.show_err(...) [graceful error]

3. Line 152 - set_global_target_org() function:
   - CHANGED: U.is_table_empty(H.orgs)  [error-throwing validation]
   - TO: if vim.tbl_isempty(H.orgs) then return U.show_err(...) [graceful error]
```

## Step 1: Create Fork on GitHub (Manual)

1. Go to https://github.com/xixiaofinland/sf.nvim
2. Click **Fork** button (top right)
3. Choose your personal account: `santiagobermudezparra`
4. Uncheck "Copy the main branch only" if you want all branches
5. Click **Create fork**

Result: `https://github.com/santiagobermudezparra/sf.nvim`

## Step 2: Clone Fork Locally
```bash
git clone https://github.com/santiagobermudezparra/sf.nvim.git ~/src/sf.nvim
cd ~/src/sf.nvim
git remote add upstream https://github.com/xixiaofinland/sf.nvim.git
```

## Step 3: Apply the Fixes

Copy the fixed `lua/sf/org.lua` from your current installation:
```bash
cp ~/.local/share/nvim/lazy/sf.nvim/lua/sf/org.lua ~/src/sf.nvim/lua/sf/org.lua
```

Or manually apply the 3 changes listed above to `lua/sf/org.lua`.

## Step 4: Commit & Push
```bash
cd ~/src/sf.nvim
git add lua/sf/org.lua
git commit -m "fix: handle empty org list gracefully in headless mode

- Remove error-throwing validation after store_orgs()
- Replace with graceful error messages in set_target_org/set_global_target_org
- Fixes nvim --headless crash when no orgs are available"
git push origin main
```

## Step 5: Update Your Dotfiles

Edit `~/.config/nvim/lua/plugins/salesforce.lua`:

```lua
{
  "santiagobermudezparra/sf.nvim",  -- Change from xixiaofinland/sf.nvim
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("sf").setup({
      enable_hotkeys = false,
    })
    -- ... rest of config
  end,
}
```

Then reload lazy.nvim:
```
:Lazy sync
```

## Step 6: Verify
```bash
nvim --headless -c 'qa'  # Should exit cleanly, no errors
```

## Future Upstream Updates

When sf.nvim releases a fix or you want to merge upstream changes:

```bash
cd ~/src/sf.nvim
git fetch upstream
git rebase upstream/main
# resolve any conflicts if needed
git push origin main
# lazy.nvim will auto-update next time
```

## Alternative: Contribute Back

Consider opening a PR to the upstream project:
https://github.com/xixiaofinland/sf.nvim/pulls

This benefits the whole community. The maintainer may have different thoughts on the fix.
