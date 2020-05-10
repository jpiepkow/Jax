defmodule Jax.Helper do
	def is_letter(ch) do
		Regex.match?(~r/[a-zA-Z_]/, ch)	
	end
	def is_digit(ch) do
		Regex.match?(~r/[0-9]/, ch)	
	end
	def read_number(l) do
		position = l.position
		l = Jax.Lexer.read_char(l)
		|> Jax.Helper.move_char(fn(val) -> Jax.Helper.is_digit(val) end)
		{String.slice(l.input,position..(l.position - 1)),l}	
	end
	def eat_white(l) do
		cond do
		l.ch == 0 -> l
		Regex.match?(~r/[[:space:]]/, l.ch) -> 
			l = Jax.Lexer.read_char(l)	
			Jax.Helper.eat_white(l)
		true -> l
		end
	end
	def move_char(l,func) do
		if func.(l.ch) do
			Jax.Lexer.read_char(l)	
			|> Jax.Helper.move_char(func)	
		else
			l
		end
	end
	def lookup_ident(identifier) do
		Jax.Token.resolve_keyword(identifier)
	end
	def read_identifier(l) do
		position = l.position
		l = Jax.Lexer.read_char(l)
		|> Jax.Helper.move_char(fn(val) -> Jax.Helper.is_letter(val) end)
		{String.slice(l.input,position..(l.position - 1)),l}
	end
end