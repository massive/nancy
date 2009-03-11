require 'sinatra/base'
require 'core_ext/string'

module Sinatra
  module Nancy
    attr_accessor :resource, :resource_name, :resource_class
    
    # add your helpers here
    def form_for(resource, action, options = {}, &block)      
      @resource = resource    
      @resource_name = @resource.class.to_s.snake_case
      @resource_class = Object.const_get(@resource.class.to_s)

      options = {:method => :post, :name => @resource_name, :action => action}.merge(options)
      @_out_buf ||= ''
      @_out_buf << open_tag(:form, options)
      yield if block_given?
      @_out_buf << close_tag(:form)
    end
    
    def open_tag(name, options = {})
      attrs = hash_to_attributes options      
      "<#{name.to_s}#{attrs}>"
    end
    
    def close_tag(name)
      "</#{name.to_s}>"
    end
    
    def content_tag(name, content, options = {})
      open_tag(name.to_s) + content + close_tag(name.to_s)
    end
    
    def empty_tag(name, options = {})
      attrs = hash_to_attributes options      
      "<#{name.to_s}#{attrs}/>"
    end
    
    def hash_to_attributes(hash)
      out = [' ']
      hash.each_pair do |key, value| 
        out << %(#{key}="#{value}")
      end
      out << ' '
      out.join(" ")
    end
    
    def input(name, type, options = {})
      options[:name] = name
      options[:type] = type
      empty_tag(:input, options)
    end

    def field_for(field, options = {})
      label = label_for(field, options)
      field_type = @resource_class.properties[field].type.to_s.downcase    
      content = self.send("field_for_#{field_type}", field, options)
      label + content
    end

    def label_for(field, options = {})
      opts = {:for => field}.merge(options)
      label = field.to_s || options[:label].humanize
      content_tag(:label, label, opts)
    end
    
    def name_for(field)
      [@resource_name, '[', field.to_s, ']'].join
    end

    def field_for_string(field, options = {})
      input(name_for(field.to_s), :text, options)
    end
    
    alias_method :field_for_integer, :field_for_string
    
    def field_for_trueclass(field, options = {})
      select_tag(field, {"Yes" => true, "No" => false}, options)
    end
    
    def select_tag(name, choices, options = {})
      start = open_tag(:select, options)
      content = []
      choices.each_pair do |key, value|
        content << content_tag(:option, key, value)
      end
      content = content.join("\n")
      stop = close_tag(:select)      
      start + content + stop
    end

    def submit_tag(name)
      options = {:type => :submit, :name => :submit, :value => name}
      empty_tag(:input, options)
    end  
  end
  
  helpers Sinatra::Nancy
end
