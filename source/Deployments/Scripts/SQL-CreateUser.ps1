Param(
	$SqlSrv,
    $Database,
    $sqlLogin,
    $sqlPass,	
	$ServicePrinciple
)

$SqlSrv             = 'dw-sqlsrv'
$Database           = 'trainingDW'
$sqlLogin           = 'sqladmin3ao47ptq2muzu'
$sqlPass            = 'Password1234!@#$'	
$ServicePrinciple   = 'SIOBotApp'


$params = @{
    'Database' = $Database
    'ServerInstance' = $SqlSrv + ".database.usgovcloudapi.net"
    'Username' = $sqlLogin
    'Password' = $sqlPass
    'OutputSqlErrors' = $true
    'Query' = "CREATE USER [$ServicePrinciple] FROM  EXTERNAL PROVIDER  WITH DEFAULT_SCHEMA=[dbo]"
}
Invoke-Sqlcmd @params