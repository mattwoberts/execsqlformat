class SqlParser

 def initialize (sql_to_parse)
   @sql_to_parse = sql_to_parse
 end

 def parse
  matches = /(exec)*\s*sp_executesql\s+N'([\s\S]*)',\s*N'(@[\s|\S]*?)',\s*([\s|\S]*)[;\z]/.match(@sql_to_parse)

  return "" unless matches != nil
  
  params = matches[3].split(',')
  new_sql = "BEGIN\n"

  params.each {|p| new_sql += "DECLARE #{p.strip};"}

  param_values = matches[4].split(',')
  new_sql += "\n"
  param_values.each {|p| new_sql += "\nSET #{p.strip};"}

  # Need to go here to format it :) http://sqlformat.appspot.com/
  result = Net::HTTP.post_form(URI.parse("http://sqlformat.appspot.com/format/"), 
  	{"data" => matches[2].to_s.gsub(/''/,"'"), "format" => "text", "keyword_case" => "upper", "reindent" => "true", "n_indents" => "2"})
	
  new_sql += "\n\n" + (result.code == 200 ? body : matches[2].to_s.gsub(/''/,"'")) + "\nEND"
   
  new_sql
   
 end

end