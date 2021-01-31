(add-to-list 'load-path (expand-file-name (concat user-emacs-directory "lisp")))
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load-file custom-file))

;; 部分 *help* 窗口打开时移动焦点
(setq help-window-select t)

;; Start with the *scratch* buffer in text mode
(setq initial-major-mode 'text-mode)

;; remove annoying ellipsis when printing sexp in message buffer
(setq eval-expression-print-length nil
      eval-expression-print-level nil)

(require 'init-const)
(require 'init-package)
(require 'init-ui)
(require 'init-edit)

(when *system-type-windows* (setq delete-by-moving-to-trash t))

;; 执行 ls 时加上 h
(setq dired-listing-switches "-alh")
(put 'dired-find-alternate-file 'disabled nil)
;; dired-mode 打开子目录共用一个buffer
(with-eval-after-load 'dired
  (define-key dired-mode-map (kbd "RET") #'dired-find-alternate-file)
  (define-key dired-mode-map (kbd "^") (lambda () (interactive) (find-alternate-file "..")))
  (define-key dired-mode-map (kbd "q") #'kill-current-buffer))
