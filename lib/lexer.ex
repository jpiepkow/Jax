defmodule Jax.Lexer do
  defstruct [:input, :ch, position: -1, readPosition: 0]
  def new(input) when is_binary(input) do
    l = %Jax.Lexer{
      input: input
    }
    Jax.Lexer.read_char(l)
  end
  def check_for_end(l) do
    if l.readPosition >= String.length(l.input) do
      0
      else
      String.at(l.input,l.readPosition)
    end
  end
  def peek_char(l) do
    if l.readPosition >= String.length(l.input) do
      0
    else
      String.at(l.input,l.readPosition)
    end
  end
  def read_char(l) do
    orig_pos = l.readPosition
    %Jax.Lexer{l | ch: check_for_end(l),position: orig_pos, readPosition: (orig_pos + 1)}
  end
  def next_token(l) do
    l = Jax.Helper.eat_white(l)
    tokens = Jax.Token.get_tokens();
    case l.ch do
      "=" -> 
        if Jax.Lexer.peek_char(l) == "=" do
          l = Jax.Lexer.read_char(l)
          Jax.Token.new_token(tokens[:"EQ"], l, "==")
        else
          Jax.Token.new_token(tokens[:"ASSIGN"], l)
        end
        
      ";" -> Jax.Token.new_token(tokens[:"SEMICOLON"], l)
      "(" -> Jax.Token.new_token(tokens[:"LPAREN"], l)
      ")" -> Jax.Token.new_token(tokens[:"RPAREN"], l)
      "," -> Jax.Token.new_token(tokens[:"COMMA"], l)
      "+" -> Jax.Token.new_token(tokens[:"PLUS"], l)
      "{" -> Jax.Token.new_token(tokens[:"LBRACE"], l)
      "}" -> Jax.Token.new_token(tokens[:"RBRACE"], l)
      "-" -> Jax.Token.new_token(tokens[:"MINUS"], l)
      "/" -> Jax.Token.new_token(tokens[:"SLASH"], l)
      "!" ->  if Jax.Lexer.peek_char(l) == "=" do
        l = Jax.Lexer.read_char(l) 
        Jax.Token.new_token(tokens[:"NOT_EQ"],l, "!=")
      else
        Jax.Token.new_token(tokens[:"BANG"], l)
      end
      "*" -> Jax.Token.new_token(tokens[:"ASTERISK"], l)
      "<" -> Jax.Token.new_token(tokens[:"LT"], l)
      ">" -> Jax.Token.new_token(tokens[:"GT"], l)
      0 -> {%Jax.Token{
        literal: "",
        type: tokens[:"EOF"]
      },l}
      _ -> cond  do
        Jax.Helper.is_letter(l.ch) ->
          {literal,l} = Jax.Helper.read_identifier(l)
          type = Jax.Helper.lookup_ident(literal)
          {%Jax.Token{
            literal: literal,
            type: type
            },l}
        Jax.Helper.is_digit(l.ch) -> 
          {literal, l} = Jax.Helper.read_number(l)
          type = "INT"
          {%Jax.Token{
            literal: literal,
            type: type
            },l}
        true ->
          {%Jax.Token{
            literal: "",
            type: tokens[:"ILLEGAL"]
            },l}
        end
    end

  end
  def read_tokens(l,arr) do
    {token,l} = Jax.Lexer.next_token(l)
    if token.type == "EOF" do
      Enum.reverse(arr)
    else
     read_tokens(l,[token | arr])
    end
  end
end
