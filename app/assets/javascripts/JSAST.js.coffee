class JSAST
  constructor: (@code)->
    @ast = UglifyJS.parse(code)
    @indent = 0

  output: ->
    # return JSON.stringify @ast
    return @get_string(@ast).join("\n")

  get_string: (tree)->
    return '' if tree == null
    
    first = tree[0]
    
    return tree[1] if first == 'num'
    return tree[1] if first == 'name'
    return JSON.stringify(tree[1]) if first == 'string'

    return @get_string(tree[1]) + ";" if first == 'stat'

    return @get_string_toplevel(tree) if first == 'toplevel'
    return @get_string_object(tree)   if first == 'object'
    return @get_string_call(tree)     if first == 'call'
    return @get_string_binary(tree)   if first == 'binary'
    return @get_string_array(tree)    if first == 'array'
    return @get_string_new(tree)      if first == 'new'
    return @get_string_assign(tree)   if first == 'assign'
    return @get_string_var(tree)      if first == 'var'
    return @get_string_defun(tree)    if first == 'defun'
    return @get_string_return(tree)   if first == 'return'
    return @get_string_function(tree) if first == 'function'
    return @get_string_if(tree)       if first == 'if'
    return @get_string_dot(tree)      if first == 'dot'
    return @get_string_block(tree)    if first == 'block'
    return @get_string_for(tree)      if first == 'for'
    return @get_string_for_in(tree)   if first == 'for-in'
    return @get_string_sub(tree)      if first == 'sub'
    return @get_string_with(tree)     if first == 'with'
    return @get_string_try(tree)      if first == 'try'
    return @get_string_throw(tree)    if first == 'throw'
    return @get_string_break(tree)    if first == 'break'
    return @get_string_continue(tree) if first == 'continue'
    return @get_string_switch(tree)   if first == 'switch'
    return @get_string_do(tree)       if first == 'do'
    return @get_string_while(tree)    if first == 'while'
    return @get_string_regexp(tree)   if first == 'regexp'
    return @get_string_seq(tree)      if first == 'seq'
    return @get_string_label(tree)    if first == 'label'
    return @get_string_const(tree)    if first == 'const'
    return @get_string_directive(tree) if first == 'directive'
    return @get_string_directive(tree) if first == 'directive'
    return @get_string_unary_prefix(tree) if first == 'unary-prefix'
    return @get_string_unary_postfix(tree) if first == 'unary-postfix'
    return @get_string_conditional(tree) if first == 'conditional'

    return JSON.stringify tree
    # return 'ERROR...ERROR'

  get_string_toplevel: (tree)->
    re = []
    for subtree in tree[1]
      str = @get_string subtree
      re.push str if str != ''

    return re

  get_string_call: (tree)->
    # return JSON.stringify tree

    if tree[1][0] == 'function' || tree[1][0] == 'binary' || tree[1][0] == 'object'
      return "(" + @get_string(tree[1]) + ")" + @_get_string_params(tree[2])

    @get_string(tree[1]) + @_get_string_params(tree[2])

  _get_string_params: (tree)->
    params = (@get_string subtree for subtree in tree)
    "(#{params.join(', ')})"

  get_string_array: (tree)->
    arr = (@get_string subtree for subtree in tree[1])
    "[#{arr.join(', ')}]"

  get_string_dot: (tree)->
    if tree[1][0] == 'binary'
      return "(#{@get_string tree[1]}).#{tree[2]}"

    "#{@get_string tree[1]}.#{tree[2]}"

  get_string_function: (tree)->
    @get_string_defun(tree)

  get_string_binary: (tree)->
    "#{@get_string tree[2]} #{tree[1]} #{@get_string tree[3]}"

  get_string_new: (tree)->
    return "new #{@get_string tree[1]}" + @_get_string_params(tree[2])

  get_string_assign: (tree)->
    return "#{@get_string(tree[2])} = #{@get_string(tree[3])}"

  get_string_var: (tree)->
    # return JSON.stringify tree

    vars = []
    for subtree in tree[1]
      varname = subtree[0]
      if subtree[1]
        vars.push "#{varname} = #{@get_string(subtree[1])}"
      else
        vars.push varname

    return "var #{vars.join(', ')};"

  get_string_const: (tree)->
    vars = []
    for subtree in tree[1]
      varname = subtree[0]
      if subtree[1]
        vars.push "#{varname} = #{@get_string(subtree[1])}"
      else
        vars.push varname

    return "const #{vars.join(', ')};\n"

  get_string_defun: (tree)->
    function_name = tree[1]

    p0 = 
      if function_name
        "function #{function_name}"
      else
        "function"

    p1 = "(" + (subtree for subtree in tree[2]).join(", ") + ")"

    p0 + p1 + " " + @_get_string_lines(tree[3])

  get_string_block: (tree)->
    return "" if !tree[1]
    @_get_string_lines tree[1]

  _get_string_lines: (tree)->
    return "{}" if !tree
    return "{}" if tree.length == 0

    lines = []
    @indent_block =>    
      for subtree in tree
        if subtree[0] == "block" && subtree.length == 1
          continue
        lines.push @get_indent_string() + @get_string(subtree) + "\n"

    "{\n" +
    lines.join('') +
    @get_indent_string() + "}"


  get_string_return: (tree)->
    "return #{@get_string tree[1]}"


  get_string_object: (tree)->
    # return JSON.stringify tree

    lines = []
    @indent_block =>
      for subtree in tree[1]
        lines.push @get_indent_string() + JSON.stringify(subtree[0]) + ": " + @get_string(subtree[1])

    if lines.length == 0
      return "{}"

    return "{\n#{lines.join(",\n")}\n#{@get_indent_string()}}"

  get_string_if: (tree)->
    p1 = "if (#{@get_string tree[1]}) "
    p2 = 
      if tree[2][0] == 'block'
        @get_string(tree[2])
      else
        @indent_block =>
          "\n" + @get_indent_string() + @get_string(tree[2]) + "\n" 

    return p1 + p2 if !tree[3]

    p3 = " else "
    p4 = @get_string(tree[3])
    return p1 + p2 + p3 + p4

  get_string_for: (tree)->
    p1 = "for ("
    p2 = (@get_string(tree[1]) + "; ").replace(";;", ";")
    p3 = @get_string(tree[2]) + "; "
    p4 = @get_string(tree[3])
    p5 = ") "

    p6 = 
      if tree[4][0] == 'block'
        @get_string(tree[4])
      else
        @indent_block =>
          "\n" + @get_indent_string() + @get_string(tree[4]) + "\n" 
    
    # p6 = JSON.stringify tree[4]

    return p1 + p2 + p3 + p4 + p5 + p6

  get_string_for_in: (tree)->
    p1 = "for ("
    p2 = (@get_string(tree[1]) + " in ").replace(";", "")
    p3 = @get_string(tree[3])
    p4 = ") "
    p5 = @get_string(tree[4])

    return p1 + p2 + p3 + p4 + p5

  get_string_unary_prefix: (tree)->
    return tree[1] + " " + @get_string(tree[2])

  get_string_unary_postfix: (tree)->
    return @get_string(tree[2]) + " " + tree[1]

  get_string_conditional: (tree)->
    con = @get_string(tree[1])
    r1 =
      if tree[2][0] == 'seq'
        "(" + @get_string(tree[2]) + ")"
      else
        @get_string(tree[2])

    r2 = 
      if tree[3][0] == 'seq'
        "(" + @get_string(tree[3]) + ")"
      else
        @get_string(tree[3])

    return "#{con} ? #{r1} : #{r2}"

  get_string_sub: (tree)->
    return "#{@get_string tree[1]}[#{@get_string tree[2]}]"

  get_string_try: (tree)->
    trystr = @_get_string_try_block tree[1]
    catchstr = ''
    finallystr = ''

    if tree[2]
      catchstr = " catch(#{tree[2][0]}) #{@_get_string_try_block tree[2][1]}"

    if tree[3]
      finallystr = " finally #{@_get_string_try_block tree[3]}"

    return "try #{trystr}#{catchstr}#{finallystr}"

  _get_string_try_block: (tree)->
    p1 = "{\n"
    lines = []
    @indent_block =>
      for subtree in tree
        lines.push @get_indent_string() + @get_string(subtree) + "\n"
    p3 = @get_indent_string() + "}"

    return p1 + lines.join("") + p3

  get_string_directive: (tree)->
    return "\"#{tree[1]}\""

  get_string_throw: (tree)->
    return "throw " + @get_string(tree[1])

  get_string_with: (tree)->
    return "with (#{@get_string tree[1]}) #{@get_string tree[2]}"

  get_string_break: (tree)->
    return "break"

  get_string_continue: (tree)->
    return "continue"

  get_string_switch: (tree)->
    return "switch (#{@get_string tree[1]}) " + @_get_string_cases(tree[2])

  _get_string_cases: (tree)->
    # return JSON.stringify tree

    p1 = "{\n"
    lines = []
    @indent_block =>
      for subtree in tree
        lines.push @get_indent_string() + @_get_string_case(subtree) + "\n"
    p2 = @get_indent_string() + "}"

    return p1 + lines.join("") + p2

  _get_string_case: (tree)->
    # return JSON.stringify tree
    p1 =
      if tree[0] == null
        "default:\n"
      else
        "case #{@get_string tree[0]}:\n"

    lines = []
    @indent_block =>    
      for subtree in tree[1]
        lines.push @get_indent_string() + @get_string(subtree)

    p1 + lines.join("\n")

  get_string_do: (tree)->
    p1 = "do "
    p2 = @get_string tree[2]
    p3 = " while (#{@get_string tree[1]})"
    return p1 + p2 + p3

  get_string_while: (tree)->
    p1 = "while (#{@get_string tree[1]}) "
    p2 = @get_string tree[2]
    return p1 + p2

  get_string_regexp: (tree)->
    exp = tree[1]
    p = tree[2]

    "/" + exp + "/" + p

  get_string_seq: (tree)->
    vars = (@get_string subtree for subtree in tree[1...tree.length])

    return vars.join(", ")

  get_string_label: (tree)->
    tree[1] + ": " + @get_string(tree[2])

  get_indent_string: ->
    a = ''
    for i in [0...@indent]
      a = a + '  '

    return a

  indent_block: (func)->
    @indent = @indent + 1
    re = func()
    @indent = @indent - 1
    return re

window.JSAST = JSAST