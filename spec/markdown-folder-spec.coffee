MarkdownFolder = require '../lib/markdown-folder'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "MarkdownFolder", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('markdown-folder')
    waitsForPromise ->
      activationPromise
    waitsForPromise ->
      atom.workspace.open('test.md')

  describe "when not folding anything", ->
    it "it should be 13 rows in both screen and buffer", ->
      editor = atom.workspace.getActiveTextEditor()
      expect(editor.getPath()).toContain 'test.md'
      expect(editor.getLineCount()).toBe 13
      expect(editor.getScreenLineCount()).toBe 13

  describe "when folding all h1", ->
    it "it should be 3 rows on screen", ->
      editor = atom.workspace.getActiveTextEditor()
      atom.commands.dispatch workspaceElement, 'markdown-folder:foldall-h1'
      expect(editor.getPath()).toContain 'test.md'
      expect(editor.getLineCount()).toBe 13
      expect(editor.getScreenLineCount()).toBe 3

  describe "when folding all h2", ->
    it "it should be 7 rows on screen", ->
      editor = atom.workspace.getActiveTextEditor()
      atom.commands.dispatch workspaceElement, 'markdown-folder:foldall-h2'
      expect(editor.getPath()).toContain 'test.md'
      expect(editor.getLineCount()).toBe 13
      expect(editor.getScreenLineCount()).toBe 7

  describe "when folding all h3", ->
    it "it should be 10 rows on screen", ->
      editor = atom.workspace.getActiveTextEditor()
      atom.commands.dispatch workspaceElement, 'markdown-folder:foldall-h3'
      expect(editor.getPath()).toContain 'test.md'
      expect(editor.getLineCount()).toBe 13
      expect(editor.getScreenLineCount()).toBe 11

  describe "when folding all h1 and unfolding all", ->
    it "it should be 13 rows in both screen and buffer", ->
      editor = atom.workspace.getActiveTextEditor()
      atom.commands.dispatch workspaceElement, 'markdown-folder:foldall-h1'
      atom.commands.dispatch workspaceElement, 'markdown-folder:unfoldall'
      expect(editor.getPath()).toContain 'test.md'
      expect(editor.getLineCount()).toBe 13
      expect(editor.getScreenLineCount()).toBe 13

  describe "when moving to and folding h2-1", ->
    it "it should be 8 rows on screen", ->
      editor = atom.workspace.getActiveTextEditor()
      editor.setCursorBufferPosition([2,0])
      atom.commands.dispatch workspaceElement, 'markdown-folder:fold'
      expect(editor.getPath()).toContain 'test.md'
      expect(editor.getLineCount()).toBe 13
      expect(editor.getScreenLineCount()).toBe 8

  describe "when moving to and folding h2-1, and then unfolding", ->
    it "it should be 13 rows on screen", ->
      editor = atom.workspace.getActiveTextEditor()
      editor.setCursorBufferPosition([2,0])
      atom.commands.dispatch workspaceElement, 'markdown-folder:fold'
      atom.commands.dispatch workspaceElement, 'markdown-folder:unfold'
      expect(editor.getPath()).toContain 'test.md'
      expect(editor.getLineCount()).toBe 13
      expect(editor.getScreenLineCount()).toBe 13

  describe "when moving to and folding h3-1", ->
    it "it should be 12 rows on screen", ->
      editor = atom.workspace.getActiveTextEditor()
      editor.setCursorBufferPosition([4,0])
      atom.commands.dispatch workspaceElement, 'markdown-folder:fold'
      expect(editor.getPath()).toContain 'test.md'
      expect(editor.getLineCount()).toBe 13
      expect(editor.getScreenLineCount()).toBe 12

  describe "when moving to and folding h3-2", ->
    it "it should be 12 rows on screen", ->
      editor = atom.workspace.getActiveTextEditor()
      editor.setCursorBufferPosition([6,0])
      atom.commands.dispatch workspaceElement, 'markdown-folder:fold'
      expect(editor.getPath()).toContain 'test.md'
      expect(editor.getLineCount()).toBe 13
      expect(editor.getScreenLineCount()).toBe 12

  describe "when moving to and folding h2-2", ->
    it "it should be 12 rows on screen", ->
      editor = atom.workspace.getActiveTextEditor()
      editor.setCursorBufferPosition([8,0])
      atom.commands.dispatch workspaceElement, 'markdown-folder:fold'
      expect(editor.getPath()).toContain 'test.md'
      expect(editor.getLineCount()).toBe 13
      expect(editor.getScreenLineCount()).toBe 12

  describe "when moving to and folding h1-2", ->
    it "it should be 12 rows on screen", ->
      editor = atom.workspace.getActiveTextEditor()
      editor.setCursorBufferPosition([10,0])
      atom.commands.dispatch workspaceElement, 'markdown-folder:fold'
      expect(editor.getPath()).toContain 'test.md'
      expect(editor.getLineCount()).toBe 13
      expect(editor.getScreenLineCount()).toBe 12



  # describe "when the my-package:toggle event is triggered", ->
  #   it "hides and shows the modal panel", ->
  #     # Before the activation event the view is not on the DOM, and no panel
  #     # has been created
  #     expect(workspaceElement.querySelector('.my-package')).not.toExist()
  #
  #     # This is an activation event, triggering it will cause the package to be
  #     # activated.
  #     atom.commands.dispatch workspaceElement, 'my-package:toggle'
  #
  #     waitsForPromise ->
  #       activationPromise
  #
  #     runs ->
  #       expect(workspaceElement.querySelector('.my-package')).toExist()
  #
  #       myPackageElement = workspaceElement.querySelector('.my-package')
  #       expect(myPackageElement).toExist()
  #
  #       myPackagePanel = atom.workspace.panelForItem(myPackageElement)
  #       expect(myPackagePanel.isVisible()).toBe true
  #       atom.commands.dispatch workspaceElement, 'my-package:toggle'
  #       expect(myPackagePanel.isVisible()).toBe false
  #
  #   it "hides and shows the view", ->
  #     # This test shows you an integration test testing at the view level.
  #
  #     # Attaching the workspaceElement to the DOM is required to allow the
  #     # `toBeVisible()` matchers to work. Anything testing visibility or focus
  #     # requires that the workspaceElement is on the DOM. Tests that attach the
  #     # workspaceElement to the DOM are generally slower than those off DOM.
  #     jasmine.attachToDOM(workspaceElement)
  #
  #     expect(workspaceElement.querySelector('.my-package')).not.toExist()
  #
  #     # This is an activation event, triggering it causes the package to be
  #     # activated.
  #     atom.commands.dispatch workspaceElement, 'my-package:toggle'
  #
  #     waitsForPromise ->
  #       activationPromise
  #
  #     runs ->
  #       # Now we can test for view visibility
  #       myPackageElement = workspaceElement.querySelector('.my-package')
  #       expect(myPackageElement).toBeVisible()
  #       atom.commands.dispatch workspaceElement, 'my-package:toggle'
  #       expect(myPackageElement).not.toBeVisible()
