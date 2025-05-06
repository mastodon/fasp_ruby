module FaspBase
  class FormBuilder < ActionView::Helpers::FormBuilder
    INPUT_CLASSES = %w[px-2 py-1 border border-blue-400 text-base]

    def text_field(method, options = {})
      options[:class] = [ options[:class], INPUT_CLASSES ].compact.join(" ")
      super
    end

    def email_field(method, options = {})
      options[:class] = [ options[:class], INPUT_CLASSES ].compact.join(" ")
      super
    end

    def password_field(method, options = {})
      options[:class] = [ options[:class], INPUT_CLASSES ].compact.join(" ")
      super
    end

    def url_field(method, options = {})
      options[:class] = [ options[:class], INPUT_CLASSES ].compact.join(" ")
      super
    end
  end
end
