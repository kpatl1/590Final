# dog.ex
defmodule Dog do
  use Animal

  @impl Animal
  def speak(state) do
    name = get_name(state)
    IO.puts("#{name} says: Woof!")
  end
end
