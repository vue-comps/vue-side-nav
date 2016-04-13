// out: ..
<template lang="jade">
drag-handle(
  @move="move"
  @right="open"
  @aborted="hide"
  v-bind:disabled="isOpened"
  v-bind:max-right="width"
  v-bind:z-index="style.zIndex+1"
  style="width: 20px;left:0;"
)
drag-handle(
  @move="move"
  @left="close"
  @aborted="show"
  v-bind:disabled="!isOpened || fixedOpened"
  v-bind:max-left="width"
  v-bind:offset="width"
  v-bind:z-index="style.zIndex+1"
  style="width: 70%;right:0;"
  @clean-click="dismiss | notPrevented | prevent"
)
ul(
  v-el:nav
  @click="dismiss | notPrevented | prevent"
  @keyup.esc="dismiss | notPrevented | prevent"
  v-bind:style="style"
  style="transform:translateX(0)"
  v-bind:class="[class, fixed ? 'fixed':'']"
  )
  slot No content
</template>

<script lang="coffee">
module.exports =

  components:
    "drag-handle": require("vue-drag-handle")

  filters:
    notPrevented: require("vue-filters/notPrevented")
    prevent: require("vue-filters/prevent")

  created: ->
    @overlay = require("vue-overlay")(@getVue())

  mixins:[
    require("vue-mixins/getVue")
    require("vue-mixins/onWindowResize")
    require("vue-mixins/setCss")
    require("vue-mixins/isOpened")
  ]

  props:
    "class":
      type: String
      default: "side-nav"
    "width":
      type: Number
      coerce: (val = 240) ->
        parseFloat(val)
      default: 240
    "opacity":
      type: Number
      default: 0.5
    "side":
      type: String
      default: "left"
    "notDismissible":
      type: Boolean
      default: false
    "fixed":
      type: Boolean
      default: false
    "hideOnScreenSize":
      type: Number
      coerce: (val = 992) -> parseFloat(val)
      default: 992
    "transition":
      type: Function
      default: ({el,style,cb}) ->
        @style[@side] = style[@side] + "px"
        cb()
    "isFixed":
      type:Boolean
      default: false

  data: ->
    style:
      position: "absolute"
      width: 0
      top: 0
      margin: 0
      height: "100%"
      left: undefined
      right: undefined
      zIndex: 1001
      boxSizing:"border-box"
    veloOpts: {duration: 300, queue: false, easing: 'easeOutQuad'}
    closeOverlay: null
    disposeWindowResize: null
    fixedOpened: false
    wasOpened: false

  watch:
    "width": "processWidth"
    "fixed": "processFixed"
    "side": (val) ->
      if val == "left"
        @style.right = undefined
      else
        @style.left = undefined
      @setParentMargin()
    "fixedOpened": "emitFixed"

  methods:
    emitFixed: (fixedOpened=@fixedOpened)->
      @setParentMargin()
      @isFixed = fixedOpened
      if fixedOpened
        @$emit "fixed"
      else
        @$emit "unfixed"
    setParentMargin: ->
      if @$el.parentElement
        width = if @fixedOpened then @style.width else null
        for el in @$el.parentElement.children
          if el != @$els.nav
            @setCss(el,"margin-#{@side}",width)
    processWidth: (width=@width) ->
      @style.width = width+"px"
    processFixed: (fixed=@fixed) ->
      if fixed
        if window.innerWidth > @hideOnScreenSize
          @show(false)
          @fixedOpened = true
        @disposeWindowResize = @onWindowResize =>
          if window.innerWidth > @hideOnScreenSize
            unless @fixedOpened
              if @opened
                @close(true)
                @wasOpened = true
              else
                @show(false)
              @fixedOpened = true
          else
            if @fixedOpened
              if @wasOpened
                @open(true)
              else
                @hide(false)
              @fixedOpened = false
      else
        @disposeWindowResize?()
        @fixedOpened = false
    dismiss: ->
      @close() if !@notDismissible and not @fixedOpened

    move: (position) ->
      @style[@side] = -@width+position+ "px"

    show: (animate = true) ->
      @opened = true
      @isOpened = true
      @$emit "before-opened"
      if animate
        style = {}
        style[@side] = 0
        @transition el:@$els.nav, style:style, cb: =>
          @setCss @$els.nav, "transform", "translateX(0)"
          @$emit "opened"
      else
        @style[@side] = 0
        @$emit "opened"

    hide: (animate = true) ->
      @opened = false
      @isOpened = false
      @wasOpened = false
      @$emit "before-closed"
      if animate
        style = {}
        style[@side] = -1 * (@width + 10)
        @transition el:@$els.nav, style:style, cb: =>
          @setCss @$els.nav, "transform", "translateX(0)"
          @$emit "closed"
      else
        @style[@side] =  -1 * (@width + 10) + "px"
        @$emit "closed"

    open: (restoreOverlay) ->
      return if @opened and not restoreOverlay
      {zIndex,close} = @overlay.open opacity:@opacity, onBeforeClose: => @close()
      @style.zIndex = zIndex
      @closeOverlay = close
      @show() unless restoreOverlay


    close: (restoreNav) ->
      return unless @opened
      @closeOverlay?()
      @closeOverlay = null
      @hide() unless restoreNav

    toggle: ->
      if @opened
        @close()
      else
        @open()

  compiled: ->
    @hide(false)
    @processWidth()
    @processFixed()


</script>
