// out: ..
<template lang="pug">
drag-handle(
  @move="move"
  @max="open(false)"
  @aborted="hide"
  v-bind:disabled="isOpened || isFixed"
  v-bind:max-right="right ? null : width"
  v-bind:max-left="right ? width : null"
  v-bind:z-index="overlayZIndex"
  v-bind:style="{width: '20px',left:right ? null : 0,right:right ? 0 : null}"
)
drag-handle(
  @move="move"
  @max="close(false)"
  @aborted="show"
  v-bind:disabled="!isOpened || isFixed"
  v-bind:max-right="right ? width : null"
  v-bind:max-left="right ? null : width"
  v-bind:offset="right ? -width : width"
  v-bind:z-index="overlayZIndex"
  v-bind:style="{left:0,right:0}"
  @clean-click="dismiss"
)

ul(
  v-bind:id="id"
  v-el:nav
  @click="onClick"
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
    "id":
      type: String
    "class":
      default: -> ["side-nav"]
    "style":
      default: -> []
    "width":
      type: Number
      coerce: Number
      default: 240
    "opacity":
      type: Number
      default: 0.5
      coerce: Number
    "right":
      type: Boolean
      default: false
    "notDismissable":
      type: Boolean
      default: false
    "closeOnClick":
      type: Boolean
      default: false
    "fixed":
      type: Boolean
      default: false
    "fixedScreenSize":
      type: Number
      coerce: Number
      default: 992
    "transition":
      type: Function
      default: ({el,style,cb}) ->
        @position = style[@side] + "px"
        cb()
    "isFixed":
      type:Boolean
      default: false
    "zIndex":
      type:Number
      default: 1000
      coerce:Number

  computed:
    side: -> if @right then "right" else "left"
    mergeClass: -> fixed: @fixed
    mergeStyle: ->
      style =
        position: "fixed"
        width: @width + "px"
        top: 0
        margin: 0
        height: "100%"
        zIndex: @overlayZIndex+1
        boxSizing:"border-box"
        transform:"translateX(0)"
      if @position
        style[@side] = @position
      return style
  watch:
    fixed: "processFixed"
    fixedScreenSize: "processFixed"
  data: ->
    position: -1 * (@width + 10) + "px"
    overlayZIndex: 1001
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
        isFixed = window.innerWidth > @fixedScreenSize
        @makeFixed(isFixed)
        if isFixed
          @position = 0
        else
          @position = -1 * (@width + 10) + "px"
        @disposeWindowResize = @onWindowResize =>
          if window.innerWidth > @fixedScreenSize # getting bigger
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
      @position = -@width+fac*position + "px"

    show: (animate = true) ->
      @$emit "before-enter"
      if animate
        style = {}
        style[@side] = 0
        @transition el:@$els.nav, style:style, cb: =>
          @setCss @$els.nav, "transform", "translateX(0)"
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
        style[@side] = -1 * (@width + 10)
        @transition el:@$els.nav, style:style, cb: =>
          @setClosed()
          @$emit "after-leave"
      else
        @position = -1 * (@width + 10) + "px"
        @setClosed()
        @$emit "after-leave"

    open: (restoreOverlay) ->
      return if @opened and not restoreOverlay
      {zIndex,close} = @overlay.open zIndex:@zIndex, opacity:@opacity, onBeforeClose: => @close()
      @overlayZIndex = zIndex
      @closeOverlay = close
      unless restoreOverlay
        @show()
        @$emit "toggled", true

    close: (restoreNav) ->
      return unless @opened
      @closeOverlay?(false)
      @closeOverlay = null
      unless restoreNav
        @hide()
        @$emit "toggled", false

    toggle: ->
      if @isFixed # disable opening
        @isOpened = @opened
      else
        if @opened
          @close()
        else
          @open()

  ready: ->
    @processFixed()
</script>
