// out: ..
<template lang="pug">
drag-handle(
  @move="move"
  @max="open"
  @aborted="hide"
  v-bind:disabled="isOpened || isFixed"
  v-bind:max-right="right ? null : width"
  v-bind:max-left="right ? width : null"
  v-bind:z-index="zIndex-1"
  v-bind:style="{width: '20px',left:right ? null : 0,right:right ? 0 : null}"
)
drag-handle(
  @move="move"
  @max="close"
  @aborted="show"
  v-bind:disabled="!isOpened || isFixed"
  v-bind:max-right="right ? width : null"
  v-bind:max-left="right ? null : width"
  v-bind:offset="right ? -width : width"
  v-bind:z-index="zIndex-1"
  v-bind:style="{width: '100%',backgroundColor:'black',opacity:opacity}"
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

  mixins:[
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
      coerce: (val = 240) ->
        parseFloat(val)
      default: 240
    "opacity":
      type: Number
      default: 0.5
      coerce: Number
    "zIndex":
      type: Number
      default: 1000
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
    "hideOnScreenSize":
      type: Number
      coerce: Number
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
        zIndex: @zIndex
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
    hideOnScreenSize: "processFixed"
  data: ->
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
                @wasOpened = true
              else
                @show(false)
              @makeFixed(true)
          else # getting smaller
            if @isFixed
              @hide(false) unless @wasOpened
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

    open: ->
      return if @opened
      @show()


    close: ->
      return unless @opened
      @hide()

    toggle: ->
      if @opened
        @close()
      else
        @open()

  ready: ->
    @processFixed()
</script>
