local jdtls = require("jdtls")
local home = os.getenv("HOME")
local ostype = os.getenv("OSTYPE")
local jdtls_config = "/.config/jdtls/config_linux"
if ostype ~= "linux-gnu" then
	jdtls_config = "/.config/jdtls/config_mac_arm"
end

local bundles = {
	vim.fn.glob(
		home .. "/.config/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar",
		1
	),
}
vim.list_extend(bundles, vim.split(vim.fn.glob(home .. "/.config/vscode-java-test/server/*.jar", 1), "\n"))

local java = {
	{
		type = "java",
		name = "Debug",
		request = "launch",
		program = "${file}",
	},
	{
		type = "java",
		name = "Debug test ",
		request = "launch",
		mode = "test",
		program = "./${relativeFileDirname}",
	},
	{
		type = "java",
		name = "Attach (Pick Process)",
		mode = "local",
		request = "attach",
		processId = require("dap.utils").pick_process,
	},
	{
		type = "java",
		name = "Attach (127.0.0.1:9090)",
		mode = "remote",
		request = "attach",
		port = "9080",
	},
}

local config = {
	-- The command that starts the language server
	-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
	cmd = {

		-- 💀
		"java", -- or '/path/to/java17_or_newer/bin/java'
		-- depends on if `java` is in your $PATH env variable and if it points to the right version.

		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xmx1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",

		-- 💀
		"-jar",
		home .. "/.config/jdtls/plugins/org.eclipse.equinox.launcher_1.6.700.v20231214-2017.jar",
		-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
		-- Must point to the                                                     Change this to
		-- eclipse.jdt.ls installation                                           the actual version

		-- 💀
		"-configuration",
		home .. jdtls_config,
		-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
		-- Must point to the                      Change to one of `linux`, `win` or `mac`
		-- eclipse.jdt.ls installation            Depending on your system.

		-- 💀
		-- See `data directory configuration` section in the README
		"-data",
		home .. "/.config/jdtls/data",
	},

	-- 💀
	-- This is the default if not provided, you can remove it. Or adjust as needed.
	-- One dedicated LSP server & client will be started per unique root_dir
	root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),

	-- Here you can configure eclipse.jdt.ls specific settings
	-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
	-- for a list of options
	settings = {
		java = {},
	},

	-- Language server `initializationOptions`
	-- You need to extend the `bundles` with paths to jar files
	-- if you want to use additional eclipse.jdt.ls plugins.
	--
	-- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
	--
	-- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
	init_options = {
		bundles = bundles,
	},
}

local dap_ok, dap = pcall(require, "dap")
if not dap_ok then
	print("nvim-dap not installed!")
	return
end

dap.configurations.java = {
	{
		-- You need to extend the classPath to list your dependencies.
		-- `nvim-jdtls` would automatically add the `classPaths` property if it is missing
		-- classPaths = {},

		-- If using multi-module projects, remove otherwise.
		javaExec = "java",
		-- mainClass = "your.package.name.MainClassName",

		-- If using the JDK9+ module system, this needs to be extended
		-- `nvim-jdtls` would automatically populate this property
		-- modulePaths = {},
		request = "launch",
		type = "java",
	},
}

jdtls.start_or_attach(config)
