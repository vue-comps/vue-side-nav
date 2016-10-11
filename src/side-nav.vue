// out: ..
<template lang="pug">
div
  drag-handle(
    @move="move"
    @max="open(false)"
    @aborted="hide"
    v-bind:disabled="opened || isFixed"
    v-bind:max-right="right ? null : width"
    v-bind:max-left="right ? width : null"
    v-bind:z-index="overlayZIndex"
    v-bind:style="{width: '20px',left:right ? null : '0',right:right ? '0' : null}"
  )
  drag-handle(
    @move="move"
    @max="close(false)"
    @aborted="show"
    v-bind:disabled="!opened || isFixed"
    v-bind:max-right="right ? width : null"
    v-bind:max-left="right ? null : width"
    v-bind:offset="right ? -width : width"
    v-bind:z-index="overlayZIndex"
    v-bind:style="{left:'0',right:'0'}"
    @clean-click="dismiss"
  )

  ul(
    v-bind:id="id"
    ref="nav"
    @click="onClick"
    @keyup.esc="dismiss"
    v-bind:style="computedStyle"
    v-bind:class="computedClass"
    )
    slot
</template>

<script lang="coffee">
module.exports =

  components:
    "drag-handle": require("vue-drag-handle")

  created: ->
    @overlay = require("vue-overlay")(@Vue)

  mixins:[
    require("vue-mixins/vue")
    require("vue-mixins/onWindowResize")
    require("vue-mixins/setCss")
    require("vue-mixins/isOpened2")
    require("vue-mixins/class")
    require("vue-mixins/style")
  ]

  props:
    id:
      type: String
    class:
      default: -> ["side-nav"]
    style:
      default: -> []
    width:
      type: Number
      coerce: Number
      default: 240
    opacity:
      type: Number
      default: 0.5
      coerce: Number
    right:
      type: Boolean
      default: false
    notDismissable:
      type: Boolean
      default: false
    closeOnClick:
      type: Boolean
      default: false
    fixed:
      type: Boolean
      default: false
    fixedScreenSize:
      type: Number
      coerce: Number
      default: 992
    transition:
      type: Function
      default: ({el,style,cb}) ->
        @position = style[@side].replace("px","")
        cb()
    zIndex:
      type:Number
      default: 1000
      coerce:Number

  computed:
    side: -> if @right then "right" else "left"
    otherSide: -> if @right then "left" else "right"
    mergeClass: -> fixed: @fixed
    mergeStyle: ->
      style =
        position: "fixed"
        width: @width + "px"
        top: "0"
        margin: "0"
        height: "100%"
        zIndex: @overlayZIndex+1
        boxSizing:"border-box"
        transform:"translateX(0)"
      style[@side] = @position + "px"
      return style
    realWidth: ->
      if @computedStyle[1]?
        width = @computedStyle[1].width
      width ?= @computedStyle[0].width
      return width
  watch:
    fixed: "processFixed"
    fixedScreenSize: "processFixed"
    side: "setParentMargin"
  data: ->
    isFixed: null
    position: -1 * (@width + 10)
    overlayZIndex: 1001
  methods:
    makeFixed: (fixed) ->
      if fixed != @isFixed
        @isFixed = fixed
        @setParentMargin()
        @$emit "fixed", fixed
    setParentMargin: ->
      if @$el.parentElement
        if @isFixed
          width = @realWidth
        else
          width = null
        for el in @$el.parentElement.children
          if el != @$el
            @setCss(el,"margin-#{@side}",width)
            @setCss(el,"margin-#{@otherSide}",null)
    processFixed: ->
      if @fixed
        @makeFixed(window.innerWidth > @fixedScreenSize)
        if @isFixed
          @position = 0
        else
          @position = -1 * (@width + 10)
        @disposeWindowResize = @onWindowResize =>
          if window.innerWidth > @fixedScreenSize # getting bigger
            unless @isFixed
              if @opened
                @close(true)
                @wasOpened = true
              else
                @show(false)
              @makeFixed(true)
          else # getting smaller
            if @isFixed
              if @wasOpened
                @open(true)
              else
                @hide(false)
              @makeFixed(false)
      else
        @makeFixed(false)
        if @opened
          @position = 0
        else
          @position = -1 * (@width + 10)
        @disposeWindowResize?()
      @setParentMargin()
    onClick: (e) ->
      if @closeOnClick
        @dismiss(e)
    dismiss: (e) ->
      unless e.defaultPrevented
        if !@notDismissable and not @isFixed
          @close()
          e.preventDefault()

    move: (position) ->
      fac = if @right then -1 else 1
      @position = -@width+fac*position

    show: (animate = true) ->
      @$emit "before-enter"
      if animate
        style = {}
        style[@side] = "0"
        @transition el:@$refs.nav, style:style, cb: =>
          @setCss @$refs.nav, "transform", "translateX(0)"
          @setOpened()
          @$emit "after-enter"
      else
        @position = 0
        @setOpened()
        @$emit "after-enter"

    hide: (animate = true) ->
      @wasOpened = false
      @$emit "before-leave"
      if animate
        style = {}
        style[@side] = -1 * (@width + 10) + "px"
        @transition el:@$refs.nav, style:style, cb: =>
          @setClosed()
          @$emit "after-leave"
      else
        @position = -1 * (@width + 10)
        @setClosed()
        @$emit "after-leave"

    open: (restoreOverlay) ->
      return if @opened and not restoreOverlay
      {zIndex,close} = @overlay.open zIndex:@zIndex, opacity:@opacity, onBeforeClose: => @close()
      @overlayZIndex = zIndex
      @closeOverlay = close
      unless restoreOverlay
        @show()

    close: (restoreNav) ->
      return unless @opened
      @closeOverlay?(false)
      @closeOverlay = null
      unless restoreNav
        @hide()

    toggle: ->
      if @isFixed # disable opening
        @opened = @isOpened
      else
        if @opened
          @close()
        else
          @open()

  mounted: -> @$nextTick ->
    @processFixed()

  beforeDestory: ->
    @closeOverlay?()
</script>
