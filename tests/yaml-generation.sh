set -e

MEDIAMETA=META.yaml
trap "rm -f $MEDIAMETA" EXIT

# Test YAML generation
medianame=20220318T1230
declare -a tests=(
    'abc : d"ef"'
)

for ((i = 0; i < ${#tests[@]}; i++))
do
    shortmessage="${tests[$i]}"
    # Preparser
    shortmessage="${shortmessage//\"/\\\"}"
    echo "${medianame}: \"${shortmessage}\"" > ${MEDIAMETA}
    yq -e . ${MEDIAMETA} > /dev/null
done

printf "%02d test(s) successful\n" $i
