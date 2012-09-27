CommandLine Examples for FBLib
work only with local connection

Execute in order

createdb  
  under linux and firebird 1.5 you must be root
  then from root execute : chown firebird.firebird -R juventus.fdb 
createtable
insertrecord

These examples don't require in linux(kylix) visualclx 

with freepascal use
fpc prgname.pp -Fu<path of fblib> 

or set in fpc.cfg
-Fu<path of fblib>

ex.
fpc createdb.pp -Fu/home/alessandro/prj/fblib
