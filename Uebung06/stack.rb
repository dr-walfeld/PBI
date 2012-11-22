# Dieses ist unsere Ruby - Implementierung für einen Stack
# Zum Glück sind viele Stack-Funktionalitäten schon mit in die Ruby-Array Klasse
# eingebaut. Daher ist es nicht viel Arbeit, diese Implementierung zu
# vervollständigen.
class Stack

  # initialize() initalisiert ein Objekt einer Klasse und wird bei Ruby bei
  # jedem new()-Aufruf mit aufgerufen.
  # Das heißt, wenn man s = Stack.new() eintippt, wird ein neues Array erstellt
  # und in s.data gespeichert.
  def initialize ()
    @data = Array.new()
  end

  # Diese Methode soll das Element x auf dem Stack legen.
  def push(x)
    @data.push(x)
  end

  # Diese Methode soll das Element oberste Element vom Stack holen und
  # zurückgeben.
  def pop()
    # Wenn der Stack leer ist, und trotzdem pop aufgerufen wird ist das ein
    # Fehler des Programmierers. Dies teilen wir ihm mit, indem wir eine
    # Ausnahme auslösen.
    if self.empty?
      raise "stack is empty!"
    end
    return @data.pop()
  end

  # Diese Methode soll das oberste Element zurückgeben, ohne es vom Stack zu
  # holen.
  def top()
    if self.empty?
      raise "stack is empty!"
    end
    return @data.last()
    # auch hier sollte eine Exception geworfen werden, wenn der Stack leer ist.
  end

  # Diese Methode soll true liefern, falls der Stack leer ist, ansonsten false.
  def empty?
    return @data.empty?
  end

end
