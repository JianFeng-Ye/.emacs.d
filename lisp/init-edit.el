(prefer-coding-system 'utf-8-unix)

;;(defalias 'yes-or-no-p 'y-or-n-p)
(fset 'yes-or-no-p 'y-or-n-p)
(global-prettify-symbols-mode 1)

(setq-default tab-width 4
              indent-tabs-mode nil)

;; 自动换行
;;(toggle-truncate-lines t)
(global-visual-line-mode 1)

;; 不备份
(setq auto-save-default nil)
(setq auto-save-list-file-prefix nil)
;; don't create backup~ files
(setq make-backup-files nil)

;; warn when opening files bigger than 10MB
(setq large-file-warning-threshold 10000000)

(setq ring-bell-function 'ignore
      visible-bell nil)

;; Single space between sentences is more widespread than double
(setq-default sentence-end-double-space nil)

;; disable annoying blink-matching-paren
(setq blink-matching-paren nil)
(setq show-paren-delay 0)
(show-paren-mode 1)

(defconst cache-dir (expand-file-name "cache" user-emacs-directory))
(unless (file-exists-p cache-dir)
  (make-directory cache-dir))
;; 保存上一次打开文件的位置
(setq save-place-file (expand-file-name "places" cache-dir)
      save-place-limit 10)
(save-place-mode 1)

(setq recentf-save-file (expand-file-name "recentf" cache-dir)
      recentf-max-menu-items 5
      recentf-max-saved-items 5)
(recentf-mode 1)
;; (global-set-key (kbd "C-x C-r") 'recentf-open-files)

(setq org-id-locations-file (expand-file-name "org-id-locations" cache-dir))

;; nice scrolling
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

;;(line-number-mode t) ;; 默认开启
;;(column-number-mode t)
;;(size-indication-mode t)

(defun mode-line--format (left right)
  "Return a string of `window-width' length containing LEFT and RIGHT, aligned respectively."
  (let ((reserve (length right)))
    (concat left
            " "
            (propertize " "
                        'display `((space :align-to (- right ,reserve))))
            right)))

(setq-default mode-line-format
              '((:eval
                 (mode-line--format
                  ;; Left
                  (format-mode-line
                   (list mode-line-front-space
                         ;; 全角空格
                         "%Z　%b "
                         evil-mode-line-tag
                         (when buffer-read-only "[RO]")
                         (when (buffer-modified-p) "[+]")))

                  ;; Right
                  (format-mode-line
                   (list "%l,"
                         ;; 行列坐标显示
                         ((lambda () (let ((column-length (length (format-mode-line "%C"))))
                                   (concat "%C" (format (format "%%%ds" (- 5 column-length)) " ")))))
                         "%m"
                         mode-line-end-spaces))))))

;; org-mode X_{Y}, Y成为下标
(setq org-export-with-sub-superscripts (quote {}))

;; <s + TAG 在 org 9.2 中不生效, 或用 C-c + C-,
;;(with-eval-after-load 'org (require 'org-tempo))

;; vim C-a 自增
(defun my-change-number-at-point (change increment)
  (let ((number (number-at-point)) (point (point)))
    (when number
      (progn
        (forward-word)
        (search-backward (number-to-string number))
        (replace-match (number-to-string (funcall change number increment)))
        (goto-char point)))))
;;(defun my-increment-number-at-point (&optional increment)
;;  "Increment number at point like vim's C-a"
;;  (interactive "p")
;;  (my-change-number-at-point '+ (or increment 1)))
(global-set-key (kbd "C-a") (lambda (&optional increment)
                              "Increment number at point like vim's C-a"
                              (interactive "p")
                              (my-change-number-at-point '+ (or increment 1))))

(setq org-export-default-language "zh-CN")
(setq org-export-backends '(ascii html md))
(setq org-html-metadata-timestamp-format "%Y-%m-%d")
(setq org-html-postamble t)
(setq org-html-postamble-format
      '(("en" "<span class=\"author\">XXX</span> / <span class=\"date\">%d</span> <span class=\"creator\">%c</span>")))
;;(setq org-html-preamble-format
;;      '(("en" "<script type=\"text/javascript\">
;;                if(!/Android|webOS|iPhone|iPod|BlackBerry/i.test(navigator.userAgent)) {
;;                    var obj = document.body;
;;                    obj.style.marginLeft = \"20%%\";
;;                    obj.style.marginRight = \"20%%\";
;;                }
;;                </script>")))

;; 不导出默认的 CSS 和 JavaScript
(setq org-html-head-include-default-style nil)
(setq org-html-head-include-scripts nil)
;;(defun my-org-inline-code-hook (exporter)
;;  "Insert custom inline code"
;;  (when (and (eq exporter 'html) (string-empty-p org-html-head))
;;    (setq org-html-head
;;          (with-temp-buffer
;;            (insert-file-contents-literally (expand-file-name "head-inline.txt" user-emacs-directory))
;;            (buffer-string)))))
(add-hook 'org-export-before-processing-hook (lambda (exporter)
                                               "Insert custom inline code"
                                               (when (and (eq exporter 'html) (string-empty-p org-html-head))
                                                 (setq org-html-head
                                                       (with-temp-buffer
                                                         (insert-file-contents-literally (expand-file-name "head-inline.txt" user-emacs-directory))
                                                         (buffer-string))))))
;; 另一种写法
;;(advice-add 'org-html-export-to-html :before 'test) ;; defun test (&rest _)

(advice-add 'org-export-output-file-name :around (lambda (orig-fun extension &optional subtreep pub-dir)
                                                   (unless pub-dir
                                                     (let ((org-output-dir (concat "X:/" (file-name-as-directory "org-output"))))
                                                       (unless (file-directory-p org-output-dir)
                                                         (make-directory org-output-dir))
                                                       (setq pub-dir (concat org-output-dir (substring extension 1)))
                                                       (unless (file-directory-p pub-dir)
                                                         (make-directory pub-dir))))
                                                   (apply orig-fun extension subtreep pub-dir nil)))

(auto-insert-mode)
(setq auto-insert 'other
      auto-insert-query nil
      auto-insert-alist '((("\\.org\\'" . "org header") nil
                           "#+TITLE: " (file-name-base buffer-file-name) "\n"
                           "#+DATE: " (format-time-string "[%F %T (%z) %a]") "\n"
                           "#+KEYWORDS: " (file-name-base (directory-file-name (file-name-directory buffer-file-name))) "\n\n")))

(provide 'init-edit)
