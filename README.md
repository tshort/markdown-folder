**NOTE: This package has been retired. It is no longer available through the Atom package manager. It no longer works right on recent releases of Atom.** 

---

# markdown-folder package

Atom package that folds and unfolds markdown headings and fenced code blocks.

Note that the headings must use the hash signs. That is, underlining with equal signs does not work.
There must also be some whitespace between the hash sign and the heading text. Examples that DO work:

`# My First Heading`

`## My Second Heading`

Commands:
  * 'markdown-folder:dwim-toggle': => Cycle headings if on a heading; toggle a fenced code block if on the first line; otherwise pass to the next key command
  * 'markdown-folder:toggle': => Fold/unfold heading at cursor
  * 'markdown-folder:unfoldall': => Unfold all headings
  * 'markdown-folder:cycle': => Cycle heading at cursor (Collapse all - show headings - show all)
  * 'markdown-folder:cycleall': => Cycle all h1 headings
  * 'markdown-folder:togglefenced': => Toggle folding of fenced code blocks
  * 'markdown-folder:toggleallfenced': => Toggle folding of all fenced code blocks
  * 'markdown-folder:unfoldall': => Unfold all headings
  * 'markdown-folder:foldall-h1': => Fold all h1 headings
  * 'markdown-folder:foldall-h2': => Fold all h2 headings
  * 'markdown-folder:foldall-h3': => Fold all h3 headings
  * 'markdown-folder:foldall-h4': => Fold all h4 headings
  * 'markdown-folder:foldall-h5': => Fold all h5 headings


Suggested bindings (not implemented, use in your personal settings if you like):

```
'atom-text-editor[data-grammar="source gfm"]:not([mini])':
  'tab':        'markdown-folder:dwim-toggle'
  'alt-c':      'markdown-folder:cycle'
  'ctrl-alt-c': 'markdown-folder:cycleall'
  'alt-x':      'markdown-folder:togglefenced'
  'ctrl-alt-x': 'markdown-folder:toggleallfenced'
  'alt-t':      'markdown-folder:toggle'
  'ctrl-alt-1': 'markdown-folder:foldall-h1'
  'ctrl-alt-2': 'markdown-folder:foldall-h2'
  'ctrl-alt-3': 'markdown-folder:foldall-h3'
  'ctrl-alt-4': 'markdown-folder:foldall-h4'
  'ctrl-alt-5': 'markdown-folder:foldall-h5'
```

Here is an example of an [mdpad](https://github.com/tshort/mdpad/tree/gh-pages)
markdown file with headings and many fenced code blocks.

![Folding in action](https://github.com/tshort/markdown-folder/raw/master/markdown-folder-mdpad.gif)
