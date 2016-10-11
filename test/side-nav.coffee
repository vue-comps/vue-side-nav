env = null
nav = null
navel = null
mouseEvent = (name,x) ->
  evt = document.createEvent("MouseEvents")
  evt.initMouseEvent(
    name,
    true,
    true,
    window,
    1,
    x,
    10,
    x,
    10,
    false,
    false,
    false,
    false,
    0,
    null
    )
  return evt

pan = (el,start,end,cb) ->
  el.dispatchEvent(mouseEvent("mousedown",start))
  env.$nextTick ->
    document.dispatchEvent(mouseEvent("mousemove",end))
    env.$nextTick ->
      cb (cb2) ->
        end = if end < start then end-11 else end+11
        document.dispatchEvent(mouseEvent("mouseup",end))
        env.$nextTick ->
          cb2()

if window.innerWidth?
  e = window
  a = 'inner'
else
  a = 'client'
  e = document.documentElement || document.body
viewportSize = { width : e[ a+'Width' ] , height : e[ a+'Height' ] }

describe "side-nav", ->

  describe "basic env", ->

    before (done) ->
      env = loadComp(require("../dev/basic.vue"))
      nav = env.$refs.sideNav
      navel = nav.$refs.nav
      env.$nextTick -> done()
    after ->
      #unloadComp(env)

    it "should be hidden on start", ->
      env.opened.should.be.false
      box = navel.getBoundingClientRect()
      box.right.should.be.below 0, "sidenav"
      box = navel.parentElement.children[0].getBoundingClientRect()
      box.left.should.be.above -1, "drag-handle"
      box.width.should.be.above 0, "drag-handle"

    it "should move on drag and open", (done) ->
      pan navel.parentElement.children[0],5,300, (cb) ->
        box = navel.getBoundingClientRect()
        box.left.should.equal 0
        cb ->
          nav.opened.should.be.true
          env.opened.should.be.true
          done()

    it "should move on drag and close", (done) ->
      env.isOpened = true
      env.$nextTick ->
        pan navel.parentElement.children[0],5,-300, (cb) ->
          box = navel.getBoundingClientRect()
          box.right.should.equal 0
          cb ->
            nav.opened.should.be.false
            env.opened.should.be.false
            done()

    describe "right", ->
      before (done) ->
        env.right = true
        env.fixed = false
        env.$nextTick -> done()
      it "should be hidden on start", ->
        env.opened.should.be.false
        box = navel.getBoundingClientRect()
        box.left.should.be.above viewportSize.width, "sidenav"
        box = navel.parentElement.children[0].getBoundingClientRect()
        box.right.should.be.most viewportSize.width, "drag-handle"
        box.width.should.be.above 0, "drag-handle"

      it "should move on drag and open", (done) ->
        dt = navel.parentElement.children[0]
        box = dt.getBoundingClientRect()
        pan dt,box.left+5,box.left-300, (cb) ->
          box = navel.getBoundingClientRect()
          #box.right.should.equal viewportSize.width
          cb ->
            box = navel.getBoundingClientRect()
            box.right.should.equal viewportSize.width
            nav.opened.should.be.true
            env.opened.should.be.true
            done()

      it "should move on drag and close", (done) ->
        env.opened = true
        env.$nextTick ->
          dt = navel.parentElement.children[0]
          pan dt,5,125, (cb) ->
            box = navel.getBoundingClientRect()
            box.left.should.be.at.least viewportSize.width
            cb ->
              nav.opened.should.be.false
              env.opened.should.be.false
              done()

    describe "fixed", ->
      before (done) ->
        env.isOpened = false
        env.right = false
        env.fixed = true
        env.$nextTick -> done()

      it "should be there on start", ->
        nav.opened.should.be.false
        nav.isFixed.should.be.true
        box = navel.getBoundingClientRect()
        box.left.should.equal 0, "sidenav"
        navel.parentElement.children[0].should.equal navel

      it "should be hidden when screen is small", (done) ->
        env.fixedScreenSize = 10000
        env.$nextTick ->
          nav.opened.should.be.false
          nav.isFixed.should.be.false
          box = navel.getBoundingClientRect()
          box.right.should.be.below 0, "sidenav"
          navel.parentElement.children[0].should.not.equal navel
          box = navel.parentElement.children[0].getBoundingClientRect()
          box.left.should.be.above -1, "drag-handle"
          box.width.should.be.above 0, "drag-handle"
          done()
