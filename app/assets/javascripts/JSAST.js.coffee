class JSAST
  constructor: (@code)->
    @ast = UglifyJS.parse(code)
    @indent = 0

    @call_arr = null

  output: ->
    # return JSON.stringify @ast
    return @get_string(@ast).join("\n")

  calls: (function_name)=>
    @call_arr ||= @__get_calls_tree(@ast)
    re = []
    for child in @call_arr
      re.push child[1] if child[0] == function_name
    re

  method_calls: (object_name, function_name)->
    @calls function_name

  __get_calls_tree: (tree)->
    re = []

    if @is_kind tree, 'call'
      arr = (@get_string child for child in tree[2])
      re = re.concat [[@get_string(tree[1]), arr]]

    if @has_subtree_in tree
      for child in tree
        if typeof(child) == 'object'
          re = re.concat @__get_calls_tree(child)

    re

  get_string: (tree)->
    # return 'ERROR...ERROR' if tree == undefined
    return '' if tree == null

    return switch tree[0]
      when 'num', 'name'   then tree[1]
      when 'string'        then JSON.stringify tree[1]

      when 'stat'          then @get_string(tree[1]) + ";\n"
      
      when 'return'        then @_return tree
      when 'break'         then @_break tree
      when 'continue'      then @_continue tree
      when 'throw'         then @_throw tree

      when 'binary'        then @_binary tree

      when 'dot'           then @_dot tree
      when 'call'          then @_call tree 
      
      when 'array'         then @_array tree

      when 'if'            then @_if tree
      when 'for'           then @_for tree
      when 'for-in'        then @_for_in tree
      when 'while'         then @_while tree
      when 'do'            then @_do tree
      when 'switch'        then @_switch tree

      when 'try'           then @_try tree
      
      when 'toplevel'      then @get_string_toplevel tree
      when 'object'        then @get_string_object tree
      when 'new'           then @get_string_new tree
      when 'assign'        then @get_string_assign tree
      when 'var'           then @get_string_var tree
      when 'defun'         then @get_string_defun tree
      when 'function'      then @get_string_function tree
      when 'block'         then @get_string_block tree
      when 'sub'           then @get_string_sub tree # arr[i]
      when 'with'          then @get_string_with tree
      when 'regexp'        then @get_string_regexp tree
      when 'seq'           then @get_string_seq tree
      when 'label'         then @get_string_label tree
      when 'const'         then @get_string_const tree
      when 'directive'     then @get_string_directive tree
      when 'unary-prefix'  then @get_string_unary_prefix tree
      when 'unary-postfix' then @get_string_unary_postfix tree
      when 'conditional'   then @get_string_conditional tree
      else
        # JSON.stringify tree
        'ERROR...ERROR'

  _return: (tree)->
    @__1 tree

  _break: (tree)->
    @__1 tree

  _continue: (tree)->
    @__1 tree

  _throw: (tree)->
    @__1 tree

  __1: (tree)->
    p0 = tree[0]
    p1 = 
      if tree[1]
        " " + @get_string tree[1]
      else
        ""
    p2 = ";\n"
    p0 + p1 + p2


  _binary: (tree)->
    "#{@get_string tree[2]} #{tree[1]} #{@get_string tree[3]}"

  _dot: (tree)->
    "#{@__2 tree[1]}.#{tree[2]}"

  _call: (tree)->
    "#{@__2 tree[1]}#{@_get_string_params tree[2]}"

  __2: (tree)->
    if @is_kind(tree, 'dot') || !@has_subtree_in(tree)
      return @get_string tree
    return "(#{@get_string tree})"


  _array: (tree)->
    "[" + (@get_string child for child in tree[1]).join(', ') + "]"

  _if: (tree)->
    p1 = "if (#{@get_string tree[1]}) "
    p2 = @__3 tree[2]

    return p1 + p2 if !tree[3]

    p3 = "else "
    p4 = @__3 tree[3]

    return p1 + p2 + p3 + p4

  _for: (tree)->
    p1 = "for ("
    p2 = (@get_string(tree[1]) + "; ").replace(/;; $/, "; ")
    p3 = (@get_string(tree[2]) + "; ").replace(/;; $/, "; ")
    p4 =  @get_string(tree[3])
    p5 = ") "
    p6 = @__3 tree[4]
    
    return p1 + p2 + p3 + p4 + p5 + p6

  _for_in: (tree)->
    p1 = "for ("
    p2 = (@get_string(tree[1]) + " in ").replace("; in", " in")
    p3 =  @get_string(tree[3])
    p4 = ") "
    p5 = @__3 tree[4]

    return p1 + p2 + p3 + p4 + p5

  _while: (tree)->
    p1 = "while (#{@get_string tree[1]}) "
    p2 = @__3 tree[2]
    return p1 + p2

  _do: (tree)->
    p1 = "do "
    p2 = @__3 tree[2]
    p3 = "while (#{@get_string tree[1]})"
    return p1 + p2 + p3

  _switch: (tree)->
    __case = (tree)=>
      p1 =
        if tree[0] == null
          "default: "
        else
          "case #{@get_string tree[0]}: "
      p2 = (@__3 child for child in tree[1]).join('')
      p1 + p2

    __cases = (tree)=>
      p1 = "{\n"
      p2 = @indent_block => 
        ( 
          @get_indent_string() + 
          __case(child) + 
          "\n" for child in tree
        ).join('')
      p3 = @get_indent_string() + "}"
      p1 + p2 + p3

    "switch (#{@get_string tree[1]}) #{__cases tree[2]}" 

  __3: (tree)->
    if (@is_kind tree, 'block') || (@is_kind tree, 'if')
      @get_string tree
    else
      @indent_block =>
        "\n" + @get_indent_string() + @get_string(tree) 

  _try: (tree)->
    p0 = "try "
    p1 = @_get_string_try_block tree[1]
    p2 = ''
    p3 = ''

    if tree[2]
      p2 = " catch(#{tree[2][0]}) #{@_get_string_try_block tree[2][1]}"

    if tree[3]
      p3 = " finally #{@_get_string_try_block tree[3]}"

    p0 + p1 + p2 + p3

  _get_string_try_block: (tree)->
    p1 = "{\n"
    p2 = @indent_block => 
      ( 
        @get_indent_string() + 
        @get_string(child) + 
        "\n" for child in tree
      ).join('')
    p3 = @get_indent_string() + "}"

    return p1 + p2 + p3

