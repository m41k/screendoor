#!/bin/bash
##########################
##########################
##########################
##########################
#g########github.com/m41k#
##########################
##
##
##
##
##
##-------Configuracao------#
#porta
 APORT=601
#porta serviço
 SPORT=8888
#arquivo comparacao palavra passe
 ALIST=/tmp/alist
 CLIST=/tmp/clist
#tempo que sera liberado a porta segundos
 STIME=10
#segundos para digitar a senha
 ATIME=5
#FLAG
 FLAG=KURUPIRA
#palavra passe(MD5)
#pass=s3nha
 SPASS=db2c158f319a22a8e32a4979905b2b44
#Chain
 CHAIN=REGRATEMP
#-----------------------------------------#

#-----------------------------------------#
#CONFIGURANDO IPTABLES
 iptables -F $CHAIN 2> /dev/null
 iptables -N $CHAIN 2> /dev/nul
 iptables -A $CHAIN -p tcp --dport $SPORT -j REJECT

#MATANDO POSSIVEL PROCESSO PERDIDO
npid=`ps -ax | grep "\bnc -d -l -w$ATIME -p$APORT" | cut -c 1-6`
kill -9 $npid 2>/dev/null

echo > $ALIST
echo > $CLIST

laco=1
rodando=0

while [ $laco = 1 ];
   do
     fuser -sn tcp $APORT
     rodando=$?
     if  [ "$rodando" -eq "1" ]; then
         nc -d -l -w$ATIME -p$APORT > $ALIST &
     fi
     tail -n 1 $ALIST | md5sum | cut -d " " -f1 > $CLIST
     grep '\b'$SPASS'\b' $CLIST
     laco=$?
  done

#############################
#INCLUSÃO REGRAS IPTABLES
#############################
 iptables -I $CHAIN 1 -p tcp --dport $SPORT -j ACCEPT

#LIMPANDO ARQUIVOS
 echo > $ALIST
 echo > $CLIST

#SIMULANDO SERVIÇO POSSIVEL VISUALIZAR NO BROWSER
#for i in $(seq $STIME); do echo $FLAG | nc -l $SPORT | sleep 1; done
 for i in $(seq $STIME); do
   #echo $i
   echo $FLAG | nc -l $SPORT -w$STIME | sleep 1;
 done

#SLEEP PARA DAEMON
 #sleep $STIME

#############################
#REMOÇÃO REGRAS IPTABLES
#############################
 iptables -D $CHAIN -p tcp --dport $SPORT -j ACCEPT

#DENOVO
 $0
