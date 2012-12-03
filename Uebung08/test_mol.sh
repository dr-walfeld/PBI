#!/bin/sh
# testing the output of split_mol2.rb
# assumes that split_mol2.rb is called:
# ruby split_mol2.rb <filename> [-name|-number x [-name|number ...]]

ruby ./split_mol2.rb molecules.mol2 -number 1 -name BEN 2>err | diff mol_test1 -

ruby ./split_mol2.rb molecules.mol2 -number 6 2 2>err | diff mol_test3 -

ruby ./split_mol2.rb molecules.mol2 -name CLM PQQ 2>err | diff mol_test2 -
