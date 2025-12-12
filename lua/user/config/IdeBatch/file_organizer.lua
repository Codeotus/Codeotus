-- File Organizer - Oil.nvim style buffer for managing file collections
-- Edit folders like a text file, saves to ~/.local/share/nvim/file_organizer/

local M = {}

-- Storage paths
local data_dir = vim.fn.stdpath('data') .. '/file_organizer'
local folders_file = data_dir .. '/folders.json'

-- State
local state = {
    folders = {}, -- { folder_name = { "file1", "file2" } }
    buffer = nil,
    current_folder = nil,
    clipboard_file = nil, -- File waiting to be pasted
}

-- Ensure data directory exists
vim.fn.mkdir(data_dir, 'p')

-- Load folders from disk
local function load_folders()
    local file = io.open(folders_file, 'r')
    if file then
        local content = file:read('*all')
        file:close()
        local ok, data = pcall(vim.json.decode, content)
        if ok and data then
            state.folders = data
        end
    end
end

-- Save folders to disk
local function save_folders()
    local file = io.open(folders_file, 'w')
    if file then
        file:write(vim.json.encode(state.folders))
        file:close()
    end
end

-- Initialize
load_folders()

-- Helper function to open buffer in floating window
function M._open_float(buf)
    local opts = M.config.float_opts

    -- Calculate dimensions
    local width = math.floor(vim.o.columns * opts.width)
    local height = math.floor(vim.o.lines * opts.height)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    -- Create floating window
    local win = vim.api.nvim_open_win(buf, true, {
        relative = opts.relative,
        width = width,
        height = height,
        row = row,
        col = col,
        style = 'minimal',
        border = opts.border,
        title = opts.title,
        title_pos = opts.title_pos,
    })

    -- Window options
    vim.api.nvim_win_set_option(win, 'winblend', 0)
    vim.api.nvim_win_set_option(win, 'cursorline', true)

    -- Close with q or Esc
    vim.keymap.set('n', 'q', function()
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, false)
        end
    end, { buffer = buf, silent = true })

    vim.keymap.set('n', '<Esc>', function()
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, false)
        end
    end, { buffer = buf, silent = true })
end

-- Parse buffer content to extract folders and files
local function parse_buffer_content(lines)
    local new_folders = {}
    local current_folder = nil

    for _, line in ipairs(lines) do
        -- Empty lines
        if line:match('^%s*$') then
            goto continue
        end

        -- Folder line (ends with /)
        local folder_name = line:match('^%s*(.-)/%s*$')
        if folder_name and folder_name ~= '' then
            current_folder = folder_name
            new_folders[current_folder] = new_folders[current_folder] or {}
            goto continue
        end

        -- File line (under a folder)
        if current_folder then
            local file_path = line:match('^%s*(.+)%s*$')
            if file_path and file_path ~= '' then
                -- Expand to absolute path if needed
                if not file_path:match('^/') and not file_path:match('^~') then
                    file_path = vim.fn.fnamemodify(file_path, ':p')
                else
                    file_path = vim.fn.expand(file_path)
                end
                table.insert(new_folders[current_folder], file_path)
            end
        end

        ::continue::
    end

    return new_folders
end

-- Generate buffer content from state
local function generate_buffer_content()
    local lines = {}

    -- Header
    table.insert(lines, '# File Organizer')
    table.insert(lines, '# Edit like a text file: Create folders with "FolderName/"')
    table.insert(lines, '# Add files under folders, then :w to save')
    table.insert(lines, '# Press <leader>ad on any file to copy it, then "p" here to paste')
    table.insert(lines, '')

    -- Folders and files
    for folder_name, files in pairs(state.folders) do
        table.insert(lines, folder_name .. '/')
        for _, file in ipairs(files) do
            local display = vim.fn.fnamemodify(file, ':~')
            table.insert(lines, '  ' .. display)
        end
        table.insert(lines, '')
    end

    -- Instructions at bottom
    table.insert(lines, '')
    table.insert(lines, '---')
    table.insert(lines, '# Commands: :w (save), dd (delete line), <leader>ad (copy file), p (paste file)')

    return lines
