# main.exs
defmodule Main do
  def run do
    rex      = Dog.start("Rex")
    whiskers = Cat.start("Whiskers")

    Animal.Client.speak(rex)
    Animal.Client.speak(whiskers)

    Animal.Client.stop(rex)
    Animal.Client.stop(whiskers)
  end
end
Main.run()
