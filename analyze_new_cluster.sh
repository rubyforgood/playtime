#!/bin/sh

echo 'This script will generate minimal optimizer statistics rapidly'
echo 'so your system is usable, and then gather statistics twice more'
echo 'with increasing accuracy.  When it is done, your system will'
echo 'have the default level of optimizer statistics.'
echo

echo 'If you have used ALTER TABLE to modify the statistics target for'
echo 'any tables, you might want to remove them and restore them after'
echo 'running this script because they will delay fast statistics generation.'
echo

echo 'If you would like default statistics as quickly as possible, cancel'
echo 'this script and run:'
echo '    "/usr/local/Cellar/postgresql/10.1/bin/vacuumdb" --all --analyze-only'
echo

"/usr/local/Cellar/postgresql/10.1/bin/vacuumdb" --all --analyze-in-stages
echo

echo 'Done'
