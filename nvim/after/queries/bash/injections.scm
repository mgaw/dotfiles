; extends

; Inject kdl highlighting for `#USAGE` spec comments (https://usage.jdx.dev)
((comment) @injection.content
  (#lua-match? @injection.content "^#USAGE ")
  (#set! injection.language "kdl")
  (#offset! @injection.content 0 7 0 0))
