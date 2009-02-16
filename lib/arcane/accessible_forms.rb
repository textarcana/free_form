module Arcane
  module AccessibleForms
    def self.included(base)
      base.extend FormHelper
    end
    
    module FormHelper
#      require "custom_form_builder.rb"

#       def form_helper(options = {})
#         #options[:name] ||= :permalink
#         #options[:source] ||= :title
#         unless included_modules.include? InstanceMethods
#           class_inheritable_accessor :options
#           extend ClassMethods
#           include InstanceMethods
#         end
#         self.options = options
#       end



    end
    
    module InstanceMethods

      # Print form fields wrapped in LI tags
      # Does NOT print the enclosing UL, because we need to be able to nest arbitrary sets of fields within different FIELDSET (and therefore different UL) blocks within the same form.
      def custom_form_for(record_or_name_or_array, *args, &proc)
        options = args.extract_options!
        #form_for(record_or_name_or_array, *(args << options.merge(:builder => CustomFormBuilder)), &proc)
        form_for(record_or_name_or_array, *(args << options.merge(:builder => Arcane::AccessibleForms::CustomFormBuilder)), &proc)
      end

    end
    

    
  end
end
