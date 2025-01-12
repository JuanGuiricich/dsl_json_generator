Instructions given by Igor:

Juan have an idea for you to practice ruby (but without AI tools, but you can use google)
implement something like (own DSL, it can allow defining ANY structure and generate JSON from it)
code:
doc = structure do
  title "My Document"
  body "This is the body of the document"
  children as: :array do
    child do
      title "Child 1"
      body "This is the body of the child"
    end
  end
end
doc.to_json =>
{
  "title": "My Document",
  "body": "This is the body of the document",
  "children": [
    {
      "title": "Child 1",
      "body": "This is the body of the child"
    }
  ]
}
or
doc = structure as: :array do
  child do
    title "Child 1"
    body "This is the body of the child"
  end
end
doc.to_json =>
[
  {
    "title": "Child 1",
    "body": "This is the body of the child"
  }
]

How to run the code:
ruby json_generator.rb

Disclaimer:
I used AI to create the test cases that are in the json_generator.rb file.

What I learned:
- What is a DSL (Domain Specific Language) and how to use it in ruby.
  Sources:
  - https://www.leighhalliday.com/creating-ruby-dsl
  - https://thoughtbot.com/blog/writing-a-domain-specific-language-in-ruby
- That method_missing is a resource in ruby that allows to create dynamic methods. It is used in various DSL or other setter methods when needed.
  Follow up question: Apart from DSL, is there a real life use for using method_missing instead of a setter method?
  Sources:
  - https://www.codewithjason.com/ruby-method-missing/
- how to use the respond_to_missing method to avoid Rubocop warnings.
  Sources:
  - https://thoughtbot.com/blog/always-define-respond-to-missing-when-overriding
  - https://ruby-doc.org/3.4.1/Object.html#method-i-respond_to_missing-3F
