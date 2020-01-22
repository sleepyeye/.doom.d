;;(def-package! org-git-link)

(use-package! ebib
  :init
  :config
  (setq ebib-bib-search-dirs (list sleepyeye/bib-dir)
        ebib-file-search-dirs (list sleepyeye/bibpdfs-dir)
        ebib-notes-directory sleepyeye/bibnote-dir
        ebib-preload-bib-files (list "master.bib")))

(use-package! org-reverse-datetree
  :config
  (setq-default org-reverse-datetree-level-formats
                '("%Y"
                  (lambda (time)
                    (format-time-string "%B" (org-reverse-datetree-monday time))) ; month
                  "%Y-%m-%d %A"           ; date
                  )))

(use-package! ox-rst)

(use-package! ox-publish
  :config
  (setq research/base (concat sleepyeye/research-dir "/org")
        research/publish (concat sleepyeye/research-dir "/publish"))
  (add-to-list 'org-publish-project-alist
               `("research" . (:base-directory ,research/base
                                               :base-extension "org"
                                               :publishing-directory ,research/publish
                                               :publishing-function org-rst-publish-to-rst
                                               ;; FIXME currently completion function not work
                                               ;; :completion-function
                                               ;; (lambda () (let ((default-directory projectile-project-root))
                                               ;;              (message default-directory)
                                               ;;              (shell-command "make html")))
                                               :body-only t))))

(use-package! ox-extra
  :config
  (ox-extras-activate '(ignore-headlines)))




;; (def-package! org-starter
;;   :config
;;   (setq org-starter-path '(sleepyeye/research-dir sleepyeye/org-dir)))


;; (org-starter-define-file "weekly.org"
;;   :agenda t
;;   :refile '(:maxlevel . 9))



;; Define key binding for org setup
(map! (:map org-mode-map
        :localleader
        :desc "Publish file" "x" #'org-publish-current-file
        :desc "Publish project" "X" #'org-publish-project))


(provide '+org)
