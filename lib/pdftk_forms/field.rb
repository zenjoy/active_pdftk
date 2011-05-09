module PdftkForms
  # Represents a fillable form field on a particular PDF
  class Field
    
    attr_accessor :attributes
    
    def initialize(attributes)
      @attributes = attributes
    end
    
    def required?
      check_bit_true(2, 2)
    end
    
    def multiline?
      self.type == 'Text' && check_bit_true(4096, 13)
    end
    
    def push_button?
      self.type == 'Button' && check_bit_true(65536, 17)
    end
    
    def radio_button?
      self.type == 'Button' && !push_button? && check_bit_true(32768, 16)
    end
    
    def check_box?
      self.type == 'Button' && !push_button? && !radio_button?
    end
    
    def field_type
      if self.type == 'Button'
        if push_button?
          'push_button'
        elsif radio_button?
          'radio_button'
        else
          'check_box'
        end
      elsif self.type == 'Text'
        multiline? ? 'text_area' : 'text_field'
      elsif self.type == 'Choice'
        'select'
      else
        self.type.downcase
      end
    end
    
    def self.alias_attribute method_name, attribute_name
      define_method(method_name) do
        attributes[attribute_name]
      end
      define_method("#{method_name}=") do |value|
        attributes[attribute_name] = value
      end
    end
    
    alias_attribute :name,  'FieldName'
    alias_attribute :type,  'FieldType'
    alias_attribute :value, 'FieldValue'
    alias_attribute :flags, 'FieldFlags'
    alias_attribute :alt_name, 'FieldNameAlt'
    alias_attribute :options, 'FieldStateOption'
    
    private
    
    def check_bit_true(min_value, bit_position)
      self.flags.to_i >= min_value && self.flags.to_i.to_s(2)[-bit_position].chr == "1"
    end
    
  end
end
