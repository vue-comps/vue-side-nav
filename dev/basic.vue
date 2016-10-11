<template lang="pug">
.container
  side-nav(
    v-bind:is-opened="opened",
    @toggled="gettingToggled",
    :right ="right",
    :fixed="fixed",
    :fixed-screen-size="fixedScreenSize",
    @fixed="gettingFixed"
    ref="sideNav",
    style="border:1px solid black; background-color: white"
      )
    li First Text
  .container2(style="padding:20px")
    button(@click="fixed=!fixed") {{fixed?"unfix":"fix"}}
    button(@click="right=!right") {{right?"to the left":"to the right"}}
    br
    button(@click="toggle" v-if="!isFixed") Toggle
    p(v-if="notFixedAndLeft") &lt;&lt; or drag
    p(v-if="notFixedAndRight" style="text-align:right") or drag  &gt;&gt;
    p(v-if="!isFixed") Make window larger for the nav to stay opened
    p(v-if="isFixed") Side-nav is fixed for this window-size. Make the window smaller for it to collapse.
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
  created: ->
    @Vue.use(require('vue-touch'))
    @setCss document.body, "margin",0
  computed:
    notFixedAndLeft: -> !@isFixed and !@right
    notFixedAndRight: -> !@isFixed and @right
  data: ->
    right: false
    fixed: false
    isFixed: false
    opened: false
    fixedScreenSize: 992
  methods:
    gettingFixed: (fixed) -> @isFixed = fixed
    toggle: -> @opened = !@opened
    gettingToggled: (opened) -> @opened = opened
  components:
    "side-nav": require "../src/side-nav.vue"
</script>
