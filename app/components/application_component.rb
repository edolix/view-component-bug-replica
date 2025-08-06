class ApplicationComponent < ViewComponent::Base
  extend Dry::Initializer

  delegate :user_signed_in?, :current_user, :allowed_to?, :I18n, :flag?, to: :helpers

  # Add this temporarily to see what ViewComponent is looking for
  def self.inherited(subclass)
    super
    puts "Template files for #{subclass.name} => #{subclass.sidecar_files(ActionView::Template.template_handler_extensions)}"
  end

  # def self.sidecar_files(extensions)
  #   if extensions.include?("html") && !extensions.include?("slim")
  #     return super(extensions.concat([ "slim" ]))
  #   end

  #   super(extensions)
  # end
end
