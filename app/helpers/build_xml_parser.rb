require 'rubygems'
require 'nokogiri'

module BuildXMLParser
   require 'rubygems'
  require 'nokogiri'
  
  f = File.open('/drive2/AptanaWorkspace/DynamicParsingExample/doc/items.xml')
  @items = Nokogiri::XML(f)
  f.close
  
  price = Nokogiri::XML::Node.new "price", @items
  price.content = "10"
  
  @items.xpath('//items/item/manufacturer').each do |node|
    node.add_next_sibling(price)
  end
  
  file = File.open("/drive2/AptanaWorkspace/DynamicParsingExample/doc/items_modified.xml",'w')
  file.puts @items.to_xml
  file.close
    
    public   
    def BuildXMLParser.buildFile()
    return @items;
  end
  
end