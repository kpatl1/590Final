defmodule Animal.Client do
  def get_name(pid) do
    send(pid, {:get_name, self()})
    receive do name -> name end
  end

  def speak(pid) do
    send(pid, {:speak, self()})
  end

  def stop(pid) do
    send(pid, :stop)
  end
end
