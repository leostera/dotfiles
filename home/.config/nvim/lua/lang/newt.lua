local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

parser_config.newt = {
  install_info = {
    url = "/Users/ostera/Developer/github.com/leostera/newt/tree-sitter-newt", -- Local path
    files = {"src/parser.c"},
    branch = "main",
    generate_requires_npm = false,
    requires_generate_from_grammar = true,
  },
  filetype = "newt",
}