# --------------

  get_string_toplevel: (tree)->
    re = []
    for subtree in tree[1]
      str = @get_string subtree
      re.push str if str != ''

    return re

  _get_string_params: (tree)->
    params = (@get_string subtree for subtree in tree)
    "(#{params.join(', ')})"

  get_string_function: (tree)->
    @get_string_defun(tree)

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
    @get_indent_string() + "} "


  get_string_object: (tree)->
    # return JSON.stringify tree

    lines = []
    @indent_block =>
      for subtree in tree[1]
        lines.push @get_indent_string() + JSON.stringify(subtree[0]) + ": " + @get_string(subtree[1])

    if lines.length == 0
      return "{}"

    return "{\n#{lines.join(",\n")}\n#{@get_indent_string()}}"

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

  get_string_directive: (tree)->
    return JSON.stringify tree[1]

  get_string_with: (tree)->
    return "with (#{@get_string tree[1]}) #{@get_string tree[2]}"

  get_string_regexp: (tree)->
    exp = tree[1]
    p = tree[2]

    "/" + exp + "/" + p

  get_string_seq: (tree)->
    vars = (@get_string subtree for subtree in tree[1...tree.length])

    return vars.join(", ")

  get_string_label: (tree)->
    tree[1] + ": " + @get_string(tree[2])



  has_subtree_in: (tree)->
    try
      for child in tree
        return true if typeof(child) == 'object'
      return false
    catch e
      return false

  is_kind: (tree, kind)->
    try
      tree[0] == kind
    catch e
      return false

  get_indent_string: ->
    re = ('  ' for i in [0...@indent])
    re.join('')

  indent_block: (func)->
    @indent++
    re = func()
    @indent--
    return re

window.JSAST = JSAST