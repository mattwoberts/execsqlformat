require 'net/http'
require 'uri'
require 'sinatra'
require_relative 'sql_parser'


get '/' do
  @formatted_sql = ''
  erb :index
end

post '/doit' do

  sql_statement = %{exec sp_executesql N'
  DECLARE @UserPermittedCompanies TABLE ( companyid varchar(10) primary key);

  INSERT INTO @UserPermittedCompanies (companyid) SELECT companies.companyid FROM companies WHERE  companies.companyid IN 
  	(SELECT DISTINCT companygroupscompanies.companyid FROM companygroupstree, companygroupscompanies, configcodescompanygroups WHERE companygroupstree.relcompgroupid = companygroupscompanies.compgroupid							                       AND companygroupstree.rellevel >= 0							                       AND companygroupstree.compgroupid = configcodescompanygroups.compgroupid							                       AND configcodescompanygroups.configcode = ''coursemanagerdemo''							                     UNION							                    SELECT DISTINCT configcodescompanies.companyid							                      FROM configcodescompanies							                     WHERE configcodescompanies.configcode = ''coursemanagerdemo'')
  	',N'@mappedidtype0 int,@mappedidtype1 int,@today2 datetime2(7),@today3 datetime2(7),@today4 datetime2(7),@today5 datetime2(7),@mappedidtype6 int,@mappedidtype7 int,@attnamesubstring8 nvarchar(8),@lastparsed9 datetime2(7),@triggerstatusname10 nvarchar(15),@substringstart11 int,@mappedidtype12 int,@mappedidtype13 int,@mappedidtype14 int,@today15 datetime2(7),@mappedidtype16 int,@mappedidtype17 int,@mappedidtype18 int,@today19 datetime2(7)',@mappedidtype0=12,@mappedidtype1=16,@today2='2011-12-07 14:32:14.3737259',@today3='2011-12-07 14:32:14.3737259',@today4='2011-12-07 14:32:14.3737259',@today5='2011-12-07 14:32:14.3737259',@mappedidtype6=12,@mappedidtype7=16,@attnamesubstring8=N'STATUS~%',@lastparsed9='2011-12-01 10:00:00',@triggerstatusname10=N'triggerstatuses',@substringstart11=8,@mappedidtype12=12,@mappedidtype13=12,@mappedidtype14=16,@today15='2011-12-07 14:32:14.3747259',@mappedidtype16=12,@mappedidtype17=12,@mappedidtype18=16,@today19='2011-12-07 14:32:14.3747259'
  	}
	
  sql_statement = request['sql_to_format']

  parser = SqlParser.new(sql_statement)
  new_sql = parser.parse()

  new_sql = new_sql.gsub(/ /,'&nbsp;')
  new_sql = new_sql.gsub(/\n/,'<br/>')
  
  @formatted_sql = new_sql
  @orig_sql = sql_statement

  erb :index

end
