<template lang="pug">
.container
  side-nav(
    v-bind:is-opened.sync="opened"
    v-ref:side-nav
    style="border:1px solid black; background-color: white"
      )
    li First Text
  .container2(style="padding:20px")
    button(@click="toggle") Toggle
    p &lt;&lt; or drag
    a(
      href="https://github.com/vue-comps/vue-side-nav/blob/master/dev/basic.vue",
      style="position:relative;top:40px;left:200px"
      ) source
</template>

<script lang="coffee">
module.exports =
  mixins:[
    require("vue-mixins/vue")
    require("vue-mixins/setCss")
  ]
  beforeCompile: ->
    @Vue.use(require('vue-touch'))
    @setCss document.body, "margin",0
  data: ->
    opened: false
  methods:
    toggle: ->
      @opened = !@opened
  components:
    "side-nav": require "../src/side-nav.vue"
</script>
