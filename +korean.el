;;; ~/.doom.d/+korean.el -*- lexical-binding: t; -*-

(set-language-environment "Korean")
(set-fontset-font t 'hangul (font-spec :name "NanumGothic"))
(global-set-key (kbd "<kana>") 'toggle-input-method)
(global-set-key (kbd "<S-spc>") 'toggle-input-method)
(prefer-coding-system 'utf-8)

(provide '+korean)
