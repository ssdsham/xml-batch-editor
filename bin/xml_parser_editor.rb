##################################################################################
# Script Name  : xml_parser_editor.rb                                            #
# Description  : Takes an input XML file then scans for the tags and 			 #
# modifies the values as specified in the Statics below							 #
# Author       : Sham Dorairaj                                                   #
# Version      : v0.0                                                            #
# Date         : 11/11/2014                                                      #
##################################################################################

###############
##  Statics  ##
###############
# For the tags which occur under the document root <Header>, use the insert_tag array

replace_tag=["AAAAaa","BBBBbb"]
replace_value=["true","true"]										# Specify exact values to replace

# The insert_tag array has list of tags and value pairs. The first value refers to the match pattern. The second value is the replacement. 
# For the tags which occur under the document root <Header>, use the insert_tag array

insert_tag=["CCCCCC"]
insert_value=["XXXXX","YYYYY"] 			# Specify [value to match, value to replace]


require "nokogiri"

fileList = Array.new


#################
##  Functions  ##
#################

Dir["../input/*.xml"].each do |s|
	fileList.push s       											# grab the file names with *.xml* extensions from the path and put into fileList array
end

fileList.each do |fileName|
	curFile=fileName.strip
	currentFile = File.open(curFile)
	file_name = fileName[/[^..\/input](.*)/]
	contents = File.read(currentFile)
	xmlnsmatch = contents[/http[^"]+/]
	doc = Nokogiri::XML(currentFile)
    xmltag1 = Array.new(replace_tag.size)
	xmltag2 = Array.new(insert_value.size)
	
	for i in 0..replace_tag.size-1
		xmltag1[i] = doc.xpath("//attr:#{replace_tag[i]}", "attr" => xmlnsmatch )[0]     # Perform a match based on XMLNS attribute and replace value of first XML tag under that root 
		xmltag1[i].content=replace_value[i]
	end
	
	for i in 0..insert_tag.size-1
		xmltag2[i] = doc.xpath("//#{insert_tag[i]}")[0]
		value = doc.xpath("//#{insert_tag[i]}")[0].text
		xmltag2[i].content=value.gsub("#{insert_value[i]}", "#{insert_value[i+1]}")      # Perform a gsub on matched string
	end
	
	
	File.open("../output/#{file_name}", 'w') { |file| file.write(doc) 	
	currentFile.close
end
	
