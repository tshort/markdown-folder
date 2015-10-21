{CompositeDisposable, Point, Range, TextBuffer} = require 'atom'

module.exports = MarkdownFolder =
  subscriptions: null

  activate: (state) ->

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'markdown-folder:dwim-toggle': (event) => @dwimtoggle(event)
    @subscriptions.add atom.commands.add 'atom-workspace', 'markdown-folder:toggle': => @toggle()
    @subscriptions.add atom.commands.add 'atom-workspace', 'markdown-folder:cycle': => @cycle()
    @subscriptions.add atom.commands.add 'atom-workspace', 'markdown-folder:togglefenced': => @togglefenced()
    @subscriptions.add atom.commands.add 'atom-workspace', 'markdown-folder:cycleall': => @cycleall()
    @subscriptions.add atom.commands.add 'atom-workspace', 'markdown-folder:toggleallfenced': => @toggleallfenced()
    @subscriptions.add atom.commands.add 'atom-workspace', 'markdown-folder:unfoldall': => @unfoldall()
    @subscriptions.add atom.commands.add 'atom-workspace', 'markdown-folder:foldall-h1': => @foldall(/^(#+)/)
    @subscriptions.add atom.commands.add 'atom-workspace', 'markdown-folder:foldall-h2': => @foldall(/^(##+)/)
    @subscriptions.add atom.commands.add 'atom-workspace', 'markdown-folder:foldall-h3': => @foldall(/^(###+)/)
    @subscriptions.add atom.commands.add 'atom-workspace', 'markdown-folder:foldall-h4': => @foldall(/^(####+)/)
    @subscriptions.add atom.commands.add 'atom-workspace', 'markdown-folder:foldall-h5': => @foldall(/^(#####+)/)

  deactivate: ->
    @subscriptions.dispose()

  dwimtoggle: (event) ->
    editor = atom.workspace.getActiveTextEditor()
    linetext = editor.lineTextForBufferRow(editor.getCursorBufferPosition().row)
    if linetext.match(/^(#+)/)
      @cycle()
    else if linetext.match(/^\s*```\w+/)
      @togglefenced()
    else
      event.abortKeyBinding()

  toggle: ->
    @folderer('toggle', -1)

  cycle: ->
    @folderer('cycle', -1)

  cycleall: ->
    editor = atom.workspace.getActiveTextEditor()
    if typeof editor.__markdownfolder_nextaction == "undefined"
      action = 'fold'
    else
      action = editor.__markdownfolder_nextaction
    if action == 'fold'
      @foldall(/^#+\s/)
    else if action == 'unfold'
      editor.unfoldAll()
    else   # show headings
      for linenumber in [editor.getLastBufferRow()..0]
        linetext = editor.lineTextForBufferRow(linenumber)
        if linetext.match(/^#+\s/)
          @folderer('showheadings', linenumber)
    if action == 'fold'
      editor.__markdownfolder_nextaction = 'showheadings'
    else if action == 'showheadings'
      editor.__markdownfolder_nextaction = 'unfold'
    else
      editor.__markdownfolder_nextaction = 'fold'


  foldall: (matcher) ->
    editor = atom.workspace.getActiveTextEditor()
    for linenumber in [editor.getLastBufferRow()..0]
      linetext = editor.lineTextForBufferRow(linenumber)
      if linetext.match(matcher)
        @folderer('fold', linenumber)

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

    if startrow == -1
      startrow = editor.getCursorBufferPosition().row

    if action == 'toggle'
      if editor.isFoldedAtBufferRow(startrow + 1)
        action = 'unfold'
      else
        action = 'fold'

    linetext = editor.lineTextForBufferRow(startrow)
    thematch = linetext.match(/^(#+)/)
    nextmatchfound = false

    if thematch
      lastrowindex = editor.getLastBufferRow()
      lastrowtext = editor.lineTextForBufferRow(lastrowindex)
      nextmatch = @getNextMatcher(thematch[1])
      searchrange = new Range(new Point(startrow + 1 , 0), new Point(lastrowindex,lastrowtext.length - 1))

      toggleFold = (range) ->
        if action == 'cycle'
          # Logic:
          #   if fully collapsed and has headings, show headings
          #   else if any nonheaders are collapsed, collapse all
          #   else expand all (everything that's collapsed is a heading or if it doesn't have any headings)
          lastrow = range.end.row - 1
          for linenr in [lastrow..startrow + 1]
            if editor.lineTextForBufferRow(linenr).match(/^\s*$/) # only whitespace
              lastrow--
            else
              break
          numheadings = 0
          numfolded = 0
          for row in [(startrow + 1)..lastrow]
            if editor.isFoldedAtBufferRow(row)  # count folded rows
              numfolded++
            if editor.lineTextForBufferRow(row).match(/^#+\s/)  # count headings
              numheadings++
          numvisibleheadings = 0
          screenstartrow = editor.screenPositionForBufferPosition(new Point(startrow, 0)).row
          screenendrow   = editor.screenPositionForBufferPosition(new Point(lastrow, 0)).row
          numvisiblerows = screenendrow - screenstartrow
          for screenrow in [screenstartrow..screenendrow]
            if editor.lineTextForScreenRow(screenrow).match(/^#+\s/)  # count visible headings
              numvisibleheadings++
          if numvisiblerows == 0   # fully folded
            if numheadings > 0
              action = 'showheadings'
            else
              action = 'unfold'
          else if numvisiblerows == numheadings &&   # just headings shown
                  numheadings == numvisibleheadings - 1 &&
                  numfolded > 0
            action = 'unfold'
          else
            action = 'fold'

        for row in [range.end.row - 1..startrow]
          editor.unfoldBufferRow(row)
        if action != 'unfold'
          # Don't fold empty lines. Go backwards and check
          lastrowtofold = range.end.row - 1
          for linenr in [lastrowtofold..startrow + 1]
            if editor.lineTextForBufferRow(linenr).match(/^\s*$/) # only whitespace
              lastrowtofold--
            else
              break
          if action == 'showheadings'     # make several ranges
            ranges = []
            for linenr in [lastrowtofold..startrow]
              if editor.lineTextForBufferRow(linenr).match(/^#+\s/) # a heading
                if lastrowtofold - linenr > 0
                  ranges.push (new Range(new Point(linenr, 0), new Point(lastrowtofold, 0)))
                lastrowtofold = linenr - 1
            if lastrowtofold - startrow > 1
              ranges.push (new Range(new Point(startrow, 0), new Point(lastrowtofold, 0)))
            if ranges.length > 0
              editor.setSelectedBufferRanges(ranges)
          else
            editor.setSelectedBufferRange(new Range(new Point(startrow, 0), new Point(lastrowtofold, 0)))
          editor.foldSelectedLines()
        editor.setCursorBufferPosition(new Point(startrow, 0))

      scanCallback = (scanresult) ->
        toggleFold(scanresult.range)
        nextmatchfound = true

      editor.scanInBufferRange(nextmatch, searchrange, scanCallback)

      if !nextmatchfound
        toggleFold(new Range(new Point(startrow, 0),new Point(lastrowindex,lastrowtext.length - 1)))

  iscode: (scopes) ->
    for str in scopes.getScopesArray()
      if str.match /markup\.code\..*\.gfm/
        return true
    return false

  togglefenced: ->
    editor = atom.workspace.getActiveTextEditor()
    startpos = editor.getCursorBufferPosition()
    startrow = startpos.row
    if !editor.lineTextForBufferRow(startrow).match(/^\s*```\w+/)
      return
    shouldunfold = editor.isFoldedAtBufferRow(startrow + 1)
    row = startrow + 1
    loop
      if shouldunfold
        editor.unfoldBufferRow(row)
      if editor.lineTextForBufferRow(row).match(/^\s*```/)
        if !shouldunfold
          editor.setSelectedBufferRange(new Range(new Point(startrow, 0), new Point(row, 0)))
          editor.foldSelectedLines()
          editor.moveUp()
        break
      row++

  toggleallfenced: ->
    editor = atom.workspace.getActiveTextEditor()
    if typeof editor.__markdownfolder_nextfencedaction == "undefined"
      action = 'fold'
    else
      action = editor.__markdownfolder_nextfencedaction
    lookingforfirst = true
    for row in [0..editor.getLastBufferRow()]
      isstart = editor.lineTextForBufferRow(row).match(/^\s*```\w+/)
      isend = editor.lineTextForBufferRow(row).match(/^\s*```/)
      if lookingforfirst
        if isstart
          startrow = row
          lookingforfirst = false
      else
        if isend
          if action == 'fold'
            editor.setSelectedBufferRange(new Range(new Point(startrow, 0), new Point(row, 0)))
            editor.foldSelectedLines()
          else
            for frow in [startrow..row]
              editor.unfoldBufferRow(frow)
          lookingforfirst = true
    if action == 'fold'
      editor.__markdownfolder_nextfencedaction = 'unfold'
    else
      editor.__markdownfolder_nextfencedaction = 'fold'
