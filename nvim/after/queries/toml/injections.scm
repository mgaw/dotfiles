; extends

; Inject sh highlighting for mise task strings under [tasks] table

; Multiline string value: [tasks] \n taskname = """shell command"""
(table
  (bare_key) @_table_name
  (#eq? @_table_name "tasks")
  (pair
    (string) @injection.content
    (#match? @injection.content "^\"\"\"")
    (#set! injection.language "sh")
    (#offset! @injection.content 0 3 0 -3)))

; Single-line string value: [tasks] \n taskname = "shell command"
(table
  (bare_key) @_table_name
  (#eq? @_table_name "tasks")
  (pair
    (string) @injection.content
    (#not-match? @injection.content "^\"\"\"")
    (#set! injection.language "sh")
    (#offset! @injection.content 0 1 0 -1)))

; Array of strings: [tasks] \n taskname = ["cmd1", "cmd2"]
(table
  (bare_key) @_table_name
  (#eq? @_table_name "tasks")
  (pair
    (array
      (string) @injection.content
      (#set! injection.language "sh")
      (#offset! @injection.content 0 1 0 -1))))
