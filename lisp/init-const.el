;; 系统
;;(defconst *system-type-mac* (eq system-type 'darwin)
;;  "Const for system check, macOS.")
;;(defconst *system-type-linux* (eq system-type 'gnu/linux)
;;  "Const for system check, GNU/Linux.")
(defconst *system-type-windows* (or (eq system-type 'ms-dos) (eq system-type 'windows-nt))
  "Const for system check, Windows or DOS.")

(provide 'init-const)
