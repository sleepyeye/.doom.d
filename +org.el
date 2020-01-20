;;(def-package! org-git-link)

(def-package! ebib
  :init
  :config
  (setq ebib-bib-search-dirs (list sleepyeye/bib-dir)
        ebib-file-search-dirs (list sleepyeye/bibpdfs-dir)
        ebib-notes-directory sleepyeye/bibnote-dir
        ebib-preload-bib-files (list "master.bib")))

(def-package! org-reverse-datetree)

(def-package! ox-rst
  :config
  (setq-default org-reverse-datetree-level-formats
                '((lambda (time) (format-time-string "%B" (org-reverse-datetree-monday time))) ; month
                  "%Y-%m-%d %A"           ; date
                  )))


;; (def-package! org-starter
;;   :config
;;   (setq org-starter-path '(sleepyeye/research-dir sleepyeye/org-dir)))


;; (org-starter-define-file "weekly.org"
;;   :agenda t
;;   :refile '(:maxlevel . 9))

(provide '+org)
