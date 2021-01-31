;; 不能使用 use-package 的 :after, 因为和 init-package-pre 里的 use-package-always-defer 配置冲突

(require 'init-package-pre)
(require 'init-const)

(use-package undo-tree)

(use-package evil
  :init
  (global-undo-tree-mode)
  (setq evil-insert-state-cursor t
        evil-want-C-u-scroll t
        evil-want-C-i-jump nil
        evil-undo-system 'undo-tree)
  (evil-mode 1)
  :config
  (evil-define-key nil 'global (kbd "<escape>") #'keyboard-escape-quit))

(use-package ivy
  :init
  (ivy-mode 1)
  :config
  (global-set-key (kbd "C-s") #'swiper))

;; ivy 扩展
(use-package counsel
  :init
  (counsel-mode 1))

(use-package which-key
  :init
  (setq which-key-idle-delay 0.2
        which-key-side-window-location 'bottom)
  (which-key-mode 1)
  :config
  ;; 自定义快捷键
  (let ((leader-key "SPC")
        (leader-alt-key "M-m")
        (guide-keymap (make-sparse-keymap))
        (keys
         (list
          (cons "h" (lookup-key global-map (kbd "C-h")))
          (cons "SPC" (lookup-key global-map (kbd "M-x")))
          (cons "TAB" #'mode-line-other-buffer)
          (cons "b d" (lambda ()
                        (interactive)
                        (unless (member (buffer-name (current-buffer)) '("*scratch*" "*Messages*"))
                          (kill-buffer-and-window))))
          (cons "b b" #'ivy-switch-buffer)
          (cons "e d" #'save-buffers-kill-emacs)
          (cons "f d" #'dired)
          (cons "f f" #'counsel-find-file)
          (cons "f j" #'dired-jump)
          (cons "f r" #'counsel-recentf)
          (cons "o c" #'org-toggle-checkbox)
          (cons "o d" #'org-todo)
          (cons "o e" #'org-export-dispatch)
          (cons "o i" #'org-insert-structure-template)
          (cons "o l" #'org-insert-link)
          (cons "o m" #'org-sparse-tree)
          (cons "o o" (lambda ()
                        (interactive)
                        (if (org-in-regexp org-link-bracket-re 1)
                            (org-open-at-point)
                          (message "is not a link"))))
          (cons "o t" (lambda ()
                        (interactive)
                        (insert (format-time-string "[%F %T (%z)]"))))
          (cons "o s" (lambda ()
                        (interactive)
                        (let* ((begin-pos (line-beginning-position))
                               (end-pos (line-end-position))
                               (content (buffer-substring-no-properties begin-pos end-pos))
                               (content-length (length content))
                               (max-width 80)
                               (new-content-list '())
                               (trim-func (lambda (s)
                                            (replace-regexp-in-string "^\\s-*" ""
                                                                      (replace-regexp-in-string "\\s-*$" "" s))))
                               (tmp-length 0)
                               (tmp-pos 0))
                          (dotimes (i content-length)
                            (setq tmp-length (+ tmp-length (char-width (elt content i))))
                            (when (>= tmp-length max-width)
                              (push (funcall trim-func (substring-no-properties content tmp-pos (+ i 1))) new-content-list)
                              (setq tmp-pos (+ i 1))
                              (setq tmp-length 0)
                              )
                            )
                          (when (> (length new-content-list) 0)
                            (unless (= content-length (+ tmp-pos 1))
                              (push (funcall trim-func (substring-no-properties content tmp-pos)) new-content-list))
                            (delete-region begin-pos end-pos)
                            (insert (string-join (reverse new-content-list) "\n"))))))
          (cons "o -" #'org-ctrl-c-minus))))
    (dolist (key keys)
      (define-key guide-keymap (kbd (car key)) (cdr key)))
    (which-key-add-keymap-based-replacements guide-keymap
      "SPC" "M-x"
      "h" "help"
      "b" "buffer"
      "b d" "my-kill-buffer"
      "e" "emacs"
      "f" "file"
      "o" "org"
      "o o" "my-org-open-link"
      "o s" "my-truncate-line"
      "o t" "my-insert-timestamp")
    (evil-define-key '(normal visual motion) 'global (kbd leader-key) guide-keymap)
    (evil-define-key '(insert emacs) 'global (kbd leader-alt-key) guide-keymap)))

(use-package nord-theme
  :init
  (load-theme 'nord t))

(provide 'init-package)
