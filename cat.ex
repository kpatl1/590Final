defmodule Cat do
  use Animal
  @impl Animal
  def speak(state) do
    name = get_name(state)
    IO.puts("#{name} says: Meow!")
  end
end
