ActiveSupport.on_load(:view_component) {
  puts "[NITIALIZER] view_component"
  puts "[NITIALIZER] Slim is defined!" if defined?(Slim)
  puts ActionView::Template.template_handler_extensions.inspect
  puts "[NITIALIZER] #{Time.now}"
  puts ""
}

ActiveSupport.on_load(:action_view) do
  puts "[NITIALIZER] action_view"
  puts "[NITIALIZER] Slim is defined!" if defined?(Slim)
  puts ActionView::Template.template_handler_extensions.inspect
  puts "[NITIALIZER] #{Time.now}"
  puts ""
end

ActiveSupport.on_load(:after_initialize) do
  puts "after_initialize"
  puts ActionView::Template.template_handler_extensions.inspect
  puts "after_initialize"
end

ViewComponent::Compiler.class_eval do
  alias_method :original_gather_templates, :gather_templates

  private

  def gather_templates
    puts "[gather_templates] for #{@component.name} with exts: #{ActionView::Template.template_handler_extensions.inspect}"
    puts ""

    original_gather_templates
  end
end
