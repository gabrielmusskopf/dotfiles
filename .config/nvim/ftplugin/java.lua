local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

local home = os.getenv("HOME")
local workspace_dir = home .. '/home/gabrielgmusskopf/.cache/jdtls/' .. project_name

print(vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]))

local config = {
    cmd = {
        'java',
        '-jar', home .. '/jdtls/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar',
        '-configuration', home .. '/jdtls/config_linux',
        '-data', workspace_dir
    },
    root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
    init_options = {
        bundles = {
            vim.fn.glob(home .. '/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-0.45.0.jar')
        }
    },
    on_attach = function(client, bufnr)
        -- With `hotcodereplace = 'auto' the debug adapter will try to apply code changes
        -- you make during a debug session immediately.
        -- Remove the option if you do not want that.
        -- You can use the `JdtHotcodeReplace` command to trigger it manually
        require('jdtls').setup_dap({ hotcodereplace = 'auto' })
    end
}

require('jdtls').start_or_attach(config)
