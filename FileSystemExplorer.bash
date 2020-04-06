#!/bin/bash

#   funkcija print() treba da ispise sadrzaj tekstualne datoteke ciji naziv korisnik unosi
#   ukoliko ta datoteka ima razvojen naziv tj. npr ale ksandar.txt smatrat ce se nepravilni jer se ne koristi takav standard u svijetu
#   koristimo naredbu file da bismo pronasli kojem tipu fajlova dati fajl pripada
#   ukoliko postoji samo jedan tip tog fajla i ako je on ASCII text tipa onda je to tekstualna datoteka 
#   ukoliko je tipa ASCII text i jos nekih tipova onda ne mozemo biti sigurni pa kazemo da to nije tekstualnog tipa
#   ukoliko je nekih drugih tipova onda sigurno nije tekstualna datoteka

print()
{
    isf=$(file ${words[1]})
    a=${words[1]}
    words=( $isf )
    b=${#words[@]}

    if [ $b -eq 3 -a ${words[1]} = "ASCII" -a ${words[2]} = "text" ]
    then
        echo "Sadrzaj tekstualne datoteke je: "
        echo
        cat $a
    elif [ $b -ge 3 -a "${words[1]}" = "cannot" -a "${words[2]}" = "open" ]
    then 
        echo "DATOTEKA ${words[0]} NE POSTOJI!!!"
    else
        echo "UPOZORENJE!!!"

        flag_print=false

        for i in `seq 1 $b`
        do
            if [ "${words[$i]}" = "ASCII" ]
            then
                flag_print=true
            fi
        done
        
        if [ $flag_print = true ]
        then
            echo "MOGUCE DA JE TEKSTUALNA DATOTEKA ALI NISMO SIGURNI."
            echo "S'OBZIROM DA NISMO SIGURNI NECEMO CITATI SADRZAJ DATOTEKE."
        else
            echo "OVO NIJE TEKSTUALNA DATOTEKA!!!"
        fi    
    fi
}

flag=true

while [ $flag = true ]
do
    echo "------------- MENI -------------"
    echo
    echo " ------------------------------ "
    echo "|- login ----------------------|"
    echo "|- where ----------------------|"
    echo "|- go putanja -----------------|"
    echo "|- create [-d] putanja --------|"
    echo "|- list [putanja] -------------|"
    echo "|- print datoteka -------------|"
    echo '|- find "tekst" datoteka ------|'
    echo "|- findDat datoteka putanja----|"
    echo "|- help -----------------------|"
    echo "|- exit -----------------------|"
    echo " ------------------------------ "

    echo
    echo "Unesite naredbu: "
    read a

    words=( $a )
    b=${#words[@]}

    echo $b

    if [ $b -eq 1 ]
    then
        if [ $a = "login" ]
        then
            echo "login"
        elif [ $a = "where" ]
        then
            echo "where"
        elif [ $a = "list" ]
        then
            echo "list one argument"
        elif [ $a = "help" ]
        then
            echo "help"
        elif [ $a = "exit" ]
        then
            echo "Dovidjenja!!!"
            exit
        else
            echo "Naredba nije definisana!!!"
        fi
    elif [ $b -eq 2 ]
    then
        if [ ${words[0]} = "go" ]
        then
            echo "go"
        elif [ ${words[0]} = "create" -a ${words[1]} = "-d" ]
        then
            echo "Naredba nije definisana!!!"
        elif [ ${words[0]} = "create" ]
        then
            echo "create"
        elif [ ${words[0]} = "list" ]
        then
            echo "list"
        elif [ ${words[0]} = "print" ]
        then
            print
            echo "print"
        else
            echo "Naredba nije definisana!!!"
        fi
    else
        if [ ${words[0]} = "create" -a ${words[1]} = "-d" ]
        then
            echo "create"
        elif [ ${words[0]} = "find" -a ${words[1]:0:1} = '"' ]
        then
            echo "find"
        elif [ ${words[0]} = "findDat" ]
        then
            echo "findDat"
        else
            echo "Naredba nije definisana!!!"
        fi
    fi
done
exit
