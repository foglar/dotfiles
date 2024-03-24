#!/bin/bash

red=$(tput setaf 1)
green=$(tput setaf 2)
blue=$(tput setaf 4)
reset=$(tput sgr0)

pkg_installed()
{
    local PkgIn=$1

    if pacman -Qi $PkgIn &> /dev/null
    then
        #echo "${PkgIn} is already installed..."
        return 0
    else
        #echo "${PkgIn} is not installed..."
        return 1
    fi
}

pkg_available()
{
    local PkgIn=$1

    if pacman -Si $PkgIn &> /dev/null
    then
        #echo "${PkgIn} available in arch repo..."
        return 0
    else
        #echo "${PkgIn} not available in arch repo..."
        return 1
    fi
}

chk_aurh()
{
    if pkg_installed yay
    then
        aurhlpr="yay"
    elif pkg_installed paru
    then
        aurhlpr="paru"
    fi
}

aur_available()
{
    local PkgIn=$1
    chk_aurh

    if $aurhlpr -Si $PkgIn &> /dev/null
    then
        #echo "${PkgIn} available in aur repo..."
        return 0
    else
        #echo "aur helper is not installed..."
        return 1
    fi
}

if ! pkg_installed git
    then
    echo "installing dependency git..."
    sudo pacman -S git
fi

chk_aurh

if [ -z $aurhlpr ]
    then
    echo -e "Select aur helper:\n1) yay\n2) paru"
    read -p "Enter option number : " aurinp

    case $aurinp in
    1) aurhlpr="yay" ;;
    2) aurhlpr="paru" ;;
    *) echo -e "...Invalid option selected..."
        exit 1 ;;
    esac

    echo "installing dependency $aurhlpr..."
    ./install_aur.sh $aurhlpr 2>&1
fi

install_list="${1:-'~/.local/share/packages/term-tools.lst'}"

while read pkg
do
    if [ -z $pkg ]
        then
        continue
    fi

    if pkg_installed ${pkg}
        then
        echo "skipping ${pkg}..."

    elif pkg_available ${pkg}
        then
        echo "queueing ${pkg} from arch repo..."
        pkg_arch=`echo $pkg_arch ${pkg}`

    elif aur_available ${pkg}
        then
        echo "queueing ${pkg} from aur..."
        pkg_aur=`echo $pkg_aur ${pkg}`

    else
        echo "error: unknown package ${pkg}..."
    fi
done < <( cut -d '#' -f 1 $install_list )

if [ `echo $pkg_arch | wc -w` -gt 0 ]
    then
    echo "installing $pkg_arch from arch repo..."
    sudo pacman ${use_default} -S $pkg_arch
fi

if [ `echo $pkg_aur | wc -w` -gt 0 ]
    then
    echo "installing $pkg_aur from aur..."
    $aurhlpr ${use_default} -S $pkg_aur
fi

