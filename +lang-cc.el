;;; ~/.doom.d/+lang-cc.el -*- lexical-binding: t; -*-


;; TODO fix weird indent
;; TODO proper .clang-format
;; TODO fix weird filename.o file when I open cuda file


(defun llvm-lineup-statement (langelem)
  (let ((in-assign (c-lineup-assignments langelem)))
    (if (not in-assign)
        '++
      (aset in-assign 0
            (+ (aref in-assign 0)
               (* 2 c-basic-offset)))
      in-assign)))

;; Add a cc-mode style for editing LLVM C and C++ code
(c-add-style "llvm"
             '("gnu"
               (fill-column . 80)
               (c++-indent-level . 2)
               (c-basic-offset . 2)
               (indent-tabs-mode . nil)
               (c-offsets-alist . ((arglist-intro . ++)
                                   (innamespace . 0)
                                   (member-init-intro . ++)
                                   (statement-cont . llvm-lineup-statement)))))

;; Files with "llvm" in their names will automatically be set to the
;; llvm.org coding style.
;; (add-hook 'c-mode-common-hook
;;           (function
;;            (lambda nil
;;              (if (string-match "llvm" buffer-file-name)
;;                  (progn
;;                    (c-set-style "llvm.org"))))))


(after! cc-mode
  (setq-default c-basic-offset 2)
  (setq-default c-basic-offset tab-width
                c-backspace-function #'delete-backward-char
                c-default-style "llvm"))

(provide '+lang-cc)