end

-- Display mode configuration
M.config = {
    display_mode = 'float', -- Options: 'float', 'vsplit', 'hsplit', 'full'
    float_opts = {
        relative = 'editor',
        width = 0.8,  -- 80% of screen width
        height = 0.8, -- 80% of screen height
        border = 'rounded',
        title = ' 📂 File Organizer ',
        title_pos = 'center',
    }
}

-- Create or open the file organizer buffer
function M.open(mode)
    mode = mode or M.config.display_mode

    -- Check if buffer already exists
    if state.buffer and vim.api.nvim_buf_is_valid(state.buffer) then
        -- Find window with this buffer or create new one
        local wins = vim.fn.win_findbuf(state.buffer)
        if #wins > 0 then
            vim.api.nvim_set_current_win(wins[1])
        else
            -- Open with specified mode
            if mode == 'float' then
                M._open_float(state.buffer)
            elseif mode == 'vsplit' then
                vim.cmd('vsplit')
                vim.api.nvim_win_set_buf(0, state.buffer)
            elseif mode == 'hsplit' then
                vim.cmd('split')
                vim.api.nvim_win_set_buf(0, state.buffer)
            elseif mode == 'full' then
                vim.cmd('edit file-organizer://')
            end
        end
        return
    end

    -- Create new buffer
    local buf = vim.api.nvim_create_buf(false, false)
    state.buffer = buf

    -- Buffer settings
    vim.api.nvim_buf_set_name(buf, 'file-organizer://')
    vim.api.nvim_buf_set_option(buf, 'buftype', 'acwrite')
    vim.api.nvim_buf_set_option(buf, 'filetype', 'fileorganizer')
    vim.api.nvim_buf_set_option(buf, 'swapfile', false)

    -- Set initial content
    local lines = generate_buffer_content()
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, 'modified', false)

    -- Open based on display mode
    if mode == 'float' then
        M._open_float(buf)
    elseif mode == 'vsplit' then
        vim.cmd('vsplit')
        vim.api.nvim_win_set_buf(0, buf)
    elseif mode == 'hsplit' then
        vim.cmd('split')
        vim.api.nvim_win_set_buf(0, buf)
    elseif mode == 'full' then
        vim.api.nvim_set_current_buf(buf)
    end

    -- Keymaps
    local opts = { buffer = buf, silent = true }

    -- Paste clipboard file
    vim.keymap.set('n', 'p', function()
        if not state.clipboard_file then
            vim.notify('No file in clipboard. Press <leader>ad on a file first.', vim.log.levels.WARN)
            return
        end

        local line = vim.api.nvim_win_get_cursor(0)[1]
        local display = vim.fn.fnamemodify(state.clipboard_file, ':~')
        vim.api.nvim_buf_set_lines(buf, line, line, false, { '  ' .. display })
        vim.notify('Pasted: ' .. display, vim.log.levels.INFO)
    end, opts)

    -- Yank file path
    vim.keymap.set('n', 'yy', function()
        local line = vim.api.nvim_get_current_line()
        local file_path = line:match('^%s*(.+)%s*$')
        if file_path and not file_path:match('/$') and file_path ~= '' then
            vim.fn.setreg('+', file_path)
            vim.notify('Yanked: ' .. file_path, vim.log.levels.INFO)
        end
    end, opts)

    -- Open file under cursor
    vim.keymap.set('n', '<CR>', function()
        local line = vim.api.nvim_get_current_line()
        local file_path = line:match('^%s*(.+)%s*$')

        if file_path and not file_path:match('/$') and file_path ~= '' then
            -- Expand path
            file_path = vim.fn.expand(file_path)
            if vim.fn.filereadable(file_path) == 1 then
                vim.cmd('edit ' .. vim.fn.fnameescape(file_path))
            else
                vim.notify('File not found: ' .. file_path, vim.log.levels.WARN)
            end
        end
    end, opts)

    -- Refresh buffer
    vim.keymap.set('n', 'R', function()
        local lines = generate_buffer_content()
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.api.nvim_buf_set_option(buf, 'modified', false)
        vim.notify('Refreshed', vim.log.levels.INFO)
    end, opts)

    -- Save handler
    vim.api.nvim_create_autocmd('BufWriteCmd', {
        buffer = buf,
        callback = function()
            -- Ask for confirmation
            vim.ui.select({ 'Yes', 'No' }, {
                prompt = 'Save changes to file organizer?',
                format_item = function(item)
                    return item == 'Yes' and 'y. Yes - Save changes' or 'n. No - Cancel'
                end,
            }, function(choice)
                if choice == 'Yes' then
                    -- Parse buffer
                    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
                    local new_folders = parse_buffer_content(lines)

                    -- Check for new folders
                    local created_folders = {}
                    for folder_name, _ in pairs(new_folders) do
                        if not state.folders[folder_name] then
                            table.insert(created_folders, folder_name)
                        end
                    end

                    if #created_folders > 0 then
                        local folder_list = table.concat(created_folders, ', ')
                        vim.ui.select({ 'Yes', 'No' }, {
                            prompt = string.format('Create new folder(s): %s?', folder_list),
                            format_item = function(item)
                                return item == 'Yes' and 'Y. Yes - Create' or 'N. No - Cancel'
                            end,
                        }, function(create_choice)
                            if create_choice == 'Yes' then
                                state.folders = new_folders
                                save_folders()
                                vim.api.nvim_buf_set_option(buf, 'modified', false)
                                vim.notify(string.format('Saved! Created folders: %s', folder_list), vim.log.levels.INFO)
                            else
                                vim.notify('Cancelled', vim.log.levels.INFO)
                            end
                        end)
                    else
                        -- No new folders, just save
                        state.folders = new_folders
                        save_folders()
                        vim.api.nvim_buf_set_option(buf, 'modified', false)
                        vim.notify('Saved!', vim.log.levels.INFO)
                    end
                else
                    vim.notify('Save cancelled', vim.log.levels.INFO)
                end
            end)
        end,
    })

    -- Syntax highlighting
    vim.api.nvim_buf_call(buf, function()
        vim.cmd([[
            syn match FileOrgComment /^#.*/
            syn match FileOrgFolder /^[^#].*\/$/
            syn match FileOrgFile /^\s\+.*/
            syn match FileOrgSeparator /^---$/

            hi FileOrgComment guifg=#6c7086 gui=italic
            hi FileOrgFolder guifg=#f9e2af gui=bold
            hi FileOrgFile guifg=#cdd6f4
            hi FileOrgSeparator guifg=#89b4fa
        ]])
    end)
end

-- Add current file to clipboard (for pasting in organizer)
function M.add_current_file()
    local filepath = vim.api.nvim_buf_get_name(0)
    if filepath == '' or filepath:match('^file%-organizer://') then
        vim.notify('No file in current buffer', vim.log.levels.WARN)
        return
    end

    filepath = vim.fn.fnamemodify(filepath, ':p')
    state.clipboard_file = filepath

    local display = vim.fn.fnamemodify(filepath, ':~')
    vim.notify(string.format('Copied to clipboard: %s\nOpen organizer and press "p" to paste', display),
        vim.log.levels.INFO)

    -- Optionally open the organizer
    vim.ui.select({ 'Yes', 'No' }, {
        prompt = 'Open file organizer now?',
    }, function(choice)
        if choice == 'Yes' then
            M.open()
        end
    end)
end

-- Quick add - opens organizer and goes to end for quick paste
function M.quick_add()
    local filepath = vim.api.nvim_buf_get_name(0)
    if filepath == '' or filepath:match('^file%-organizer://') then
        vim.notify('No file in current buffer', vim.log.levels.WARN)
        return
    end

    filepath = vim.fn.fnamemodify(filepath, ':p')
    state.clipboard_file = filepath

    M.open()

    -- Go to end of buffer
    vim.schedule(function()
        local line_count = vim.api.nvim_buf_line_count(state.buffer)
        vim.api.nvim_win_set_cursor(0, { line_count - 3, 0 })
        vim.notify('File copied! Press "p" to paste, then :w to save', vim.log.levels.INFO)
    end)
end

-- Export module
return M
