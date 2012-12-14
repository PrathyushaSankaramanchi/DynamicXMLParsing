require 'nokogiri'
module XMLParser
  
  class Reader
  public  
    # initialization
    def initialize(xml_path)
      @variantSubArr = Array.new
      @variantSubArrTemp = Array.new
      @variantTemp = Array.new
      @variantMainTemp = Array.new
      read(xml_path)
    end
    
    # opens and reads the xml file
      def read(xml_path)          
        @file = Nokogiri::XML(File.open(xml_path)){ |cfg| cfg.noblanks }  
      end
      
      # Method to get the xpath
      def getVariants(xpathObj)
        
        @variantArr = Array.new
        @variantArr1 = Array.new
       
        @file.xpath(xpathObj).each do |node|                    
            @variantArr = recursive_child(node) 
            if !node.next_sibling.nil? && !node.next_sibling.blank?
            recursive_child(node.next_sibling)
          end          
          return @variantArr
        end
      end 
      
      def recursive_child(node)          
          
          @nodeChildrenCount = node.children.count          
          
          if @nodeChildrenCount > 0
            @nodeChildren = node.children
            puts("@nodeChildren is #{@nodeChildren}")
            puts("@nodeChildrenCount is #{@nodeChildrenCount}")
            (0..@nodeChildrenCount-1).each { |i|
              @nodeChildrenValues = Hash.new
              
              if node.children[i].children.children.empty?
                puts("node.children[i] is #{node.children[i]}")
                name = node.children[i].name
                value = node.children[i].text
                if name == "text"
                  name = node.children[i].parent.name
                end
                puts("name is #{name}") 
                puts("value is #{value}") 
                @nodeChildrenValues[name] = value
                @variantTemp.push(@nodeChildrenValues)
              end
              
              @nodeSubChildCount = node.children[i].children.count 
              if node.children[i].children != nil && @nodeSubChildCount > 0 && !node.children[i].children.empty?
                @variantSubArr = recursive_subChild(node.children[i])                
                @variantTemp.push(@variantSubArr)
              end         
              
                #puts("@variantTemp is #{@variantTemp}")
            }
          else
            @nodeValues = {} 
          end
            
        return @variantTemp
      end
      
      def recursive_subChild(childNode)
           @variantSubArrayTemp = Array.new  
                                    
              (0..@nodeSubChildCount-1).each { |j|
                @nodeSubChildValues = Hash.new
                  if childNode.children[j].name != "text" && childNode.children[j].name != nil && !childNode.children[j].name.empty? && !childNode.children[j].children.empty? 
                    
                    if childNode.children[j].children.children.empty?
                    name1 = childNode.children[j].name
                    value1 = childNode.children[j].text 
                    if name1 == "text"
                      name1 = childNode.children[j].parent.name
                    end
                    #puts("name1 is #{name1} amd value1 is #{value1}")        
                    @nodeSubChildValues[name1] = value1 
                    
                    if !@nodeSubChildValues.empty? && !@nodeSubChildValues.blank?                 
                      @variantSubArrayTemp.push(@nodeSubChildValues)                       
                    end  
                    #puts("@variantSubArrayTemp is #{@variantSubArrayTemp}")                  
                   end
                    
                    @subNodeCount = childNode.children[j].children.count
                    if @subNodeCount > 0
                      (0..@subNodeCount-1).each { |k|
                        puts("childNode.children[j].children[k] #{childNode.children[j].children[k]}")
                        if !childNode.children[j].children[k].nil? && !childNode.children[j].children[k].blank?
                          recursive_child(childNode.children[j].children[k])                          
                        end 
                      }                               
                    end                                
                  end 
              }         
       return @variantSubArrayTemp
     end
  end
end