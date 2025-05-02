defmodule Animal do
  @callback speak(any()) :: any()

  defmacro __using__(_opts) do
    quote do
      @behaviour Animal
      defp init(name),       do: name
      defp get_name(state),  do: state
      defp loop(state) do
        receive do
          {:get_name, caller} ->
            send(caller, state)
            loop(state)

          {:speak, _caller} ->
            __MODULE__.speak(state)
            loop(state)

          :stop ->
            :ok

          _other ->
            loop(state)
        end
      end

      def start(name) do
        spawn_link(fn -> loop(init(name)) end)
      end
    end
  end
end
