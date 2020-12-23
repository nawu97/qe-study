#!/bin/sh
# reminder: from now on, what follows the character # is a comment


# delete the si.etot_vs_ecut if it exists
rm -f si.etot_vs_ecut

# loop over ecutwfc value
for ecut in 12 16 20 24 28 32
do
    echo "Running for ecutwfc = $ecut ..."

    # self-consistent calculation
    cat > pw.si.scf.in << EOF
 &CONTROL
    prefix='silicon',
 /
 &SYSTEM    
    ibrav =  2, 
    celldm(1) = 10.2, 
    nat =  2, 
    ntyp = 1,
    ecutwfc = $ecut, 
 /
 &ELECTRONS
 /
ATOMIC_SPECIES
   Si  28.086  Si.pz-vbc.UPF
ATOMIC_POSITIONS
   Si 0.00 0.00 0.00 
   Si 0.25 0.25 0.25 
K_POINTS automatic
   4 4 4   1 1 1
EOF

    # run the pw.x calculation
    pw.x -in pw.si.scf.in > pw.si.scf.out

    # collect the ecutwfc and total-energy from the pw.si.scf.out output-file
    
    grep -e 'kinetic-energy cutoff' -e ! pw.si.scf.out | \
        awk '/kinetic-energy/ {ecut=$(NF-1)}
             /!/              {print ecut, $(NF-1)}' >> si.etot_vs_ecut

done

# plot the result

gnuplot plot.gp
