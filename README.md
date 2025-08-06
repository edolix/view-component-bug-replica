# ViewComponent Slim Issue

To reproduce the issue clone the repo and run these commands - everything is dockerized:

```sh
./rails-dev bin/bundle
./rails-dev bin/rails db:setup

./rspec
```

I added some output logs to follow the boot process with [an initializer](config/initializers/view_component.rb) and overriding [the inherited method](app/components/application_component.rb).