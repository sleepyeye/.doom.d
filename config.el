;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(load! "+lang-cc")
(load! "+lsp")
(load! "+korean")


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

(load-theme 'doom-solarized-light t)


;; (set-face-font 'default "Source Code Pro Semibold-9")
;; (set-face-font 'variable-pitch "Segoe UI Semibold-9")
;; (copy-face 'default 'fixed-pitch)



;;(def-package! org-git-link)

(def-package! ebib
  :init
  :config
  (setq ebib-bib-search-dirs (list sleepyeye/bib-dir)
        ebib-file-search-dirs (list sleepyeye/bibpdfs-dir)
        ebib-notes-directory sleepyeye/bibnote-dir
        ebib-preload-bib-files (list "master.bib")))

(def-package! org-reverse-datetree)

;; (def-package! org-starter
;;   :config
;;   (setq org-starter-path '(sleepyeye/research-dir sleepyeye/org-dir)))


;; (org-starter-define-file "weekly.org"
;;   :agenda t
;;   :refile '(:maxlevel . 9))
