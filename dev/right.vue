<template lang="pug">
.container
  side-nav(
    v-bind:is-opened.sync="opened"
    right
    style="border:1px solid black; background-color: white"
    )
    ul
      li First Text
  .container2(style="text-align:right;padding:20px")
    button(@click="toggle") Toggle
    p  or drag &gt;&gt;
    a(
      href="https://github.com/vue-comps/vue-side-nav/blob/master/dev/fixed.vue"
      style="position:relative;top:40px;right:200px"
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
    "side-nav": require "../side-nav.js"
</script>
