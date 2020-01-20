;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(defvar sleepyeye/dropbox-dir
  (expand-file-name "~/Dropbox"))

(defvar sleepyeye/org-dir
  (expand-file-name "org" sleepyeye/dropbox-dir))

(defvar sleepyeye/research-dir
  (expand-file-name "research" sleepyeye/dropbox-dir))

(defvar sleepyeye/bib-dir
  (expand-file-name "bib" sleepyeye/research-dir))

(defvar sleepyeye/bibnote-dir
  (expand-file-name "note" sleepyeye/research-dir))

(defvar sleepyeye/bibpdfs-dir
  (expand-file-name "pdf" sleepyeye/research-dir))

;; Variable pitch font
(defvar sleepyeye/font-write
  (font-spec :family "Source Serif Pro"))

;; Fixed pitch mono font
(defvar sleepyeye/font-code
  (font-spec :family "Source Code Pro" :size 18))

(setq doom-font sleepyeye/font-code
      doom-variable-pitch-font sleepyeye/font-write
      ;; doom-serif-font  TODO this need fixed-pitch serif font
      )



;;(load-theme 'doom-solarized-light t)
(load-theme 'doom-dracula t)



(load! "+lang-cc")
(load! "+lsp")
(load! "+korean")


(after! org
  ;; TODO enable +inkscape for latex mode
  (load! "+inkscape")
  (load! "+org"))
