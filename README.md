# vue-side-nav

for the best user-experience when navigating your side, you can use a responsive side-nav.

### [Demo](https://vue-comps.github.io/vue-side-nav)


# Install

```sh
npm install --save-dev vue-side-nav vue-touch
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
<!-- silbling elements will be set to margin-left:240px for `fixed` and `is-fixed=true` -->
<container>
</container>
```
For examples see [`dev/`](dev/).

#### Props
Name | type | default | description
---:| --- | ---| ---
width | Number | 240 | width of the side-nav
fixed-screen-size | Number | 992 | Used with `fixed`. Above this size, the menu will stay opened.
not-dismissable | Boolean | false | A click on the overlay will not dismiss it
close-on-click | Boolean | false | Any click within the side-nav will close it
fixed | Boolean | false | should always show on large screens
is-opened | Boolean | false | (two-way) opens or closes the side-nav
is-fixed | Boolean | false | (two-way) true when fixed on large screen
right | Boolean | false | attach to the right side instead of the left
transition | Function | no-transition | will be called on open and close with `{el,style,cb}`.
class | vue class | ["side-nav"] | class of the `ul`
style | vue style | [] | style of the `ul`
id | String | - | id of the `ul`
opacity | Number | 0.5 | opacity of the overlay
zIndex | Number | 1000 | minimum zIndex of the overlay, cannot be lower than 100 (see [vue-overlay](https://github.com/vue-comps/vue-overlay) for specifics)

#### Events
Name |  description
 ---:| ---
before-opened | before open animation
opened | after open animation
before-closed | before close animation
closed |  after open animation
fixed | emitted when menu get fixed or unfixed on large screen. Argument is a boolean `isFixed`


# Development
Clone repository.
```sh
npm install
npm run dev
```
Browse to `http://localhost:8080/`.

## Changelog
- 1.0.0
renamed `hide-on-screen-size` to `fixed-screen-size`

- 0.3.0
renamed `not-dismissible` to `not-dismissable`. added `close-on-click`

## License
Copyright (c) 2016 Paul Pflugradt
Licensed under the MIT license.
