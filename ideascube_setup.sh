#!/bin/bash

ANSIBLECAP_PATH="/var/lib/ansible/local"
GIT_REPO_URL="https://github.com/bibliosansfrontieres/ideascube-deploy.git"
ANSIBLE_INSTALL_METHOD="${ANSIBLE_INSTALL_METHOD:-pip}" # pip / ppa
ANSIBLE_PIP_VERSION="${ANSIBLE_PIP_VERSION:-2.9.6}"
ANSIBLE_ETC="/etc/ansible/facts.d/"
TAGS=""
BRANCH="${BRANCH:-master}"
GIT_RELEASE_TAG="1.6.3"

[ $EUID -eq 0 ] || {
    echo "Error: you have to be root to run this script." >&2
    exit 13  # EACCES
}

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin

function internet_check()
{
    echo -n "[+] Check Internet connection..."
    if [[ ! $( ping -q -c 2 github.com ) ]]
    then
        echo "ERROR: Repository is unreachable, check your Internet connection." >&2
        exit 101  # ENETUNREACH
    fi
    echo "[+] Done."
}

function install_ansible()
{
    echo "[+] Updating APT cache..."
    internet_check
    apt-get update --quiet --quiet
    echo "[+] Install common tools..."
    apt-get install --quiet --quiet -y git lsb-release jq
    echo '[+] Done.'

    case $ANSIBLE_INSTALL_METHOD in
        "ppa") 
            install_ansible_from_ppa
            ;;
        "pip")
            install_ansible_from_pip
            ;;
        *)
            >&2 echo "Error: \$ANSIBLE_INSTALL_METHOD is invalid (${ANSIBLE_INTALL_METHOD}). Aborting."
            exit 22  #EINVAL
            ;;
    esac
}

function install_ansible_from_ppa()
{
    echo "[+] Install ansible from PPA..."
    apt-get install --quiet --quiet -y software-properties-common
    apt-add-repository --yes --update ppa:ansible/ansible
    apt-get install --quiet --quiet -y ansible
    echo '[+] Done.'
}


function install_ansible_from_pip()
{
    echo "[+] Install ansible from PIP..."
    apt-get install --quiet --quiet -y python-pip python-yaml python-jinja2 python-httplib2 python-paramiko python-pkg-resources libffi-dev libssl-dev dialog
    # shellcheck disable=SC2086
    pip install ansible==${ANSIBLE_PIP_VERSION}
    echo '[+] Done.'
}

function clone_ansiblecube()
{
    echo "[+] Checking for internet connectivity..."
    internet_check

    echo "[+] Clone ansiblecap repo..."
    mkdir --mode 0755 -p ${ANSIBLECAP_PATH}
    cd ${ANSIBLECAP_PATH}/../
    git clone ${GIT_REPO_URL} local

    mkdir --mode 0755 -p ${ANSIBLE_ETC}
    cp ${ANSIBLECAP_PATH}/hosts /etc/ansible/hosts
    echo '[+] Done.'
}

[ -x /usr/bin/ansible -a -x /usr/local/bin/ansible ] || install_ansible
[ -d ${ANSIBLECAP_PATH} ] || clone_ansiblecube

echo "$( date ) - Checking file access. Args: $*" >> /var/log/ansible-pull.log
[ $? -ne 0 ] && echo "[+] No space left to write logs or permission problem, exiting." >&2 && exit 28  # ENOSPC

while [[ $# -gt 0 ]]
do
    case $1 in
        -u|--update)

            case $2 in
                "containers")
                    TAGS="--tags pull_container"
                ;;

                "content")
                    TAGS="--tags update_content"
                ;;
            esac

        shift
        ;;

        -n|--name)

            if [ -z "$2" ]
            then
                echo -e "\n\t[+] ERROR\n\t--name : Missing device name\n" >&2

                exit 22;  # EINVAL
            fi
            PROJECT_NAME=$2

        shift
        ;;
        --extra-vars)

            if [ -n "$2" ]
            then
                EXTRA_VARS2="--extra-vars $2"
            fi

        shift
        ;;
        *)
            help
        ;;
    esac
    shift
done

echo -n "[+] Retrieve device configuration from API..."
apt-get install --quiet --quiet -y jq
result_from_api=$( curl -s "http://tincmaster.bsf-intranet.org:42685/projects?project_name=$PROJECT_NAME" |jq ".[]" )

if [ -z "$result_from_api" ]
then
  echo -e "\n[+] ERROR ==> This project name : $PROJECT_NAME does not exist\n"
  exit 19  # ENODEV
fi

echo "$result_from_api" > /etc/ansible/facts.d/device_configuration.fact

purge_switch=""
[ "$BRANCH" == "master" ] && purge_switch="--purge"

cd $ANSIBLECAP_PATH

echo "[+] Running: ansible-pull $purge_switch -C $BRANCH -d $ANSIBLECAP_PATH -i hosts -U $GIT_REPO_URL main.yml --extra-vars \"@/etc/ansible/facts.d/device_configuration.fact\" $EXTRA_VARS2 $TAGS" >> /var/lib/ansible/ansible-pull-cmd-line.sh
echo -e "\n[+] Start configuration... Follow logs : tail -f /var/log/ansible-pull.log"

# shellcheck disable=SC2086
ansible-pull $purge_switch -C $BRANCH -d $ANSIBLECAP_PATH -i hosts -U $GIT_REPO_URL main.yml --extra-vars "@/etc/ansible/facts.d/device_configuration.fact" $EXTRA_VARS2 $TAGS
