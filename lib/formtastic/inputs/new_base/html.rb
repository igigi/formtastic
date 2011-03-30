module Formtastic
  module Inputs
    module NewBase
      module Html
  
        def to_html
          input_wrapping do
            label_html <<
            builder.text_field(method, input_html_options)
          end
        end
        
        def input_html_options
          opts = options[:input_html] || {}
          opts[:id] ||= input_dom_id
          
          opts
        end
        
        def input_dom_id
          options[:input_html].try(:[], :id) || dom_id
        end
        
        def error_html
          errors? ? send(:"error_#{builder.inline_errors}_html") : ""
        end
        
        def error_sentence_html
          error_class = options[:error_class] || builder.default_inline_error_class
          template.content_tag(:p, Formtastic::Util.html_safe(errors.to_sentence.html_safe), :class => error_class)
        end
                
        def error_list_html
          error_class = options[:error_class] || builder.default_error_list_class
          list_elements = []
          errors.each do |error|
            list_elements << template.content_tag(:li, Formtastic::Util.html_safe(error.html_safe))
          end
          template.content_tag(:ul, Formtastic::Util.html_safe(list_elements.join("\n")), :class => error_class)
        end
        
        def error_first_html
          error_class = options[:error_class] || builder.default_inline_error_class
          template.content_tag(:p, Formtastic::Util.html_safe(errors.first.untaint), :class => error_class)
        end
        
        def error_none_html
          ""
        end
        
        def hint_html
          if hint?
            template.content_tag(
              :p, 
              Formtastic::Util.html_safe(hint_text), 
              :class => (options[:hint_class] || builder.default_hint_class)
            )
          end
        end
        
        def dom_id
          [
            builder.custom_namespace, 
            sanitized_object_name, 
            dom_index, 
            association_primary_key || sanitized_method_name
          ].reject { |x| x.blank? }.join('_')
        end
        
        def dom_index
          if builder.options.has_key?(:index)
            builder.options[:index]
          elsif !builder.auto_index.blank?
            # TODO there's no coverage for this case, not sure how to create a scenario for it
            builder.auto_index
          else
            ""
          end
        end
        
      end
    end
  end
end
