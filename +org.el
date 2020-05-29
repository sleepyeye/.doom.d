;; (use-package! org-starter
;;   :config
;;   (setq org-starter-path (list research/base sleepyeye/research-dir sleepyeye/org-dir))

;;   ;; Define weekly
;;   (org-starter-define-file "weekly.org" :agenda t :refile '(:maxlevel . 9))
;;   (org-starter-def-capture "w" "Weekly")
;;   (org-starter-def-capture "wc"
;;       "New entry with clock"
;;     entry
;;     (file+function "weekly.org" org-reverse-datetree-goto-date-in-file) "* %^{Entry title}\n %?"
;;     :clock-in t :clock-resume t :empty-lines 1)
;;   (org-starter-def-capture "wl"
;;       "New entry with file link"
;;     entry
;;     (file+function "weekly.org" org-reverse-datetree-goto-date-in-file) "* %^{Entry title}\n %a\n %?"
;;     :empty-lines 1))


;; Org-roam
(after! org-roam
  (map! :leader
        :prefix "n"
        :desc "org-roam" "l" #'org-roam
        :desc "org-roam-find-file" "f" #'org-roam-find-file
        :desc "org-roam-insert" "i" #'org-roam-insert
        :desc "org-roam-capture" "c" #'org-roam-capture)
  (setq org-roam-directory "~/Dropbox/org/")
  (setq org-roam-index-file "index.org"))

(use-package! org-journal
  :bind
  ("C-c n j" . org-journal-new-entry)
  :custom
  (org-journal-dir "~/Dropbox/org/journal/")
  (org-journal-date-prefix "#+TITLE: ")
  (org-journal-file-format "%Y-%m-%d.org")
  (org-journal-date-format "%A, %d %B %Y"))
(setq org-journal-enable-agenda-integration t)


(use-package! deft
  :after org
  :bind
  ("C-c n d" . deft)
  :custom
  (deft-recursive t)
  (deft-use-filter-string-for-filename t)
  (deft-default-extension "org")
  (deft-directory "~/Dropbox/org/"))


(after! helm-bibtex
  (setq bibtex-completion-notes-path "~/Dropbox/org/note/"
        bibtex-completion-library-path "~/Dropbox/org/pdf/"
        bibtex-completion-bibliography "~/Dropbox/org/ref/default.bib"
        bibtex-completion-pdf-field "file"
        bibtex-completion-notes-template-multiple-files
        (concat
         "${title}\n"
         "#+ROAM_KEY: cite:${=key=}\n"
         "* TODO Notes\n"
         ":PROPERTIES:\n"
         ":Custom_ID: ${=key=}\n"
         ":NOTER_DOCUMENT: %(file-relative-name (orb-process-file-field \"${=key=}\"))\n"
         ":AUTHOR: ${author-abbrev}\n"
         ":JOURNAL: ${journaltitle}\n"
         ":DATE: ${date}\n"
         ":YEAR: ${year}\n"
         ":DOI: ${doi}\n"
         ":URL: ${url}\n"
         ":END:\n\n"
         )
        ))

(use-package! org-noter
  :after (:any org pdf-view)
  :config
  (setq org-noter-notes-search-path "~/Dropbox/org/"
        ;; The WM can handle splits
        org-noter-notes-window-location 'other-frame
        ;; Please stop opening frames
        org-noter-always-create-frame nil
        ;; I want to see the whole file
        org-noter-hide-other nil))


;; If you installed via MELPA
(use-package! org-roam-bibtex
  :requires bibtex-completion
  :hook (org-roam-mode . org-roam-bibtex-mode))

;; (use-package! ox-bibtex)

(setq org-html-htmlize-output-type nil)
(setq org-html-htmlize-output-type 'css)
(setq org-html-htmlize-output-type 'inline-css)


(after! org-ref
  (setq org-ref-completion-library 'org-ref-ivy-cite
        org-ref-get-pdf-filename-function 'org-ref-get-pdf-filename-helm-bibtex
        org-ref-default-bibliography (list "~/Dropbox/org/ref/default.bib")
        ;; org-ref-bibliography-notes "~/Dropbox/org/note/bibnotes.org"
        org-ref-note-title-format "* TODO %y - %t\n :PROPERTIES:\n  :Custom_ID: %k\n  :NOTER_DOCUMENT: %F\n :ROAM_KEY: cite:%k\n  :AUTHOR: %9a\n  :JOURNAL: %j\n  :YEAR: %y\n  :VOLUME: %v\n  :PAGES: %p\n  :DOI: %D\n  :URL: %U\n :END:\n\n"
        org-ref-notes-directory "~/Dropbox/org/note/"
        org-ref-notes-function 'orb-edit-notes
        reftex-default-bibliography '("~/Dropbox/org/ref/default.bib")
        org-ref-default-bibliography '("~/Dropbox/org/ref/default.bib")
        org-ref-pdf-directory "~/Dropbox/org/pdf/"))

;; (defconst sleepyeye/org-header
;;   )

(use-package! ox-publish
  :config
  (setq org-publish-project-alist
        '(
          ("orgfiles"
           :base-directory "~/Dropbox/org/"
           :base-extension "org"
           :publishing-directory "~/Dropbox/org/build/"
           :publishing-function org-html-publish-to-html
           :exclude "build" ;; regexp
           :headline-levels 3
           :section-numbers nil
           :with-toc nil
           :recursive t
           :html-head
           "<link rel=\"stylesheet\" type=\"text/css\" href=\"https://gongzhitaao.org/orgcss/org.css\"/>
                    <script src=\"https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.10.0/highlight.min.js\"></script>
                    <script>var hlf=function(){Array.prototype.forEach.call(document.querySelectorAll(\"pre.src\"),function(t){var e;e=t.getAttribute(\"class\"),e=e.replace(/src-(\w+)/,\"src-$1 $1\"),console.log(e),t.setAttribute(\"class\",e),hljs.highlightBlock(t)})};addEventListener(\"DOMContentLoaded\",hlf);</script>
                    <link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.10.0/styles/googlecode.min.css\" />
                    "
           ))))

(provide '+org)
