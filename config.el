;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(load! "+lang-cc")
(load! "+lsp")
(load! "+korean")

;; (load! "+reveal")

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

;;(def-package! org-git-link)

(def-package! ebib
  :init
  :config
  (setq ebib-bib-search-dirs (list sleepyeye/bib-dir)
        ebib-file-search-dirs (list sleepyeye/bibpdfs-dir)
        ebib-notes-directory sleepyeye/bibnote-dir
        ebib-preload-bib-files (list "master.bib")))
