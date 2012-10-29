#! /usr/bin/env ruby

# liest Basensequenz und bestimmt die absolute Zusammensetzung
# gibt [g,a,t,c] zurueck, falls reine Sequenz eingegeben wurde;
# falls andere Symbole enthalten sind oder ein Objekt falschen Typs uebergeben
# wurde, gibt die Funktion nil zurueck
def read_sequence (seq)
  g = 0
  a = 0
  t = 0
  c = 0
  # testen, ob uebergebenes Objekt einzelne Zeichen zurueckgeben kann
  if not seq.respond_to?("each_char")
    return nil
  end
  # iteration ueber alle Symbole (in Großschreibweise) und Ermittlung
  # der absoluten Haeufigkeit der Basen
  seq.each_char  do |base|
    base.upcase!
    if base == "G"
      g += 1
    elsif base == "A"
      a += 1
    elsif base == "T"
      t += 1
    elsif base == "C"
      c += 1
    else
      return nil
    end
  end
  return g,a,t,c
end

# Berechnung der Schmelztemperatur der Oligomere mit der Formel
# fuer Sequenzen <= 14 basen
def calc_short (g, a, t, c)
  t = 4.0*(g+c)+2.0*(a+t)
  return t
end

# Berechnung der Schmelztemperatur der Oligomere mit der Formel
# fuer Sequenzen > 14 basen
def calc_long (g, c, s)
  t = 64.9 + 41.0*(g+c-16.4)/s
  return t
end

if __FILE__ == $0
  # teste, ob ueberhaupt ein Parameter uebergeben wurde
  # wenn nicht: Programmabbruch mit Fehlercode 1
  if ARGV.length == 0
    puts "FEHLER: Keine Sequenz angegeben!"
    exit 1
  end

  # ermittle die Laenge und die Basenzusammensetzung der uebergebenen
  # Sequenz
  sequence = ARGV[0]
  s = sequence.length
  if s == 0
    puts "FEHLER: Es wurde eine Sequenz der Laenge 0 angegeben!"
    exit 1
  end
  
  g,a,t,c = read_sequence(sequence)
  #printf("%s\n", sequence)

  # test, ob nil zurueckgegeben wurde (d.h. die Sequenz unbekannte Symbole
  # enthaelt); Programmabbruch mit Fehlercode 2
  if a.nil?
    puts "FEHLER: Sequenz enthaelt nicht nur GATCgatc!"
    exit 2
  end
  # Ermittlung der Schmelztemperatur in Abhaengigkeit der Laenge
  if s <= 14
    puts "Verwendung der Formel fuer kurze Sequenzen!"
    tm = calc_short(g, a, t, c)
  else
    puts "Verwendung der Formel fuer lange Sequenzen!"
    tm = calc_long(g, c, s)
  end

  # Ausgabe der Schmelztemperatur
  printf("Tm = %.2f\n", tm)
end
