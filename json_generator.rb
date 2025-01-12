require 'json'

# This object is use to generate a json when passing a block.
class JsonGenerator
  attr_accessor :options, :structure

  def initialize(options = {})
    @structure = options[:as] == :array ? [] : {}
  end

  def self.structure(options = {}, &block)
    block_instance = new(options)
    block_instance.instance_eval(&block)
    block_instance.structure
    block_instance.generate_json
  end

  # This method allows the user to add headings or keys to the structure, also if a block is passed it will handle the nested structure.
  def method_missing(heading, *args, &block)
    if block_given?
      hash_structure = self.class.new(as: :hash)
      hash_structure.instance_eval(&block)
      @structure[heading.to_s] = hash_structure.structure
    else
      @structure[heading.to_s] = args.first
    end
  end

  # rubocop was complaining about this so did a research on. passed heading as _heading to avoid the warning.
  def respond_to_missing?(_heading, _include_private = false)
    true
  end

  def children(as: :array, &block)
    array_structure = []
    @structure["children"] = array_structure
    instance_eval(&block)
  end

  def child(&block)
    child_structure = self.class.new(as: :hash)
    child_structure.instance_eval(&block)
    @structure["children"] << child_structure.structure
  end

  def generate_json
    @structure.to_json
  end
end


# Test cases for JsonGenerator

# Test 1: Simple key-value pairs
doc1_json = JsonGenerator.structure do
  title "My Document"
  body "This is the body of the document"
end

puts "Test 1: Simple key-value pairs"
puts doc1_json
puts "Expected:"
puts <<~JSON
{
  "title": "My Document",
  "body": "This is the body of the document"
}
JSON
puts "-----------------------------------"

# Test 2: Nested structure
doc2_json = JsonGenerator.structure do
  title "Parent Document"
  details do
    author "John Doe"
    date "2025-01-01"
  end
end

puts "Test 2: Nested structure"
puts doc2_json
puts "Expected:"
puts <<~JSON
{
  "title": "Parent Document",
  "details": {
    "author": "John Doe",
    "date": "2025-01-01"
  }
}
JSON
puts "-----------------------------------"

# Test 3: Structure with children
doc3_json = JsonGenerator.structure do
  title "My Document"
  body "This is the body of the document"
  children as: :array do
    child do
      title "Child 1"
      body "This is the body of child 1"
    end
    child do
      title "Child 2"
      body "This is the body of child 2"
    end
  end
end

puts "Test 3: Structure with children"
puts doc3_json
puts "Expected:"
puts <<~JSON
{
  "title": "My Document",
  "body": "This is the body of the document",
  "children": [
    {
      "title": "Child 1",
      "body": "This is the body of child 1"
    },
    {
      "title": "Child 2",
      "body": "This is the body of child 2"
    }
  ]
}
JSON
puts "-----------------------------------"

# Test 4: Nested children
doc4_json = JsonGenerator.structure do
  title "Root Document"
  children as: :array do
    child do
      title "Child 1"
      children as: :array do
        child do
          title "Subchild 1.1"
        end
        child do
          title "Subchild 1.2"
        end
      end
    end
    child do
      title "Child 2"
    end
  end
end

puts "Test 4: Nested children"
puts doc4_json
puts "Expected:"
puts <<~JSON
{
  "title": "Root Document",
  "children": [
    {
      "title": "Child 1",
      "children": [
        {
          "title": "Subchild 1.1"
        },
        {
          "title": "Subchild 1.2"
        }
      ]
    },
    {
      "title": "Child 2"
    }
  ]
}
JSON
puts "-----------------------------------"
