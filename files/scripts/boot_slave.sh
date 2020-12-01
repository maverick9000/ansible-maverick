#!/bin/bash
sourcehost=$1
datadir=/var/lib/postgresql/{{psql_version}}/main
archivedir=/var/lib/postgresql/{{psql_version}}/archive
archivedirdest=/var/lib/postgresql/{{psql_version}}/archive

#Usage
if [ "$1" = "" ] || [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ] ;
then
	echo "Usage: $0 masters ip address"
	echo
exit 0
fi

PrepareLocalServer () {

if [[ -f "/tmp/trigger_file" ]]
then
	rm /tmp/trigger_file
fi

echo "Stopping local postgresql.."
/bin/systemctl stop postgresql

if [[ -f "$datadir/recovery.done" ]];
then
	mv "$datadir"/recovery.done "$datadir"/recovery.conf
fi
}

CheckForRecoveryConfig () {
if [[ -f "$datadir/recovery.conf" ]];
    then
	echo "Slave Config File Found, Continuing"
    else
	echo "Recovery.conf not found Postgres Cannot Become a Slave, Exiting"
	exit 1
fi
}

#put master into backup mode
PutMasterIntoBackupMode () {
ssh -i /var/lib/postgresql/.ssh/id_rsa postgres@"$1" "/usr/lib/postgresql/{{psql_version}}/bin/psql -p 5432 -c \"SELECT pg_start_backup('Streaming Replication', true)\" postgres"
}

#rsync masters data to local postgres dir
RsyncWhileLive () {
rsync -C -av --delete --progress -e 'ssh -i /var/lib/postgresql/.ssh/id_rsa' --exclude recovery.conf --exclude recovery.done --exclude postmaster.pid  --exclude pg_xlog/ postgres@"$1":"$datadir"/ "$datadir"/
}

#this archives the the WAL log (ends writing to it and moves it to the $archive dir
StopBackupModeAndArchiveIntoWallLog () {
ssh -i /var/lib/postgresql/.ssh/id_rsa postgres@"$1" "/usr/lib/postgresql/{{psql_version}}/bin/psql -p 5432 -c \"SELECT pg_stop_backup()\" postgres"
}

#Execute above operations
PrepareLocalServer "$datadir"
CheckForRecoveryConfig "$datadir"
PutMasterIntoBackupMode "$1"
RsyncWhileLive "$1"
StopBackupModeAndArchiveIntoWallLog "$1" "$archivedir" "$archivedirdest"

echo "Start local postgresql"
/bin/systemctl start postgresql
