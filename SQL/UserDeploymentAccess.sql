DECLARE @org_name varchar(50),@the_statement varchar(MAX),@the_finalstatement varchar(MAX)
DECLARE @begin_date varchar(10), @end_date varchar(10)
set @begin_date='2014-06-01'
set @end_date='2015-06-01'
set @the_finalstatement=''

DECLARE org_cursor CURSOR FOR 
SELECT databasename from MSCRM_CONFIG.dbo.organization where isdeleted=0
OPEN org_cursor

FETCH NEXT FROM org_cursor INTO @org_name

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT @org_name
set @the_statement = ' UNION select sub.domainname as ShortDomainName, sub.fullname AS FullName,SUO.LastAccessTime As LastAccessTime,CASE sub.IsDisabled WHEN 1 THEN 1 ELSE 0 END as Disabled
from '+@org_name+'.dbo.SystemUserbase sub
inner join MSCRM_CONFIG.dbo.SystemUserOrganizations suo ON
        suo.CrmUserId = sub.SystemUserID
inner join MSCRM_CONFIG.dbo.SystemUserAuthentication sua ON
        sua.UserId = suo.UserId
inner JOIN MSCRM_Config.dbo.Organization O ON SUO.OrganizationId=O.Id    
where LastAccessTime between '''+@begin_date+''' and '''+@end_date+''''
 
set @the_finalstatement = @the_finalstatement+@the_statement
    FETCH NEXT FROM org_cursor INTO @org_name
END 
CLOSE org_cursor
DEALLOCATE org_cursor
set @the_finalstatement='Select ShortDomainName,MAX(fullname) as FullName,MAX(LastAccessTime) as LastAccessTime,MAX(Disabled) as Disabled from ('+Substring(@the_finalstatement,8,LEN(@the_finalstatement)) + ') as T GROUP BY ShortDomainName order by FullName'
print(@the_finalstatement)
execute(@the_finalstatement)
