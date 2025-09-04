# jastadd-mode

`jastadd-mode` is a (bare-bones) Emacs major mode for editing [JastAdd](https://jastadd.org) attribute grammar specifications,
commonly placed in `.jrag`/`.jadd` files.

## Features
- Syntax highlighting
- Go-to-definition with xref
- Otherwise very bare-bones, little more than `java-mode` with extra keywords

## Installation
Add the following to your configuration:

```elisp
(use-package jastadd-mode
  :vc (:url "https://github.com/lu-cs-sde/jastadd-mode"
            :branch "main"
            :rev :newest))
```

## Related work
These references

- [JastAdd AST mode](https://github.com/rudi/jastadd-ast-mode/tree/master) (also [in MELPA](https://melpa.org/#/jastadd-ast-mode))
- [JastAdd tags support for vi(m) & Emacs](https://github.com/ivarref/jastadd-tags) (haven't tested)
