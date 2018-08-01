#!/bin/bash
if [ -z $1 ]
then
    echo "Передайте сему файлу 1 аргумент - .csv файл с разделителем '|' - например:"
    echo "№ |ФИО False|ФИО |Пол|Дата рождения|Месяц|Год|Телефон|e-mail|Направление, программа|Заявка|Менеджер"
    echo "3|Абдувалиев Умиджон|Абдувалиев Умиджон|MR|17.01.1908|1|1908|89262223322||Египе/ Шарм-эль-Шейх|2769|Малиновская Л."
    echo "Примечание: игнорируются колонки после 'e-mail' (их может не быть в файле) и 'месяц'
(он должен быть, но содержание не имеет значения)."
    echo "Первая строка также игнорируется"
    exit 66
fi

if ! [ -r $1 ]
then
    echo "Не могу найти файл: $1 (или он недоступен для чтения)"
    exit 66
fi

echo "Processing: $1"
cut -d "|" -f 1,2,3,4,5,6,7,9 $1 > rez1.fields.csv
# cat rez1.fields.csv
awk -F "|" -f 1be.awk rez1.fields.csv > rez2.spaces.hdr.csv
awk -F "|" -f 3parental.awk rez2.spaces.hdr.csv | sort > rez3.parental.csv
awk -F "|" -f 4dupes.awk rez3.parental.csv

# echo "**** Log ****"
# cat janus.log
