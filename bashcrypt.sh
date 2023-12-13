#!/bin/bash
#description : bashcrypt is a tool to make unreadable your bash code
#Author : Jerome Eve
#date release: 12/13/2023

obsType="$1"
fileName="$2"



banner (){
    echo -e "\033[1;31msyntax :\e[0m \033[1;33m./bashcrypt\e[0m \033[1;32m<encryption> <file_name>\e[0m"
    echo -e "\033[1;31mexample :\e[0m \033[1;33m./bashcrypt\e[0m \033[1;32mencrypt file_name\e[0m"
}

# file checker
extensionFile=".sh"
pathFile=$(pwd)
TARGET_FILE=$pathFile"/"$fileName$extensionFile

if [ ! -f "$TARGET_FILE" ]
then
     banner
     echo "$fileName$extensionFile file doesnt exist"
     exit
fi


pgkIsInstall(){

    if ! which bash-obfuscate > /dev/null ;
    then
        echo "Error: bash-obfuscate is not installed."
        (apt install nodejs -y && npm install -g bash-obfuscate)
    #   exit 1
    fi

}



encryptCode(){

    echo "encrypting code"\n
    pgkIsInstall
    (bash-obfuscate $TARGET_FILE -o $fileName"_encrypted"$extensionFile)

    (chmod +x $fileName"_encrypted"$extensionFile)
    echo -e "#!/bin/bash\n#description : bashcrypt is a tool to make unreadable your bash code\n#Author : Jerome Eve\n\n$(cat $fileName"_encrypted"$extensionFile)" > $fileName"_encrypted"$extensionFile

    echo -e "\033[1;33moutput file:\e[0m" "\033[1;32m"$fileName"_encrypted"$extensionFile"\e[0m"

}

decryptCode(){

    tempFile="tempFile.sh"

    echo "decrypting code"
    pgkIsInstall
    (sed  's/eval/echo/g' $TARGET_FILE > $tempFile)
    (chmod +x $tempFile;./$tempFile > $fileName"_decrypted"$extensionFile)

    (rm -r $tempFile)

    (chmod +x $fileName"_decrypted"$extensionFile)
    echo -e "#!/bin/bash\n#description : bashcrypt is a tool to make unreadable your bash code\n#Author : Jerome Eve\n\n$(cat $fileName"_decrypted"$extensionFile)" > $fileName"_decrypted"$extensionFile
    echo -e "\033[1;33moutput file:\e[0m" "\033[1;32m"$fileName"_decrypted"$extensionFile"\e[0m"

}



if [ $obsType == "encrypt" ]
then
    echo "this is encrypt"
    encryptCode
elif [ $1 == "decrypt" ]
then
     echo "this is decrypt"
     decryptCode
else
    banner
    exit
fi

