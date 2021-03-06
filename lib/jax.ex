defmodule Jax do

  def tokenize do
    input = """
    if (true != false) {
      true
    }
    if (5 == 10) {
      return true;
    } else {
      return false;
    }
    let five = 5;
    let ten = 10;
    let add = fn(x, y) {
      x + y;
    };

    let result = add(five, ten);
    !-/*5;
    5 < 10 > 5
    if (5 < 10) {
      return true;
    } else {
      return false;
    }
    """
    Jax.Lexer.new(input)
    |> Jax.Lexer.read_tokens([])
  end
  def repl(arr) do
    IO.puts(">>")
    line = IO.read(:stdio, :line)
    tokens = Jax.Lexer.new(line) |> Jax.Lexer.read_tokens([])
    Jax.repl(arr ++ tokens)
  end
  def repl do
    IO.puts(">>")
    line = IO.read(:stdio, :line)
    tokens = Jax.Lexer.new(line)
      |> Jax.Lexer.read_tokens([])
    Jax.repl(tokens)
  end
end
