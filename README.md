# DEPRECATED see [cerijs](https://github.com/cerijs) and [ceri-side-nav](https://github.com/ceri-comps/ceri-side-nav)


# vue-side-nav

for the best user-experience when navigating your side, you can use a responsive side-nav.

### [Demo](https://vue-comps.github.io/vue-side-nav)


# Install

```sh
npm install --save-dev vue-side-nav
// vue touch@next - not released on npm currently
npm install --save-dev git://github.com/vuejs/vue-touch.git#next

// vue@1.0
npm install --save-dev vue-side-nav@1 vue-touch@1
```
or include `build/bundle.js`.

## Usage
```coffee
# somewhere
Vue.use(require('vue-touch'))

# in your component
components:
  "side-nav": require("vue-side-nav")
# or, when using bundle.js
components:
  "side-nav": window.vueComps.sideNav
```
```html
<side-nav>
  <li>First Text<li>
</side-nav>
<!-- sibling elements will be set to margin-left:240px for `fixed` and `is-fixed=true` -->
<container>
</container>
```
For examples see [`dev/`](dev/).

### ERROR: Module build failed: SyntaxError: 'with' in strict mode
Currently [buble](https://gitlab.com/Rich-Harris/buble) is injecting `strict` mode in all processed js files. The down to ES5 compiled component contains `with`, which is forbidden in `strict` mode.
Buble is used, for example, in rollup, which is used in laravel.

If you are running in this problem, make sure to exclude this component from processing with buble.

#### Props
Name | type | default | description
---:| --- | ---| ---
width | Number | 240 | width of the side-nav
fixed-screen-size | Number | 992 | Used with `fixed`. Above this size, the menu will stay opened.
not-dismissable | Boolean | false | A click on the overlay will not dismiss it
close-on-click | Boolean | false | Any click within the side-nav will close it
fixed | Boolean | false | should always show on large screens
is-opened | Boolean | false | opens or closes the side-nav - use in conjuction with `toggled` event
right | Boolean | false | attach to the right side instead of the left
transition | Function | no-transition | will be called on open and close with `{el,style,cb}`.
class | vue class | ["side-nav"] | class of the `ul`
style | vue style | [] | style of the `ul`
id | String | - | id of the `ul`
opacity | Number | 0.5 | opacity of the overlay
z-index | Number | 1000 | minimum zIndex of the overlay, cannot be lower than 100 (see [vue-overlay](https://github.com/vue-comps/vue-overlay) for specifics)

Menu will be visibile when either is-fixed or is-opened is true.

#### Events
Name |  description
---:| ---
before-enter | will be called before open animation
after-enter |  will be called when opened
before-leave |  will be called before close animation
after-leave |  will be called when closed
fixed(isFixed:Boolean) | emitted when menu get fixed or unfixed on large screen.
toggled(isOpened:Boolean) | emitted when menu gets opened or closed.

#### Transition

You can provide a transition like this:
```js
Velocity = require("velocity-animate")

template: "<side-nav transition='moveIn'></side-nav>",
methods:{
  moveIn: function ({el,style,cb}) {
    Velocity el, "stop"
    Velocity el, style, {
      duration: 300,
      queue: false,
      easing: 'easeOutQuad',
      complete: cb
    }
  }
}
```

The background is managed by `vue-overlay`.
See [here](https://github.com/vue-comps/vue-overlay#overlayfadeelopacitycb) for an example on how to change its fading function.

## Changelog
- 2.0.0  
now compatible with vue 2.0.0  
close overlay on destroy  

- 1.1.0  
events are renamed after vue transitions  
added toggled event  

- 1.0.1  
added `z-index` prop  

- 1.0.0  
renamed `hide-on-screen-size` to `fixed-screen-size`  

- 0.3.0  
renamed `not-dismissible` to `not-dismissable`. added `close-on-click`  

# Development
Clone repository.
```sh
npm install
npm run dev
```
Browse to `http://localhost:8080/`.

## License
Copyright (c) 2016 Paul Pflugradt
Licensed under the MIT license.
