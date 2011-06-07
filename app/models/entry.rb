class Entry
  attr_reader :head, :content
  
  def initialize(node_head, node_content)
    @head = node_head
    @content = node_content
  end
  
end