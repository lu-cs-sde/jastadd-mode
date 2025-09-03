;; Copyright (C) 2017,24 Christoph Reichenbach (creichen@gmail.com)
;; Copyright (C) 2025 Erik Präntare (erik.prantare@gmail.com)
;;
;; Major mode for JastAdd's jrag/jadd files

(require 'project)
(require 'xref)
(require 'cl-generic)

(defun jastadd--mode-xref-definitions (identifier)
  "Get definitions of IDENTIFIER."
  (let ((project-root (project-root (project-current)))
        (case-fold-search nil))
    (xref-matches-in-files
     ;; xref-matches-in-files does not handle shy groups generated
     ;; by "or" in rx syntax (this is a bug). [2025-09-03]
     ;; (rx line-start (* white) (or "coll" "inh" "eq" "syn") (* any) (literal identifier) "(")
     (concat "^[[:space:]]*\\(coll\\|inh\\|eq\\|syn\\).*" (regexp-quote identifier) "(")
     (seq-filter (lambda (file) (equal (file-name-extension file) "jrag"))
                 (project-files (project-current))))))

(cl-defmethod xref-backend-definitions ((_backend (eql 'jastadd)) identifier)
  "Get definitions of IDENTIFIER."
  (jastadd--mode-xref-definitions identifier))

(defun jastadd--mode-setup-xref ()
  "Set up xref to use jastadd as a backend."
  (add-hook 'xref-backend-functions (lambda () 'jastadd) nil t))

(defun jastadd-mode-goto-definition ()
  "Go to definition of symbol at point."
  (interactive)
  (let ((xref-backend-functions (list (lambda () 'jastadd))))
    (xref-find-definitions (symbol-name (symbol-at-point)))))

(define-derived-mode jastadd-mode
  java-mode "JastAdd"
  "Major mode for JastAdd jrag/jadd attribute grammar specifications."
  (jastadd--mode-setup-xref))

(font-lock-add-keywords 'jastadd-mode
  '(("\\<\\(aspect\\|syn\\|inh\\|coll\\|eq\\|refine\\|rewrite\\|when\\|to\\|lazy\\|with\\|root\\)\\>" . font-lock-keyword-face)))

(add-to-list 'auto-mode-alist '("\\.jrag\\'" . jastadd-mode))
(add-to-list 'auto-mode-alist '("\\.jadd\\'" . jastadd-mode))

(provide 'jastadd-mode)
