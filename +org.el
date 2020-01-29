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



;; export headlines to separate files
;; http://emacs.stackexchange.com/questions/2259/how-to-export-top-level-headings-of-org-mode-buffer-to-separate-files
(defun org-export-weekly-to-rst ()
  "Export all subtrees that are *not* tagged with :noexport: to
separate files.
Subtrees that do not have the :EXPORT_FILE_NAME: property set
are exported to a filename derived from the headline text."
  (interactive)
  (save-buffer)
  (let ((modifiedp (buffer-modified-p)))
    (save-excursion
      (goto-char (point-min))
      (goto-char (re-search-forward "^*"))
      (set-mark (line-beginning-position))
      (goto-char (point-max))
      (org-map-entries
       (lambda ()
         (let ((export-file (org-entry-get (point) "EXPORT_FILE_NAME")))
           (unless export-file
             (org-set-property
              "EXPORT_FILE_NAME"
              (replace-regexp-in-string " " "_" (nth 4 (org-heading-components)))))
           (deactivate-mark)
           (org-rst-export-to-rst nil t)
           (unless export-file (org-delete-property "EXPORT_FILE_NAME"))
           (set-buffer-modified-p modifiedp)))
       "-noexport" 'region-start-level))))





(use-package! ox-publish
  :config
  (setq org-export-in-background t)
  (setq research/base (concat sleepyeye/research-dir "/org")
        research/publish (concat sleepyeye/research-dir "/publish"))
  (add-to-list 'org-publish-project-alist
               `("research" . (:base-directory ,research/base
                                               :base-extension "org"
                                               :publishing-directory ,research/publish
                                               :publishing-function (org-rst-publish-to-rst)
                                               ;; FIXME currently completion function not work
                                               ;; :completion-function
                                               ;; (lambda () (let ((default-directory projectile-project-root))
                                               ;;              (message default-directory)
                                               ;;              (shell-command "make html")))
                                               :body-only t))))

(use-package! ox-extra
  :config
  (ox-extras-activate '(ignore-headlines)))

(use-package! org-download
  :config
  ;; Note that default filename of flamesshot is screenshot.png
  (setq org-download-screenshot-method "flameshot gui -r | xclip -selection clipboard -t image/png -o > %s"))

;; TODO todo capture for weekly
;; TODO weekly setting for research
;; TODO image drawing test
;; TODO image download/insert test using org-download


(use-package! org-starter
  :config
  (setq org-starter-path (list research/base sleepyeye/research-dir sleepyeye/org-dir))
  (org-starter-define-file "weekly.org" :agenda t :refile '(:maxlevel . 9))
  (org-starter-def-capture "w"
      "Weekly entry"
    entry
    (file+function "weekly.org" org-reverse-datetree-goto-date-in-file) "* %?"
    :clock-in t :clock-resume t :empty-lines 1))





;; Define key binding for org setup
(map! (:map org-mode-map
        :localleader
        :desc "Publish file" "x" #'org-publish-current-file
        :desc "Publish project" "X" #'org-publish-project
        :desc "Insert screenshot" "us" #'org-download-screenshot
        :desc "Delete screenshot" "ud" #'org-download-delete
        :desc "Rename screenshot" "ur" #'org-download-rename-at-point))

(provide '+org)
