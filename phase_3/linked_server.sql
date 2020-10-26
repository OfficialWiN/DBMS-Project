EXEC sp_addlinkedserver   
   @server = N'SEATTLE Payroll',   
   @srvproduct = N'',  
   @provider = N'MSDASQL',   
   @datasrc = N'LocalServer';  
GO

EXEC sp_addlinkedsrvlogin
    'Accounts',
    'false',
    'SA',
    'anirudh',
    '';