#!/bin/bash

DB_CREDENTIALS_FILE="/docker-entrypoint-initdb.d/.my.cnf"
DATE=$(date +%d-%m-%y)
ARGC="$@"

x=0

help() {
  echo -e "Especifica tipo de tarea (requerido) \n"
  echo -e "  --task [dump|restore] \n"
  echo -e "Especifica base a backupear (requerido) \n"
  echo -e "  --database [mi_db]\n"
  echo -e "Nombre de contenedor de base de datos (requerido) \n"
  echo -e "  --container [mi_mysql_ct] (requerido) \n"
  echo -e "Path de guardado de dump (El nombre del dump es el mismo de la base de datos especificada)\n"
  echo -e "  --path [mi/path/destino] \n"
  echo -e "Cantidad de días de retencion de dumps en numero de días \n"
  echo -e "  --remove-old [12]  \n"

}

for arg in $ARGC
do
  case $x in
      "--task" )
      TASK=$arg ;;
    "--user" )
      USER=$arg ;;
    "--database" )
      DATABASE=$arg ;;
    "--container" )
      CONTAINER=$arg ;;
    "--path" )
      DUMP_PATH=$arg ;;
    "--remove-old" )
      REMOVE=$arg;;
  esac
  x=$arg
done

if [ ! -d $DUMP_PATH ]; then
  mkdir -p $DUMP_PATH
fi

if [ "$TASK" == "dump" ]; then
  docker exec -t $CONTAINER /usr/bin/mysqldump --defaults-file=/docker-entrypoint-initdb.d/.my.cnf $DATABASE > $DUMP_PATH/$DATABASE-$DATE.sql && tar czvfP $DUMP_PATH/$DATABASE-$DATE.sql.tar.gz $DUMP_PATH/$DATABASE-$DATE.sql
  rm $DUMP_PATH/$DATABASE-$DATE.sql

  if [ ! -z $REMOVE ]; then
    find $DUMP_PATH -mtime +$REMOVE -type f -delete
  fi

elif [ "$TASK" == "restore" ]; then
  echo "Se restaura base de datos"
  #cat backup.sql | docker exec -i f91d97a62086 /usr/bin/mysql -u root --password=jsppassword jsptutorial

else
  help
fi
