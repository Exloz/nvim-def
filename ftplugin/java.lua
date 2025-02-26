-- JDTLS (Java LSP) configuration
local home = vim.fn.expand("$USERPROFILE") -- Get the home directory

print(home)
local jdtls = require("jdtls")
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = home .. "\\jdtls-workspace\\" .. project_name

local system_os = ""

-- Determine OS
if vim.fn.has("mac") == 1 then
  system_os = "mac"
elseif vim.fn.has("unix") == 1 then
  system_os = "linux"
elseif vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
  system_os = "win"
else
  print("OS not found, defaulting to 'linux'")
  system_os = "linux"
end

-- Needed for debugging
local bundles = {
  vim.fn.glob(home .. "\\AppData\\Local\\nvim-data\\mason\\share\\java-debug-adapter\\com.microsoft.java.debug.plugin.jar"),
}

-- Needed for running/debugging unit tests
vim.list_extend(bundles, vim.split(vim.fn.glob(home .. "\\AppData\\Local\\nvim-data\\mason\\share\\java-test\\*.jar", 1), "\n"))

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
  -- The command that starts the language server
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-javaagent:" .. home .. "\\AppData\\Local\\nvim-data\\mason\\share\\jdtls\\lombok.jar",
    "-Xmx4g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",

    -- Eclipse jdtls location
    "-jar",
    home .. "\\AppData\\Local\\nvim-data\\mason\\share\\jdtls\\plugins\\org.eclipse.equinox.launcher.jar",
    "-configuration",
    home .. "\\AppData\\Local\\nvim-data\\mason\\share\\jdtls\\config",
    "-data",
    workspace_dir,
  },

  -- Root directory of project
  root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "pom.xml", "build.gradle" }),

  -- Java-specific settings
  settings = {
    java = {
      -- C:\Program Files\Microsoft\jdk-21.0.6.7-hotspot\bin
      home = "C:\\Program Files\\Microsoft\\jdk-21.0.6.7-hotspot",
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = "interactive",
        runtimes = {
          {
            name = "JavaSE-17",
            path = "C:\\Program Files\\Eclipse Adoptium\\jdk-17.0.14.7-hotspot",
          },
          {
            name = "JavaSE-21",
            path = "C:\\Program Files\\Microsoft\\jdk-21.0.6.7-hotspot",
          }
        },
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      signatureHelp = { enabled = true },
      format = {
        enabled = true,
      },
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*",
        },
        importOrder = {
          "java",
          "javax",
          "com",
          "org",
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        useBlocks = true,
      },
    },
  },
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  flags = {
    allow_incremental_sync = true,
  },
  init_options = {
    bundles = bundles,
    extendedClientCapabilities = jdtls.extendedClientCapabilities,
  },
}

config["on_attach"] = function(client, bufnr)
  jdtls.setup_dap({ hotcodereplace = "auto" })
  require("jdtls.dap").setup_dap_main_class_configs()
  require("jdtls.setup").find_root({ ".git", "mvnw", "pom.xml", "build.gradle" })
end

jdtls.start_or_attach(config)
