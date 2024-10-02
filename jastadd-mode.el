;; Copyright (C) 2017,24 Christoph Reichenbach (creichen@gmail.com)
;;
;; Major mode for JastAdd's jrag/jadd files

(define-derived-mode jastadd-mode
  java-mode "JastAdd"
  "Major mode for JastAdd jrag/jadd attribute grammar specifications."
  )

(font-lock-add-keywords 'jastadd-mode
  '(("\\<\\(aspect\\|syn\\|inh\\|coll\\|eq\\|refine\\|rewrite\\|when\\|to\\|lazy\\|with\\|root\\)\\>" . font-lock-keyword-face)))

(add-to-list 'auto-mode-alist '("\\.jrag\\'" . jastadd-mode))
(add-to-list 'auto-mode-alist '("\\.jadd\\'" . jastadd-mode))

(provide 'jastadd-mode)
