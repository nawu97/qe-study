##################################
# Author : cndaqiang             #
# Update : 2019-10-08            #
# Build  : 2019-04-11            #
# What   : 从QE官网下载赝UPF     #
#################################

WORKDIR=$(pwd)
Species=(h       he      li      be      b       c       n       o       f       ne      na      mg      al      si    p       s       cl      ar      k       ca      sc      ti      v       cr      mn      fe      co      ni
cu      zn      ga      ge      as      se      br      kr      rb      sr      y       zr      nb      mo
tc      ru      rh      pd      ag      cd      in      sn      sb      te      i       xe      cs      ba
la      ce      pr      nd      pm      sm      eu      gd      tb      dy      ho      er      tm      yb
lu      hf      ta      w       re      os      ir      pt      au      hg      tl      pb      bi      po
at      rn      fr      ra      ac      th      pa      u       np      pu      am      cm      bk      cf
es      fm      md      no      lr)
URL=https://www.quantum-espresso.org/pseudopotentials/ps-library
ROOTURL=https://www.quantum-espresso.org
downdir=$WORKDIR/UPF-$(date +%Y%m%d)
mkdir $downdir
for i in ${Species[@]}
do 
	cd $downdir
	rm -rf $i
	wget $URL/$i -O $i
	PSL=$downdir/${i}-psl
	rm -rf $PSL
	mkdir $PSL
	for j in $(grep UPF $i | awk -F \" '{ print $6 }')
	do
		cd $PSL
		wget $ROOTURL/$j & 
	done
	wait
	#sleep 5
done