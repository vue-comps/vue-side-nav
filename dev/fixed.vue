<template lang="pug">
.container
  side-nav(
    v-bind:is-opened.sync="opened"
    fixed
    v-bind:is-fixed.sync="fixed"
    style="border:1px solid black; background-color: white"
    )
    ul
      li First Text
  .container2(style="height:2000px;padding:20px")
    button(@click="toggle" v-if="!fixed") Toggle
    p(v-if="!fixed") &lt;&lt; or drag
    p(v-if="!fixed") Make window larger for the nav to stay opened
    p(v-if="fixed") Side-nav is fixed for this window-size. Make the window smaller for it to collapse.
    a(
      href="https://github.com/vue-comps/vue-side-nav/blob/master/dev/fixed.vue"
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
    fixed: false
  methods:
    toggle: ->
      @opened = !@opened
  components:
    "side-nav": require "../side-nav.js"
</script>
