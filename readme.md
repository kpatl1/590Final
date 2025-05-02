
## Key Elixir Features

**`@callback` and `@behaviour`**  
   - Defines a required interface (like a Java `abstract` method).  
   - Here, `@callback speak(any()) :: any()` declares that any “Animal” must implement `speak/1`.  
   - `@behaviour Animal` ensures at compile time that modules using it implement `speak/1`.

**Macros (`defmacro __using__` + `quote`)**  
   - Allows one module (Animal) to inject boilerplate into any consumer (`use Animal`).  
   - We share the same process loop, `init/1`, `get_name/1`, and `start/1` logic across `Dog`, `Cat`, etc., without copy-pasting.

**Processes and Message Passing**  
   - Each “object” is an independent process holding its state.  
   - State is never exposed directly; interaction happens only via messages (`{:get_name, …}`, `{:speak, …}`, `:stop`).

**Private Functions (`defp`)**  
   - Encapsulation is enforced by keeping `init/1`, `get_name/1` and the receive‐loop private to each module.

**Client API Module**  
   - `Animal.Client` wraps the message protocol in synchronous functions (`get_name/1`, `speak/1`, `stop/1`), giving a clean external interface.

---

## Mapping to Java Example

Java’s encapsulation—for example, the private String name field in the Animal class—prevents external code from accessing or mutating an object’s state directly. In our Elixir version, we achieve the same effect by keeping the animal’s name inside a dedicated process loop as private state and exposing only a defp get_name/1 function; the name lives entirely within that process and cannot be touched from the outside. Java’s abstraction is represented by an abstract void speak() method, which defines a required interface without providing an implementation. In Elixir, we declare @callback speak(any()) :: any() in the Animal module and use @behaviour Animal in each concrete module, forcing Dog and Cat to implement speak/1 while the base module enforces the contract. Java’s inheritance—the class Dog extends Animal pattern—lets subclasses share and extend base‐class logic. We replicate this in Elixir via a defmacro __using__ that injects shared functions (init/1, loop/1, start/1) into any module that does use Animal, so Dog and Cat automatically inherit the common process and message‐handling boilerplate. Finally, Java polymorphism—treating a Dog or Cat as an Animal and calling speak() on it—maps directly to Elixir’s message‐passing dispatch: client code sends the same {:speak, caller} message to any animal process, and at runtime the correct speak/1 implementation is invoked, producing the appropriate “Woof!” or “Meow!” without changing the client’s call.