(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-to-list 'load-path "~/.emacs.d/")
;(require 'ruby-mode)
;(add-to-list 'auto-mode-alist               '("\\.\\(?:gemspec\\|irbrc\\|gemrc\\|rake\\|rb\\|ru\\|thor\\)\\'" . ruby-mode))
;(add-to-list 'auto-mode-alist               '("\\(Capfile\\|Gemfile\\(?:\\.[a-zA-Z0-9._-]+\\)?\\|[rR]akefile\\)\\'" . ruby-mode))

;(add-to-list 'auto-mode-alist '("\\.js\\'" . javascript-mode))
;(autoload 'javascript-mode "javascript" nil t)
(require 'auto-complete)
(global-auto-complete-mode t)

;(require 'multi-web-mode)
;(setq mweb-default-major-mode 'html-mode)
;(setq mweb-tags '((php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
;		  (js-mode "<script +\\(type=\"text/javascript\"\\|language=\"javascript\"\\)[^>]*>" "</script>")
;		  (css-mode "<style +type=\"text/css\"[^>]*>" "</style>")))
;(setq mweb-filename-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5"))
;(multi-web-global-mode 1)

(setq-default indent-tabs-mode nil)

(require 'tramp)
(setq tramp-default-method "scp")

(require 'git)
(require 'git-blame)
;(load "~/.emacs.d/less-css-mode.el")

;(setq split-height-threshold nil)
;(setq split-width-threshold 0)

