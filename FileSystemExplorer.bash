#!/bin/bash

#PRINT

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
        echo "Datoteka ${words[0]} ne postoji!!!"
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
            echo "Moguce da je tekstualna datoteka ali nismo sigurni."
            echo "S'obzirom da nismo sigurni necemo citati sadrzaj datoteke."
        else
            echo "Ovo nije tekstualna datoteka!!!"
        fi    
    fi
}

#FIND

# Pronalazi pattern u nekoj liniji datoteke
# naredba koja se unosi je find "teskt" datoteka
# find se tako i unosi
# "tekst" moze da ima razmaka u sebi pa smo to morali rjesavati posto smo na pocetku razbili cijeli red u rijeci
# takodje kada se unosi "teskt" unose se i znak " dva puta, pa smo i to morali rjesiti
# datoteka se naravno unosi tekstualna i za sada so samo ispitali da li uopste postoji ta datoteka ali trebamo ispitati i da li je to tekstualna 
# to ce mo izvrsiti sljedeci put ali posto ova sekvenca ispitivanja nam je potrebna vise puta mi ce mo onda napraviti posebnu funkciju za to

find_some()
{
    dokad=`expr $b - 1`
    string=""

    isf=$(file ${words[$dokad]})
    a=( $isf )
    
    if [ ${#a[@]} -ge 3 -a "${a[1]}" = "cannot" -a "${a[2]}" = "open" ]
    then 
        echo "UPOZORENJE!!!"
        echo "Datoteka ${a[0]} ne postoji!!!"
        return
    fi

    for i in `seq 1 $dokad`
    do
        if [ $i -eq 1 ]
        then
            if [ $dokad -eq 1 ]
            then
                a=`expr length ${words[$i]}`
                string="${words[$i]:1:`expr $a - 2`}"
            else
                string=${words[1]:1:`expr length ${words[1]}`}
            fi
        elif [ $i -eq $dokad ]
        then
            a=`expr length ${words[$i]}`
            string="$string ${words[$i]:0:`expr $a - 2`}"
        else
            string="$string ${words[$i]}"
        fi
    done

    dokad=`expr $b - 1`
    echo "Obrazac $string se nalazi u datoteci ${words[$dokad]} na sljedecim mjestima/mjesto: "
    echo
    sed -n "/$string/=" ${words[$dokad]}

    # za mijenjanje sadrzaja datoteke
    #(sed 's/ste/pas/g' sample1.txt) > sample2.txt
    #cat sample2.txt > sample1.txt
    #rm sample2.txt
}

flag=true

while [ $flag = true ]
do
    echo "|------------ MENI ------------|"
    echo
    echo "|------------------------------|"
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
    echo "|------------------------------|"

    echo
    read -p "Unesite naredbu: " a

    words=( $a )
    b=${#words[@]}
    echo ${words[1]:`expr length ${words[1]} - 1`:`expr length ${words[1]}`}

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
        elif [ ${words[0]} = "find" -a ${words[1]:0:1} = '"' -a ${words[1]:`expr length ${words[1]} - 1`:`expr length ${words[1]}`} = '"' ]
        then
            find_some
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
