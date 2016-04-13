<template lang="jade">

.container
  side-nav(:is-opened.sync="opened" fixed v-bind:is-fixed.sync="fixed")
    ul
      li First Text
  .container2
    button(@click="toggle" v-if="!fixed") Togglep
    p &lt;&lt; or drag
    a(href="https://github.com/vue-comps/vue-side-nav/blob/master/dev/fixed.vue") source

</template>

<script lang="coffee">
module.exports =
  mixins:[
    require("vue-mixins/getVue")

  ]
  beforeCompile: ->
    Vue = @getVue()
    Vue.use(require('vue-touch'))
  data: ->
    opened: false
    fixed: false
  methods:
    toggle: ->
      @opened = !@opened
  components:
    "side-nav": require "../side-nav.js"
</script>

<style lang="stylus">
.container2
  position relative
  & > a
    position absolute
    left 250px
    top 40px
.side-nav
  border 1px solid black
  background-color white

</style>
