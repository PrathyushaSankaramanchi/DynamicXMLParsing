require_relative '../helpers/build_xml_parser'

class BuildController < ApplicationController
  
  def build  
    @items = BuildXMLParser.buildFile() 
  end
  
end