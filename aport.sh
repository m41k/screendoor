#
#!/bin/bash

#Aport - Screen Door

#Pre-requisitos:
#netcat - openbsd.
#Fuser  - pacote psmisc


###########################################
#Created by Maik Alberto
#maik.alberto@hotmail.com
###########################################

#----------------Configuracao-----------#
#porta
porta=601
#arquivo comparacao palavra passe
alist=/tmp/ctemp.txt
clist=/tmp/ctemp2.txt
#tempo que sera liberado a porta segundos
tempo=600
#segundos para digitar a senha
sec=5
#palavra passe(MD5)
#pass=s3nha
pass=db2c158f319a22a8e32a4979905b2b44

#-----------------------------------------#

npid=`ps -ax | grep "\bnc -d -l -w$sec -p$porta" | cut -c 1-6`
kill -9 $npid 2>/dev/null

echo > $alist
echo > $clist

laco=1    
rodando=0 

 while [ $laco = 1 ];
  do

    fuser -sn tcp $porta
    rodando=$?


    if  [ "$rodando" -eq "1" ];
      then
       nc -d -l -w$sec -p$porta > $alist &
    fi

   tail -n 1 $alist | md5sum | cut -d " " -f1 > $clist

   grep '\b'$pass'\b' $clist
   laco=$?


  done

#############################
#Inclusao regras ipatables
#############################

iptables -I INPUT 1 -p tcp --dport 22 -j ACCEPT

echo > $alist
echo > $clist

sleep $tempo

#############################
#Remocao regras iptables
#############################

iptables -D INPUT -p tcp --dport 22 -j ACCEPT


./$0
