env = null
describe "side-nav", ->

  describe "basic env", ->

    before ->
      env = loadComp(require("../dev/basic.vue"))

    after ->
      unloadComp(env)

    it "should work", ->
      env.$refs.sideNav.opened.should.be.false
