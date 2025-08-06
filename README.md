# ViewComponent Slim Issue

To reproduce the issue clone the repo and run these commands - everything is dockerized:

```sh
./rails-dev bin/bundle
./rails-dev bin/rails db:setup

./rspec
```

I added some output logs to follow the boot process with [an initializer](config/initializers/view_component.rb) and overriding [the inherited method](app/components/application_component.rb).


Changing `eager_load` in `config/environments/test.rb` to false will make the specs to pass successfully.

The logs shows how `view_component` and then `action_view` hooks are invoked and how ViewComponent gather templates first **without** the "slim" extension.
After `action_view` the `ActionView::Template.template_handler_extensions` array includes "slim" but the templates have already been cached or memoized within the VC compiler - causing the render to fail.

```
[INITIALIZER] view_component
[INITIALIZER] Slim is defined!
["builder", "erb", "html", "raw", "ruby"]
[INITIALIZER] 2025-08-06 13:14:15 +0000
[gather_templates] for ApplicationComponent with exts: ["builder", "erb", "html", "raw", "ruby"]

Template files for Foo => []
[gather_templates] for Foo with exts: ["builder", "erb", "html", "raw", "ruby"]

Template files for Bar => []
[INITIALIZER] action_view
[INITIALIZER] Slim is defined!
["builder", "erb", "html", "jbuilder", "raw", "ruby", "slim"]
[INITIALIZER] 2025-08-06 13:14:15 +0000

after_initialize
["builder", "erb", "html", "jbuilder", "raw", "ruby", "slim"]
after_initialize
[gather_templates] for ApplicationComponent with exts: ["builder", "erb", "html", "jbuilder", "raw", "ruby", "slim"]

[gather_templates] for Foo with exts: ["builder", "erb", "html", "jbuilder", "raw", "ruby", "slim"]

[gather_templates] for Bar with exts: ["builder", "erb", "html", "jbuilder", "raw", "ruby", "slim"]


Welcome
[gather_templates] for Foo with exts: ["builder", "erb", "html", "jbuilder", "raw", "ruby", "slim"]

  returns :success (FAILED - 1)

Failures:

  1) Welcome returns :success
     Failure/Error: = render Foo.new(text: "Hello World! #{Time.now}")

     ActionView::Template::Error:
       Couldn't find a template file or inline render method for Foo.
     # /usr/local/bundle/gems/view_component-4.0.1/lib/view_component/compiler.rb:38:in 'block in ViewComponent::Compiler#compile'
     # /usr/local/bundle/gems/view_component-4.0.1/lib/view_component/compiler.rb:26:in 'Thread::Mutex#synchronize'
     # /usr/local/bundle/gems/view_component-4.0.1/lib/view_component/compiler.rb:26:in 'ViewComponent::Compiler#compile'
     # /usr/local/bundle/gems/view_component-4.0.1/lib/view_component/base.rb:548:in 'ViewComponent::Base.__vc_compile'
     # /usr/local/bundle/gems/view_component-4.0.1/lib/view_component/base.rb:106:in 'ViewComponent::Base#render_in'
     # ./app/views/welcome/index.html.slim:2:in '_app_views_welcome_index_html_slim___2135124043409528836_10920'
     # /usr/local/bundle/gems/turbo-rails-2.0.16/lib/turbo-rails.rb:24:in 'Turbo.with_request_id'
     # /usr/local/bundle/gems/turbo-rails-2.0.16/app/controllers/concerns/turbo/request_id_tracking.rb:10:in 'Turbo::RequestIdTracking#turbo_tracking_request_id'
     # /usr/local/bundle/gems/actiontext-8.0.2/lib/action_text/rendering.rb:25:in 'ActionText::Rendering::ClassMethods#with_renderer'
     # /usr/local/bundle/gems/actiontext-8.0.2/lib/action_text/engine.rb:71:in 'block (4 levels) in <class:Engine>'
     # /usr/local/bundle/gems/railties-8.0.2/lib/rails/engine/lazy_route_set.rb:68:in 'Rails::Engine::LazyRouteSet#call'
     # /usr/local/bundle/gems/rack-3.2.0/lib/rack/tempfile_reaper.rb:20:in 'Rack::TempfileReaper#call'
     # /usr/local/bundle/gems/rack-3.2.0/lib/rack/etag.rb:29:in 'Rack::ETag#call'
     # /usr/local/bundle/gems/rack-3.2.0/lib/rack/conditional_get.rb:31:in 'Rack::ConditionalGet#call'
     # /usr/local/bundle/gems/rack-3.2.0/lib/rack/head.rb:15:in 'Rack::Head#call'
     # /usr/local/bundle/gems/rack-session-2.1.1/lib/rack/session/abstract/id.rb:274:in 'Rack::Session::Abstract::Persisted#context'
     # /usr/local/bundle/gems/rack-session-2.1.1/lib/rack/session/abstract/id.rb:268:in 'Rack::Session::Abstract::Persisted#call'
     # /usr/local/bundle/gems/railties-8.0.2/lib/rails/rack/logger.rb:41:in 'Rails::Rack::Logger#call_app'
     # /usr/local/bundle/gems/railties-8.0.2/lib/rails/rack/logger.rb:29:in 'Rails::Rack::Logger#call'
     # /usr/local/bundle/gems/rack-3.2.0/lib/rack/method_override.rb:28:in 'Rack::MethodOverride#call'
     # /usr/local/bundle/gems/rack-3.2.0/lib/rack/runtime.rb:24:in 'Rack::Runtime#call'
     # /usr/local/bundle/gems/rack-3.2.0/lib/rack/sendfile.rb:114:in 'Rack::Sendfile#call'
     # /usr/local/bundle/gems/railties-8.0.2/lib/rails/engine.rb:535:in 'Rails::Engine#call'
     # /usr/local/bundle/gems/rack-test-2.2.0/lib/rack/test.rb:360:in 'Rack::Test::Session#process_request'
     # /usr/local/bundle/gems/rack-test-2.2.0/lib/rack/test.rb:153:in 'Rack::Test::Session#request'
     # ./spec/requests/welcome_spec.rb:4:in 'block (2 levels) in <top (required)>'
     # ./spec/requests/welcome_spec.rb:7:in 'block (2 levels) in <top (required)>'
     # ------------------
     # --- Caused by: ---
     # ViewComponent::TemplateError:
     #   Couldn't find a template file or inline render method for Foo.
     #   /usr/local/bundle/gems/view_component-4.0.1/lib/view_component/compiler.rb:38:in 'block in ViewComponent::Compiler#compile'

Finished in 0.02742 seconds (files took 1.36 seconds to load)
1 example, 1 failure

Failed examples:

rspec ./spec/requests/welcome_spec.rb:6 # Welcome returns :success
```