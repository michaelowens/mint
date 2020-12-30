module Mint
  class Parser
    syntax_error HtmlStyleExpectedClosingParentheses
    syntax_error HtmlStyleExpectedDot

    def html_style : Ast::HtmlStyle?
      start do |start_position|
        head = start do
          skip unless keyword "::"

          styles = type_id
          char '.', HtmlStyleExpectedDot if styles

          skip unless value = variable_with_dashes
          {value, styles}
        end

        skip unless head

        name, entity =
          head

        arguments =
          [] of Ast::Node

        if char! '('
          whitespace

          list(terminator: ')', separator: ',') do
            if item = expression
              arguments << item
            end
          end

          whitespace
          char ')', HtmlStyleExpectedClosingParentheses
        end

        Ast::HtmlStyle.new(
          arguments: arguments.compact,
          from: start_position,
          entity: entity,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
