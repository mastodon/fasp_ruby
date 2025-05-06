module FaspBase
  module ApplicationHelper
    ALERT_CLASSES = "mt-1 mb-2 rounded-sm px-4 py-2 text-gray-600 font-medium"
    ALERT_COLORS = {
      notice: "border-blue-400 bg-blue-50",
      alert: "border-red-400 bg-red-50"
    }.freeze
    BUTTON_CLASSES = "font-bold rounded-sm px-4 py-2"

    def notification(message, type: :notice)
      tag.div(message, class: "#{ALERT_CLASSES} #{ALERT_COLORS[type]}")
    end

    def page_header(&block)
      tag.h1(class: "text-2xl font-bold mt-2 mb-4", &block)
    end

    def td(&block)
      tag.td(class: "px-2 py-3", &block)
    end

    def action_link_to(*args, **kwargs)
      hover_color = delete_action?(kwargs) ? "red-400" : "blue-600"
      link_to(*args, **(kwargs.merge(class: "ml-4 font-bold text-sm hover:underline text-gray-600 hover:text-#{hover_color}")))
    end

    def button_link_to(*args, **kwargs, &block)
      link_to(*args, **(kwargs.merge(class: button_classes(kwargs))), &block)
    end

    def nav_link_to(*args, **kwargs)
      link_to(*args, **(kwargs.merge(class: "text-gray-600 font-medium px-2 py-1 rounded-sm hover:bg-blue-200 hover:text-gray-700")))
    end

    def button(type: :button, &block)
      tag.button(type:, class: button_classes, &block)
    end

    def button_classes(options = {})
      colors = "text-white bg-blue-400 hover:bg-blue-600"
      colors = "text-white bg-red-400 hover:bg-red-600" if delete_action?(options)
      "#{BUTTON_CLASSES} #{colors}"
    end

    def render_tabs(tabs, active:, scope:)
      rendered_tabs = tabs.map do |key, path|
        text = t(key, scope:)
        if key == active
          tag.span text, class: "bg-blue-100 px-4 py-2"
        else
          link_to text, send(path), class: "hover:bg-blue-50 px-4 py-2"
        end
      end
      tag.div safe_join(rendered_tabs), class: "flex gap-2 my-4 border-b border-blue-100"
    end

    private

    def delete_action?(options)
      options.dig(:data, :turbo_method).to_s == "delete"
    end
  end
end
