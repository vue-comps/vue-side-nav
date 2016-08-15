// out: ..
<template lang="pug">
drag-handle(
  v-if="!right"
  @move="move"
  @right="open"
  @aborted="hide"
  v-bind:disabled="isOpened || isFixed"
  v-bind:max-right="width"
  v-bind:z-index="overlayZIndex+1"
  style="width: 20px;left:0;"
)
drag-handle(
  v-if="!right"
  @move="move"
  @left="close"
  @aborted="show"
  v-bind:disabled="!isOpened || isFixed"
  v-bind:max-left="width"
  v-bind:offset="width"
  v-bind:z-index="overlayZIndex+1"
  style="width: 70%;right:0;"
  @clean-click="dismiss"
)
drag-handle(
  v-if="right"
  @move="move"
  @left="open"
  @aborted="hide"
  v-bind:disabled="isOpened || isFixed"
  v-bind:max-left="width"
  v-bind:z-index="overlayZIndex+1"
  style="width: 20px;right:0;"
)
drag-handle(
  v-if="right"
  @move="move"
  @right="close"
  @aborted="show"
  v-bind:disabled="!isOpened || isFixed"
  v-bind:max-right="width"
  v-bind:offset="width"
  v-bind:z-index="overlayZIndex+1"
  style="width: 70%;left:0;"
  @clean-click="dismiss"
)
ul(
  v-el:nav
  @click="dismiss"
  @keyup.esc="dismiss"
  v-bind:style="computedStyle"
  v-bind:class="computedClass"
  )
  slot No content
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
    require("vue-mixins/isOpened")
    require("vue-mixins/class")
    require("vue-mixins/style")
  ]

  props:
    "class":
      default: -> ["side-nav"]
    "style":
      default: -> []
    "width":
      type: Number
      coerce: (val = 240) ->
        parseFloat(val)
      default: 240
    "opacity":
      type: Number
      default: 0.5
    "right":
      type: Boolean
      default: false
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
        @mergeStyle[@side] = style[@side] + "px"
        cb()
    "isFixed":
      type:Boolean
      default: false

  computed:
    side: -> if @right then "right" else "left"
    otherSide: -> if @right then "left" else "right"
    mergeClass: -> fixed: @fixed
    mergeStyle: ->
      style =
        position: "fixed"
        width: @width + "px"
        top: 0
        margin: 0
        height: "100%"
        zIndex: @overlayZIndex
        boxSizing:"border-box"
        transform:"translateX(0)"
      if @position
        style[@side] = @position
      else
        style[@side] = if @isOpened or @isFixed  then 0 else -1 * (@width + 10) + "px"
      style[@otherSide] = null
      return style
  watch:
    fixed: "processFixed"
  data: ->
    overlayZIndex: 1001
    position: null

  methods:
    makeFixed: (fixed)->
      if fixed != @isFixed
        @isFixed = fixed
        @setParentMargin(fixed)
        @$emit "fixed", fixed
    setParentMargin: (fixed=@isFixed,side=@side) ->
      if @$el.parentElement
        if fixed
          if @computedStyle[1]?
            width = @computedStyle[1].width
          width ?= @computedStyle[0].width
        else
          width = null
        for el in @$el.parentElement.children
          if el != @$els.nav
            @setCss(el,"margin-#{side}",width)
    processFixed: ->
      if @fixed
        @makeFixed(window.innerWidth > @hideOnScreenSize)
        @disposeWindowResize = @onWindowResize =>
          if window.innerWidth > @hideOnScreenSize # getting bigger
            unless @isFixed
              if @isOpened
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
        @isFixed = false
        @disposeWindowResize?()
      @setParentMargin()
    dismiss: (e) ->
      unless e.defaultPrevented
        if !@notDismissible and not @isFixed
          @close()
          e.preventDefault()

    move: (position) ->
      fac = if @right then -1 else 1
      @position = -@width+fac*position + "px"

    show: (animate = true) ->
      @$emit "before-opened"
      @position = 0
      if animate
        style = {}
        style[@side] = 0
        @transition el:@$els.nav, style:style, cb: =>
          @setCss @$els.nav, "transform", "translateX(0)"
          @setOpened()
          @$emit "opened"
      else
        @setOpened()
        @$emit "opened"

    hide: (animate = true) ->
      @position = 0
      @wasOpened = false
      @$emit "before-closed"
      if animate
        style = {}
        style[@side] = -1 * (@width + 10)
        @transition el:@$els.nav, style:style, cb: =>
          @setCss @$els.nav, "transform", "translateX(0)"
          @setClosed()
          @$emit "closed"
      else
        @setClosed()
        @$emit "closed"

    open: (restoreOverlay) ->
      return if @opened and not restoreOverlay
      {zIndex,close} = @overlay.open opacity:@opacity, onBeforeClose: => @close()
      @overlayZIndex = zIndex
      @closeOverlay = close
      @show() unless restoreOverlay


    close: (restoreNav) ->
      return unless @opened
      @closeOverlay?(false)
      @closeOverlay = null
      @hide() unless restoreNav

    toggle: ->
      if @opened
        @close()
      else
        @open()

  ready: ->
    @processFixed()
</script>
