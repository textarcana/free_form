# form_for will now automatically create label elements for fields.
# Additionally, fields, labels and submit buttons will automatically be wrapped LI tags.
# See <http://onrails.org/articles/2008/06/13/advanced-rails-studio-custom-form-builder>
class  Arcane::AccessibleForms::CustomFormBuilder < ActionView::Helpers::FormBuilder
  
  helpers = field_helpers + 
            %w{date_select datetime_select time_select} +
            %w{collection_select select country_select time_zone_select} -
            %w{hidden_field label fields_for} # Don't decorate these

  helpers.each do |name|
    define_method(name) do |field, *args|
      options = args.last.is_a?(Hash) ? args.pop : {}
      label = label(field, options[:label], :class => options[:label_class])
      # Don't pass the label option to content_tag or it will create a 'label' attribute on the input field.
      options.delete(:label);
      @template.content_tag(:li, label) + "\n" + @template.content_tag(:li, super, :class => options[:class])
    end
  end

  define_method(:submit) do |*args|2
    options = args.last.is_a?(Hash) ? args.pop : {}
    @template.content_tag(:li, super)
  end

  define_method(:label) do |*args|
    options = args.last.is_a?(Hash) ? args.pop : {}
    # Label gets wrapped in an LI above
    # @template.content_tag(:strong, super)
    super
  end
  
  #include ActionView::Helpers::FormOptionsHelper
  
      def publishers_select_from_collection(field, collection)
        options = collection.collect {|p| [p.last_name, p.id]}
        options.unshift( ["Please Select", ""] )   # passing {:prompt => true} is unreliable
        select field, options
      end

      def select_from_collection(field, collection)
        options = collection.collect {|p| [p.name, p.id]}
        options.unshift( ["Please Select", ""] )   # passing {:prompt => true} is unreliable
        select field, options
      end
      
      def multiple_select_from_collection(field, collection, selected)
        options = collection.collect {|p| [p.name, p.id]}
        if selected.respond_to?(:collect)
          selection = selected.collect(&:id)
        end
        #options.unshift( ["Please Select", ""] )   # passing {:prompt => true} is unreliable
        
        select field, options, {}, { :multiple => true }
      end
      
      def multiple_select_edit_from_collection(object, field, options)
        html = ''
        html << "<li>" + "<label for='#{object.to_s}_#{field.to_s}'>" + "#{field.to_s.titleize}</label></li>"
        html << "<li>" + "<select id='#{object.to_s}_#{field.to_s}' name='#{object.to_s}[#{field.to_s}][]' multiple='multiple'>" + options + "</select>" + "</li>"
      end
      
      def select_from_array(field, collection)
        options = collection
        options.unshift( ["Please Select", ""] )   # passing {:prompt => true} is unreliable
        select field, options
      end
      
      def options_from_collection_for_select(collection, value_method, text_method, selected = nil)
        # options = collection.map do |element|
        #             [element.send(text_method), element.send(value_method)]
        #           end
        custom_options_for_select(collection, selected)
      end
      
      def custom_options_for_select(container, selected = nil)
        container = container.to_a if Hash === container

        options_for_select = container.inject([]) do |options, element|
          text, value = custom_option_text_and_value(element)
          selected_attribute = ' selected="selected"' if custom_option_value_selected?(value, selected)
          options << %(<option value="#{value.to_s}"#{selected_attribute}>#{text.to_s}</option>)
        end

        options_for_select.join("\n")
      end
      
      def custom_option_text_and_value(option)
        # Options are [text, value] pairs or strings used for both.
        if !option.is_a?(String) and option.respond_to?(:first) and option.respond_to?(:last)
          [option.first, option.last]
        else
          [option, option]
        end
      end
      
      def custom_option_value_selected?(value, selected)
        if selected.respond_to?(:include?) && !selected.is_a?(String)
          selected.include? value
        else
          value == selected
        end
      end
      
      def html_escape(s)
        s.to_s.gsub(/&/n, '&').gsub(/\"/n, '"').gsub(/>/n, '>').gsub(/</n, '<')
      end


end


      

