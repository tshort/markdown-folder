MarkdownFolder = require '../lib/markdown-folder'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "MarkdownFolder", ->
  [workspaceElement] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)

    waitsForPromise ->
      atom.workspace.open('test.md')

    waitsForPromise ->
      Promise.all [
        atom.packages.activatePackage('markdown-folder')
        atom.commands.dispatch workspaceElement, 'markdown-folder:unfoldall'
      ]

  describe "when not folding anything", ->
    it "it should be 14 rows in both screen and buffer", ->
      editor = atom.workspace.getActiveTextEditor()
      expect(editor.getPath()).toContain 'test.md'
      expect(editor.getLineCount()).toBe 14
      expect(editor.getScreenLineCount()).toBe 14

  describe "when folding all h1", ->
    it "it should be 4 rows on screen", ->
      editor = atom.workspace.getActiveTextEditor()
      atom.commands.dispatch workspaceElement, 'markdown-folder:foldall-h1'
      expect(editor.getPath()).toContain 'test.md'
      expect(editor.getLineCount()).toBe 14
      expect(editor.getScreenLineCount()).toBe 4

  describe "when folding all h2", ->
    it "it should be 8 rows on screen", ->
      editor = atom.workspace.getActiveTextEditor()
      atom.commands.dispatch workspaceElement, 'markdown-folder:foldall-h2'
      expect(editor.getPath()).toContain 'test.md'
      expect(editor.getLineCount()).toBe 14
      expect(editor.getScreenLineCount()).toBe 8

  describe "when folding all h3", ->
    it "it should be 12 rows on screen", ->
      editor = atom.workspace.getActiveTextEditor()
      atom.commands.dispatch workspaceElement, 'markdown-folder:foldall-h3'
      expect(editor.getPath()).toContain 'test.md'
      expect(editor.getLineCount()).toBe 14
      expect(editor.getScreenLineCount()).toBe 12

  describe "when folding all h1 and unfolding all", ->
    it "it should be 14 rows in both screen and buffer", ->
      editor = atom.workspace.getActiveTextEditor()
      atom.commands.dispatch workspaceElement, 'markdown-folder:foldall-h1'
      atom.commands.dispatch workspaceElement, 'markdown-folder:unfoldall'
      expect(editor.getPath()).toContain 'test.md'
      expect(editor.getLineCount()).toBe 14
      expect(editor.getScreenLineCount()).toBe 14

  describe "when moving to and folding h2-1", ->
    it "it should be 9 rows on screen", ->
      editor = atom.workspace.getActiveTextEditor()
      editor.setCursorBufferPosition([2,0])
      atom.commands.dispatch workspaceElement, 'markdown-folder:toggle'
      expect(editor.getPath()).toContain 'test.md'
      expect(editor.getLineCount()).toBe 14
      expect(editor.getScreenLineCount()).toBe 9

  describe "when moving to and folding h1-1", ->
    it "it should be 5 rows on screen", ->
      editor = atom.workspace.getActiveTextEditor()
      editor.setCursorBufferPosition([0,0])
      atom.commands.dispatch workspaceElement, 'markdown-folder:toggle'
      expect(editor.getPath()).toContain 'test.md'
      expect(editor.getLineCount()).toBe 14
      expect(editor.getScreenLineCount()).toBe 5

  describe "when moving to and folding h2-1, and then unfolding", ->
    it "it should be 14 rows on screen", ->
      editor = atom.workspace.getActiveTextEditor()
      editor.setCursorBufferPosition([2,0])
      atom.commands.dispatch workspaceElement, 'markdown-folder:toggle'
      atom.commands.dispatch workspaceElement, 'markdown-folder:toggle'
      expect(editor.getPath()).toContain 'test.md'
      expect(editor.getLineCount()).toBe 14
      expect(editor.getScreenLineCount()).toBe 14

  describe "when moving to and folding h3-1", ->
    it "it should be 13 rows on screen", ->
      editor = atom.workspace.getActiveTextEditor()
      editor.setCursorBufferPosition([4,0])
      atom.commands.dispatch workspaceElement, 'markdown-folder:toggle'
      expect(editor.getPath()).toContain 'test.md'
      expect(editor.getLineCount()).toBe 14
      expect(editor.getScreenLineCount()).toBe 13

  describe "when moving to and folding h3-2", ->
    it "it should be 13 rows on screen", ->
      editor = atom.workspace.getActiveTextEditor()
      editor.setCursorBufferPosition([6,0])
      atom.commands.dispatch workspaceElement, 'markdown-folder:toggle'
      expect(editor.getPath()).toContain 'test.md'
      expect(editor.getLineCount()).toBe 14
      expect(editor.getScreenLineCount()).toBe 13

  describe "when moving to and folding h2-2", ->
    it "it should be 13 rows on screen", ->
      editor = atom.workspace.getActiveTextEditor()
      editor.setCursorBufferPosition([8,0])
      atom.commands.dispatch workspaceElement, 'markdown-folder:toggle'
      expect(editor.getPath()).toContain 'test.md'
      expect(editor.getLineCount()).toBe 14
      expect(editor.getScreenLineCount()).toBe 13

  describe "when moving to and folding h1-2", ->
    it "it should be 13 rows on screen", ->
      editor = atom.workspace.getActiveTextEditor()
      editor.setCursorBufferPosition([11,0])
      atom.commands.dispatch workspaceElement, 'markdown-folder:toggle'
      expect(editor.getPath()).toContain 'test.md'
      expect(editor.getLineCount()).toBe 14
      expect(editor.getScreenLineCount()).toBe 13

  describe "when moving to and cycling h1-1", ->
    it "it should be 5 rows on screen then 9 then 14 as cycled", ->
      editor = atom.workspace.getActiveTextEditor()
      editor.setCursorBufferPosition([0,0])
      atom.commands.dispatch workspaceElement, 'markdown-folder:cycle'
      expect(editor.getPath()).toContain 'test.md'
      expect(editor.getLineCount()).toBe 14
      expect(editor.getScreenLineCount()).toBe 5
      atom.commands.dispatch workspaceElement, 'markdown-folder:cycle'
      expect(editor.getScreenLineCount()).toBe 9
      atom.commands.dispatch workspaceElement, 'markdown-folder:cycle'
      expect(editor.getScreenLineCount()).toBe 14
      atom.commands.dispatch workspaceElement, 'markdown-folder:cycle'
      expect(editor.getScreenLineCount()).toBe 5


  describe "when moving to and cycling h1-1-h2-1-h3-1", ->
    it "it should be 13 rows on screen then 14 as cycled", ->
      editor = atom.workspace.getActiveTextEditor()
      editor.setCursorBufferPosition([4,0])
      atom.commands.dispatch workspaceElement, 'markdown-folder:cycle'
      expect(editor.getPath()).toContain 'test.md'
      expect(editor.getLineCount()).toBe 14
      expect(editor.getScreenLineCount()).toBe 13
      atom.commands.dispatch workspaceElement, 'markdown-folder:cycle'
      expect(editor.getScreenLineCount()).toBe 14
      atom.commands.dispatch workspaceElement, 'markdown-folder:cycle'
      expect(editor.getScreenLineCount()).toBe 13

  describe "when cycling the whole buffer", ->
    it "it should be 4 rows on screen then 8 then 14 as cycled", ->
      editor = atom.workspace.getActiveTextEditor()
      atom.commands.dispatch workspaceElement, 'markdown-folder:cycleall'
      expect(editor.getPath()).toContain 'test.md'
      expect(editor.getLineCount()).toBe 14
      expect(editor.getScreenLineCount()).toBe 4
      atom.commands.dispatch workspaceElement, 'markdown-folder:cycleall'
      expect(editor.getScreenLineCount()).toBe 8
      atom.commands.dispatch workspaceElement, 'markdown-folder:cycleall'
      expect(editor.getScreenLineCount()).toBe 14
      atom.commands.dispatch workspaceElement, 'markdown-folder:cycleall'
      expect(editor.getScreenLineCount()).toBe 4

  describe "when cycling the whole buffer and there is no h1", ->
    beforeEach ->
      waitsForPromise ->
        atom.workspace.open('test-no-h1.md')
    it "it should cycle everything regardless", ->
      editor = atom.workspace.getActiveTextEditor()
      atom.commands.dispatch workspaceElement, 'markdown-folder:cycleall'
      expect(editor.getPath()).toContain 'test-no-h1.md'
      expect(editor.getLineCount()).toBe 14
      expect(editor.getScreenLineCount()).toBe 6
      atom.commands.dispatch workspaceElement, 'markdown-folder:cycleall'
      expect(editor.getScreenLineCount()).toBe 8
      atom.commands.dispatch workspaceElement, 'markdown-folder:cycleall'
      expect(editor.getScreenLineCount()).toBe 14
      atom.commands.dispatch workspaceElement, 'markdown-folder:cycleall'
      expect(editor.getScreenLineCount()).toBe 6

  describe "when toggling all fenced blocks", ->
    beforeEach ->
      waitsForPromise ->
        atom.workspace.open('test-fenced.md')
    it "it should be 17 then 27 lines on screen", ->
      editor = atom.workspace.getActiveTextEditor()
      atom.commands.dispatch workspaceElement, 'markdown-folder:toggleallfenced'
      expect(editor.getPath()).toContain 'test-fenced.md'
      expect(editor.getLineCount()).toBe 27
      expect(editor.getScreenLineCount()).toBe 17
      atom.commands.dispatch workspaceElement, 'markdown-folder:toggleallfenced'
      expect(editor.getScreenLineCount()).toBe 27

  describe "when toggling the first fenced block", ->
    beforeEach ->
      waitsForPromise ->
        atom.workspace.open('test-fenced.md')
    it "it should be 20 then 23 lines on screen", ->
      editor = atom.workspace.getActiveTextEditor()
      editor.setCursorBufferPosition([3,0])
      atom.commands.dispatch workspaceElement, 'markdown-folder:dwim-toggle'
      expect(editor.getPath()).toContain 'test-fenced.md'
      expect(editor.getLineCount()).toBe 27
      expect(editor.getScreenLineCount()).toBe 24
      atom.commands.dispatch workspaceElement, 'markdown-folder:dwim-toggle'
      expect(editor.getScreenLineCount()).toBe 27
      editor.setCursorBufferPosition([0,0])
      atom.commands.dispatch workspaceElement, 'markdown-folder:dwim-toggle'
      expect(editor.getScreenLineCount()).toBe 7

  describe "when cycling a heading inside a fenced block or comment", ->
    beforeEach ->
      waitsForPromise ->
        atom.workspace.open('test-fenced.md')
    it "it should not cycle", ->
      editor = atom.workspace.getActiveTextEditor()
      editor.setCursorBufferPosition([12,0])
      atom.commands.dispatch workspaceElement, 'markdown-folder:dwim-toggle'
      expect(editor.getScreenLineCount()).toBe 27
      editor.setCursorBufferPosition([20,0])
      atom.commands.dispatch workspaceElement, 'markdown-folder:dwim-toggle'
      expect(editor.getScreenLineCount()).toBe 27
