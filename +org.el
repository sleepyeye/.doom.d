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



;; Add since original org-rst-export-to-rst does not take pub-dir
(defun org-rst-export-to-rst-pubdir
  (pub-dir &optional async subtreep visible-only body-only ext-plist)
  "Export current buffer to a reStructuredText file.

If narrowing is active in the current buffer, only export its
narrowed part.

If a region is active, export that region.

A non-nil optional argument ASYNC means the process should happen
asynchronously.  The resulting file should be accessible through
the `org-export-stack' interface.

When optional argument SUBTREEP is non-nil, export the sub-tree
at point, extracting information from the headline properties
first.

When optional argument VISIBLE-ONLY is non-nil, don't export
contents of hidden elements.

Return output file's name."
  (interactive)
  (let* ((extension (concat "." (or (plist-get ext-plist :rst-extension)
                                    org-rst-extension
                                    "rst")))
         (file (org-export-output-file-name extension subtreep pub-dir)))
    (org-export-to-file 'rst file
      async subtreep visible-only body-only ext-plist)))

;; export headlines to separate files
;; http://emacs.stackexchange.com/questions/2259/how-to-export-top-level-headings-of-org-mode-buffer-to-separate-files
(defun org-export-weekly-to-rst (pub-dir)
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
           (org-rst-export-to-rst-pubdir pub-dir nil t)
           (unless export-file (org-delete-property "EXPORT_FILE_NAME"))
           (set-buffer-modified-p modifiedp)))
       "-noexport" 'region-start-level))))



(defun org-publish-research (plist filename pub-dir)
  (if (string-match-p "weekly.org" filename)
      (org-export-weekly-to-rst pub-dir)
    (org-rst-publish-to-rst plist filename pub-dir)))


(setq research/base (concat sleepyeye/research-dir "/org")
      research/publish (concat sleepyeye/research-dir "/publish"))

(use-package! ox-publish
  :config
  (setq org-export-in-background t)
  (add-to-list 'org-publish-project-alist
               `("research" . (:base-directory ,research/base
                                               :base-extension "org"
                                               :publishing-directory ,research/publish
                                               :publishing-function org-publish-research
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
  (setq org-download-screenshot-method "gnome-screenshot -a -f %s"))


(defun org-download-copy-screenshot ()
  "Capture screenshot and insert the resulting file.
The screenshot tool is determined by `org-download-screenshot-method'."
  (interactive)
  (let ((default-directory "~"))
    (make-directory (file-name-directory org-download-screenshot-file) t))
  (when (file-exists-p org-download-screenshot-file)
    (org-download-image org-download-screenshot-file)
    (delete-file org-download-screenshot-file)))


;; TODO todo capture for weekly
;; TODO weekly setting for research
;; TODO image drawing test
;; TODO image download/insert test using org-download


(use-package! org-starter
  :config
  (setq org-starter-path (list research/base sleepyeye/research-dir sleepyeye/org-dir))

  ;; Define weekly
  (org-starter-define-file "weekly.org" :agenda t :refile '(:maxlevel . 9))
  (org-starter-def-capture "w" "Weekly")
  (org-starter-def-capture "wc"
      "New entry with clock"
    entry
    (file+function "weekly.org" org-reverse-datetree-goto-date-in-file) "* %^{Entry title}\n %?"
    :clock-in t :clock-resume t :empty-lines 1)
  (org-starter-def-capture "wl"
      "New entry with file link"
    entry
    (file+function "weekly.org" org-reverse-datetree-goto-date-in-file) "* %^{Entry title}\n %a\n %?"
    :empty-lines 1))




;; Define key binding for org setup
(map! (:map org-mode-map
        :localleader
        :desc "Publish file" "x" #'org-publish-current-file
        ;; :desc "Publish project" "X" #'org-publish-project
        :desc "Publish project" "X" #'(lambda (&optional force async)
                                        (interactive "P")
                                        (org-publish-current-project t async))
        :desc "Insert screenshot" "us" #'org-download-copy-screenshot
        :desc "Delete screenshot" "ud" #'org-download-delete
        :desc "Rename screenshot" "ur" #'org-download-rename-at-point))

(provide '+org)
