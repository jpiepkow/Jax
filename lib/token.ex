defmodule Jax.Token do
	defstruct [:type,:literal]
	def resolve_keyword(keyword) do
		keywords = %{
			"fn" => "FUNCTION",
			"let" => "LET",
			"true" => "TRUE",
			"false" => "FALSE",
			"if" => "IF",
			"else" => "ELSE",
			"return" => "RETURN"
		}
		key = Map.get(keywords, keyword)
		if key do
			key
		else
			"IDENT"
		end
	end
	def get_tokens do
		%{
			ILLEGAL: "ILLEGAL",
			EOF: "EOF",
			IDENT: "IDENT",
			INT: "INT",
			ASSIGN: "ASSIGN",
			EQ: "EQ",
			NOT_EQ: "NOT_EQ",
			PLUS: "PLUS",
			COMMA: "COMMA",
			SEMICOLON: "SEMICOLON",
			LPAREN: "LPAREN",
			RPAREN: "RPAREN",
			LBRACE: "LBRACE",
			RBRACE: "RBRACE",
			FUNCTION: "FUNCTION",
			LET: "LET",
			TRUE: "TRUE",
			FALSE: "FALSE",
			IF: "IF",
			ELSE: "ELSE",
			RETURN: "RETURN",
			MINUS: "MINUS",
			BANG: "BANG",
			ASTERISK: "ASTERISK",
			SLASH: "SLASH",
			LT: "LT",
			GT: "GT"
		}
	end 
	def new_token(token_type, l, override) do
		tok = %Jax.Token{
			type: token_type,
			literal: override
		}
		{tok,Jax.Lexer.read_char(l)}	
	end
	def new_token(token_type, l) do
		tok = %Jax.Token{
			type: token_type,
			literal: l.ch
		}
		{tok,Jax.Lexer.read_char(l)}
	end
end