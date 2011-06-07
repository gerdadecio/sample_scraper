class PagesController < ApplicationController
  respond_to :xml
  
  def index
    data = []
    index_url = 'http://www.faa.gov/air_traffic/publications/atpubs/PCG/index.htm'
    page_url = 'http://www.faa.gov/air_traffic/publications/atpubs/PCG/'
    
    #get all nav pages
    nav = Nokogiri::HTML(open(index_url))
    nav.css('table:nth-child(3) tr:nth-child(1) a').first(2).each do |n|
      doc = Nokogiri::HTML(open(page_url+n["href"]))
      
      doc.css('p.CLASS_8 font').first(3).each_with_index do |par, i|
        data << Entry.new(par.text,doc.css('p.CLASS_7 font')[i].text)
      end
      
    end
    
    @builder = xml_build(data)

    render :xml => @builder.to_xml
  end
  
  
  private
  
  def xml_build(xml_obj)
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.node(:head => "Federal.."){
        xml.subnodes{
          xml.node(:head => "A"){
            xml.subnodes{
              xml_obj.each do |n|
                xml.node(:head => n.head){
                  xml.content{
                    xml.font_ n.content
                  }
                }
              end
            }
          }
        }
      }
    end
    return builder
  end
  
end