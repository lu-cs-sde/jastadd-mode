;;; jastadd-mode.el --- Major mode for JastAdd's jrag/jadd files  -*- lexical-binding: t; -*-

;; Copyright (C) 2017, 2024 Christoph Reichenbach (creichen@gmail.com)
;; Copyright (C) 2025  Erik Präntare (erik.prantare@gmail.com)

;; Author: Christoph Reichenbach, Erik Präntare
;; Keywords: languages

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:

(require 'xref)

(defvar jastadd--declaration-keyword-regexp
  (regexp-opt '("coll" "inh" "eq" "syn") 'word))

(defun jastadd-mode--xref-definitions (identifier)
  "Get definitions of IDENTIFIER."
  (let ((case-fold-search nil))
    (xref-matches-in-files
     (concat "^[[:space:]]*"
             jastadd--declaration-keyword-regexp
             ".*"
             (regexp-quote identifier)
             "(")
     (seq-filter (lambda (file) (equal (file-name-extension file) "jrag"))
                 (project-files (project-current))))))

(cl-defmethod xref-backend-definitions ((_backend (eql 'jastadd)) identifier)
  "Get definitions of IDENTIFIER."
  (jastadd-mode--xref-definitions identifier))

(defun jastadd-mode--setup-xref ()
  "Set up xref to use jastadd as a backend."
  (add-hook 'xref-backend-functions (lambda () 'jastadd) nil t))

(defun jastadd-mode-goto-definition ()
  "Go to definition of symbol at point."
  (interactive)
  (let ((xref-backend-functions (list (lambda () 'jastadd))))
    (xref-find-definitions (symbol-name (symbol-at-point)))))

(defun jastadd--outline-search-function (&optional bound move backward looking-at)
  ;; Assume everything is correctly indented, assume one indentation
  ;; level indicates heading
  (let (regexp)
    (save-excursion
      (goto-char (point-min))
      (search-forward "aspect")
      (re-search-forward (rx bol (group-n 1 (+ white))))
      (setq regexp (rx bol
                       (literal (match-string 1))
                       alpha)))
    (cond
     (looking-at (looking-at regexp))
     (backward (re-search-backward regexp bound (and move 'move)))
     (t (re-search-forward regexp bound (and move 'move))))))

(define-derived-mode jastadd-mode
  java-mode "JastAdd"
  "Major mode for JastAdd jrag/jadd attribute grammar specifications."
  (jastadd-mode--setup-xref)
  (setq-local outline-search-function #'jastadd--outline-search-function)
  (font-lock-add-keywords
   'jastadd-mode
   (list (cons (regexp-opt '("aspect" "syn" "inh" "coll" "eq" "refine" "rewrite" "when" "to" "lazy" "with" "root") 'words)
               font-lock-keyword-face))))

(add-to-list 'auto-mode-alist '("\\.jrag\\'" . jastadd-mode))
(add-to-list 'auto-mode-alist '("\\.jadd\\'" . jastadd-mode))

(provide 'jastadd-mode)
;;; jastadd-mode.el ends here
