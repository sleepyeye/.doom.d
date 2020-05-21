;;; ~/.doom.d/+lsp.el -*- lexical-binding: t; -*-

;; TODO disable sideline

(after! lsp
  (setq lsp-ui-sideline-enable nil
        lsp-enable-file-watchers nil))
(provide '+lsp)
