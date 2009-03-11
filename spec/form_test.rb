require File.dirname(__FILE__) + '/spec_helper'

describe 'a document' do  
  
  it 'renders inline ERB strings' do
    res = test_sinatra lambda { 'INDEX' }
    res.should.equal "INDEX"
  end
  
  describe 'form' do
    class Actor
      include DataMapper::Resource
      property :id, Serial
      property :name, String
      property :age, Integer
      property :lead, TrueClass
    end
  
    it 'renders form' do
      test_sinatra lambda { form_for Actor.new, '/edit' }      
    end
    
    it 'renders form with content' do
      block = ""
      block << "<% form_for test, '/create' do %>"
      block << "<div id='content'>content</div>"
      block << "<% end %>"      
      test_sinatra block, :locals => { :test => Actor.new }
      elements("#content").first.content.should.be.equal "content"
      elements("form").first['method'].should.be.equal "post"
      elements("form").first['action'].should.be.equal "/create"
      elements("form").first['name'].should.be.equal "actor"
    end
    
    it 'renders form with automatic input fields' do
      block = ""
      block << "<% form_for test, '/create' do %>"
      block << "<%= field_for :name %>"
      block << "<%= field_for :age %>"      
      block << "<%= field_for :lead %>"            
      block << "<% end %>"
      test_sinatra block, :locals => { :test => Actor.new }   
      
      log @res   
      elements("form > input[name='actor[name]']").count.should.equal 1
      elements("form > input[name='actor[age]']").count.should.equal 1      
      elements("form > input[name='actor[lead]']").count.should.equal 1            
    end
    
  end
  
  describe 'with input type text' do
  
    it 'should render input type text with any attributes' do
      test_sinatra lambda { input(:name, :text, :value => "value", :id => 'a1', :size => '3') }    
      elements("input[type=text][value=value][size='3']").count.should.equal 1
      elements("#a1").count.should.equal 1    
    end
  
    it 'should render input type text with value' do    
      test_sinatra lambda { input(:name, :text, :value => "value")}
      elements("input[value='value']").count.should.equal 1
    end  
  
    it 'should render input text with empty value' do
      test_sinatra lambda { input(:name, :text) }
      elements("//input[@name='name'][not(@value)]").count.should.equal 1
      elements("//input[@name='name'][not(@type)]").count.should.equal 0
    end
  
    it 'should have one input "test" ' do
      test_sinatra lambda { input(:name, :text, :value => "test") }    
      elements("input[type=text][value=test]").count.should.equal 1
      elements("input[type=checkbox][value=test]").count.should.equal 0    
      elements("input[type=text][value=value]").count.should.equal 0  
      elements("input[type=text][value='']").count.should.equal 0      
    end  
  end
end