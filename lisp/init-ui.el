(require 'init-const)

(set-face-attribute 'default nil :font (font-spec :family "JetBrains Mono Regular" :size 22))
(if (display-graphic-p) 
    (if *system-type-windows* 
        ;; (message "windows font is setted.")
        (dolist (charset '(kana han symbol cjk-misc bopomofo)) 
          (set-fontset-font (frame-parameter nil 'font)
                            charset
                            (font-spec :family "Sarasa Mono SC" :size 26))))) 

(menu-bar-mode -1) 
(tool-bar-mode -1)
(scroll-bar-mode -1)
;; disable startup screen
(setq inhibit-startup-screen t)
;; start the initial frame maximized
(add-to-list 'initial-frame-alist '(fullscreen . maximized))
;; start every frame maximized
;;(add-to-list 'default-frame-alist '(fullscreen . maximized))

(setq frame-title-format "%f")

;; highlight current line
(global-hl-line-mode t)

;; 取消光标闪烁
(blink-cursor-mode 0)

(provide 'init-ui)
