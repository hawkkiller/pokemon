# Pokemon

I used my [Sizzle Starter](https://github.com/hawkkiller/sizzle_starter) template to create this project.

In order to run the following dart defines should be provided:

- --dart-define=BASE_URL="..."

Core stuff:

- go_router and go_router_builder for routing
- sizzle_starter as the template
- bloc for state management

Implemented features:

- pokemon list with grid and linear representations
- pokemon details with 404 if not found
- carousel for pokemon images with support for left and right arrows and overlay

Additional features:

- Dark / Light mode
- "Adaptive" design, so that it looks good on both mobile and desktop

Interesting stuff:

- I primarily used Material 3 components, styles and colors
- I didn't use any packages for dependency injection / creation. I created simple Composition Root where I instantiate the dependencies. This gives me full control over the creation of objects, their dependencies and it is runtime-safe.
- I ćreated PokemonsScope that contains all the logic for the application. It uses bloc under the hood and manages its lifecycle. Screens depend on this scope.