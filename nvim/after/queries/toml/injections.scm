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

; Dotted table style: [tasks.name] \n run = """shell command"""
(table
  (dotted_key
    (bare_key) @_table_name
    (bare_key)
    (#eq? @_table_name "tasks"))
  (pair
    (bare_key) @_key_name
    (#eq? @_key_name "run")
    (string) @injection.content
    (#match? @injection.content "^\"\"\"")
    (#set! injection.language "sh")
    (#offset! @injection.content 0 3 0 -3)))

; Dotted table style: [tasks.name] \n run = "shell command"
(table
  (dotted_key
    (bare_key) @_table_name
    (bare_key)
    (#eq? @_table_name "tasks"))
  (pair
    (bare_key) @_key_name
    (#eq? @_key_name "run")
    (string) @injection.content
    (#not-match? @injection.content "^\"\"\"")
    (#set! injection.language "sh")
    (#offset! @injection.content 0 1 0 -1)))

; Dotted table style: [tasks.name] \n run = ["cmd1", "cmd2"]
(table
  (dotted_key
    (bare_key) @_table_name
    (bare_key)
    (#eq? @_table_name "tasks"))
  (pair
    (bare_key) @_key_name
    (#eq? @_key_name "run")
    (array
      (string) @injection.content
      (#set! injection.language "sh")
      (#offset! @injection.content 0 1 0 -1))))
