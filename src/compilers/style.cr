module Mint
  class Compiler
    def _compile(node : Ast::Style) : String
      style_builder.process node
      ""
    end
  end
end
