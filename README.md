# .emacs.d

Emacs 配置文件

## 用法

### 覆盖目录

#### 1. 直接复制到默认目录（%appdata%）

#### 2. 复制到 Emacs 所在目录

    |-- Emacs
        |-- config
            |-- .emacs.d

在 %appdata%/.emacs.d/init.el 中添加：

    (setenv "HOME" "X:/Emacs/config")
    (setenv "PATH" "X:/Emacs/config")
    (setq default-directory "~/")
    (load-file "X:/Emacs/config/.emacs.d/init.el")

### 修改一些固定变量

- lisp/init-edit.el
    + `org-html-postamble-format` 的 author
    + `org-export-output-file-name` 的 `org-output-dir`

## 参考

- [Spacemacs](https://github.com/syl20bnr/spacemacs)
- [Doom Emacs](https://github.com/hlissner/doom-emacs)
- [Prelude](https://github.com/bbatsov/prelude)
- [Emacs 自力求生指南](https://nyk.ma/posts/emacs-write-your-own/)
- [Emacs高手修炼手册](https://www.jianshu.com/p/42ef1b18d959)
