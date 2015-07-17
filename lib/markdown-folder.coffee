{CompositeDisposable, Point, Range, TextBuffer} = require 'atom'

module.exports = MarkdownFolder =
  subscriptions: null

  activate: (state) ->

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'markdown-folder:fold': => @fold()
    @subscriptions.add atom.commands.add 'atom-workspace', 'markdown-folder:unfold': => @unfold()
    @subscriptions.add atom.commands.add 'atom-workspace', 'markdown-folder:foldall': => @foldall()
    @subscriptions.add atom.commands.add 'atom-workspace', 'markdown-folder:unfoldall': => @unfoldall()

  deactivate: ->
    @subscriptions.dispose()

  fold: ->
    @folderer('fold')

  unfold: ->
    @folderer('unfold')

  foldall: ->
    console.log "foldingall"

  unfoldall: ->
    editor = atom.workspace.getActiveTextEditor()
    editor.unfoldAll()

  getNextMatcher: (matcher) ->
    result = /^#\s/
    switch matcher.length
      when 2 then result = /^#\s|^##\s/
      when 3 then result = /^#\s|^##\s|^###\s/
      when 4 then result = /^#\s|^##\s|^###\s|^####\s/
      when 5 then result = /^#\s|^##\s|^###\s|^####\s|^#####\s/
      when 6 then result = /^#\s|^##\s|^###\s|^####\s|^#####\s|^######\s/
    return result

  folderer: (action, startrow) ->
    editor = atom.workspace.getActiveTextEditor()
    startrow ||= editor.getCursorBufferPosition().row
    linetext = editor.lineTextForBufferRow(startrow)
    thematch = linetext.match(/^(#+)/)
    nextmatchfound = false

    if thematch
      lastrowindex = editor.getLastBufferRow()
      lastrowtext = editor.lineTextForBufferRow(lastrowindex)
      nextmatch = @getNextMatcher(thematch[1])
      console.log "nextmatch = " + nextmatch
      # todo read until last EOL
      searchrange = new Range(new Point(startrow + 1 , 0), new Point(lastrowindex,lastrowtext.length - 1))

      toggleFold = (range) ->
        console.log "Found match in range " + range
        editor.setSelectedBufferRange(new Range(new Point(startrow, 0), new Point(range.end.row - 1, 0)))
        if action == 'unfold'
          for row in [startrow..range.end.row - 1]
            console.log "trying to unfold row " + row
            editor.unfoldBufferRow(row)
        else
          console.log "folding all selected lines"
          editor.foldSelectedLines()
        editor.setCursorBufferPosition(new Point(startrow, 0))

      scanCallback = (scanresult) ->
        console.log "Found " + scanresult.matchText + " at " + scanresult.range + " firstfoldedrow = " + (startrow)
        toggleFold(scanresult.range)
        nextmatchfound = true

      editor.scanInBufferRange(nextmatch, searchrange, scanCallback)
      if !nextmatchfound
        toggleFold(new Range(new Point(startrow, 0),new Point(lastrowindex,lastrowtext.length - 1)))
    else
      console.log "Does not begin with #"

    console.log 'startrow = ' + startrow + " linetext = " + linetext
