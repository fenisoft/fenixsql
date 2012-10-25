unit fsmessages;

{$mode objfpc}{$H+}

interface

resourcestring
  rsTransactionA = 'Transaction:Active';
  rsAutoCommitDD = 'Auto Commit DDL';
  rsFetchLimitD = 'Fetch limit:%d';
  rsDialectD = 'Dialect %d';
  rsStartTransaction = 'Start Transaction. [%s]';
  rsPreparing = 'Preparing...';
  rsStatementPre = 'Statement prepared. [Time :%s]';
  rsStatementAlreadyPrepared = 'Statement already prepared';
  rsErrorInPrepare = 'Error in prepare. [isc_error : %d]';
  rsErrorInParam = 'Error in parameters';
  rsExecuting = 'Executing...';
  rsStatementExecuted = 'Statement executed. [Time :%s]';
  rsFetching = 'Fetching..';
  rsDRowSFetched = '%d Row(s) Fetched. [Time :%s]';
  rsResultSetD = 'Result Set (%d)';
  rsDRowSInserte = '%d Row(s) Inserted.';
  rsDRowSUpdated = '%d Row(s) Updated.';
  rsDRowSDeleted = '%d Row(s) Deleted.';
  rsTransactionCR = 'Transaction commited retaining.';
  rsStoredProced = 'Stored procedure executed. [Time :%s]';
  rsDRowSFetched2 = '%d Row(s) Fetched.';
  rsTransactionC = 'Transaction Commited. [%s]';
  rsTransactionR = 'Transaction Rolled back. [%s]';
  rsSelectForUpd = 'Select for update.';
  rsErrorInTrans = 'Error in transaction commit. [isc_error :%d]';
  rsEmpyQuery = 'Empty Query';
  rsStartScriptS = 'Start script. [%s]';
  rsErrorStatementUnknow = 'ERROR : Statement Unknow :';
  rsScriptStopped = 'Script stopped';
  rsErrorInStatement = 'Error in statement.';
  rsDDDLSStateme = '%d DDL(s) Statement executed.';
  rsScriptExecuted = 'Script executed. [Time: %s]';
  rsErrorInTransR = 'Error in Transaction rollback. [isc_error :%d]';
  rsGeneratorSet = 'Generator Set.';
  rsErrorInExecute = 'Error in execute. [isc_error : %d]';

implementation

end.

