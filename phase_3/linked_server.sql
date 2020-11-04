EXEC sp_addlinkedserver   
   @server = N'DBMS',   
   @srvproduct = N'',  
   @provider = N'MSDASQL',   
   @datasrc = N'DBMS_Mysql';  
GO

EXEC sp_addlinkedsrvlogin
    'Accounts',
    'false',
    'SA',
    'anirudh',
    '';
