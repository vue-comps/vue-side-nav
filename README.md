# vue-side-nav

for the best user-experience when navigating your side, you can use a responsive side-nav.

### [See it in action](https://vue-comps.github.io/vue-side-nav)


# Install

```sh
npm install --save-dev vue-drag-handle vue-touch
```
or include `build/bundle.js`

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
see `dev/` folder for examples

#### Props
| Name | type | default | description |
| ---:| --- | ---| --- |
| width | Number | 240 | width of the side-nav |
| hide-on-screen-size | Number | 992 | Used with `fixed`. Above this size, the menu will stay opened. |
| dismissable | Boolean | true | A click within the side-nav will dismiss it |
| fixed | Boolean | false | should always show on large screens |
| isOpened | Boolean | false | can be two-way bound. opens or closes the side-nav |
| isFixedOpened | Boolean | false | can be two-way bound. true when fixed on large screen |
| side | String | "left" | `left` or `right` |
| fade | Function | no-fade | will be called on open and close with `{el,style,cb}`. |

#### Events
| Name |  description |
| ---:| --- |
| beforeOpened | before open animation |
| opened | after open animation |
| beforeClosed | before close animation |
| closed |  after open animation |
| fixed |  when menu get fixed on large screen |
| unfixed | when menu get unfixed on smaller screen |

# Development
Clone repository
```sh
npm install
npm run dev
```
Browse to `http://localhost:8080/`

## License
Copyright (c) 2016 Paul Pflugradt
Licensed under the MIT license.
