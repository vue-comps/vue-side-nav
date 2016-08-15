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
| Name | type | default | description |
| ---:| --- | ---| --- |
| width | Number | 240 | width of the side-nav |
| hide-on-screen-size | Number | 992 | Used with `fixed`. Above this size, the menu will stay opened. |
| not-dismissible | Boolean | false | A click within the side-nav will not dismiss it |
| fixed | Boolean | false | should always show on large screens |
| is-opened | Boolean | false | (two-way) opens or closes the side-nav |
| is-fixed | Boolean | false | (two-way) true when fixed on large screen |
| right | Boolean | false | attach to the right side instead of the left |
| transition | Function | no-transition | will be called on open and close with `{el,style,cb}`. |
| class | vue class | ["side-nav"] | class of the `ul`|
| style | vue style | [] | style of the `ul`|

#### Events
| Name |  description |
| ---:| --- |
| before-opened | before open animation |
| opened | after open animation |
| before-closed | before close animation |
| closed |  after open animation |
| fixed | emitted when menu get fixed or unfixed on large screen. Argument is a boolean `isFixed` |


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
