(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Some standard configuration
(if (display-graphic-p)
    (progn
      ;; if graphic
      (setq linum-format "%4d")
      (scroll-bar-mode 0))
  ;; else (optional)
  (menu-bar-mode 0)
  (setq linum-format "%4d\u2502"))

(global-linum-mode t)
(auto-compression-mode t)
(transient-mark-mode 1)       
(fset 'yes-or-no-p 'y-or-n-p)
(display-time)
(column-number-mode t)
(tool-bar-mode 0)

(setq next-line-add-newlines nil
      visible-bell t
      inhibit-startup-screen t
      display-time-24hr-format t
      auth-sources '("~/.authinfo"))

(setq lsp-ui-doc-show-with-cursor nil)

;; I like this font, change it to yours, or delete the lines to use
;; default
(set-face-attribute 'default nil
		    :font "Inconsolata-17")

(use-package flycheck :ensure)        ;; find errors on the fly
(use-package yasnippet :ensure)
(use-package yasnippet-snippets :ensure)
(use-package lsp-treemacs :ensure)
(use-package lsp-treemacs :ensure)
(use-package helm-lsp  :ensure)
(use-package projectile :ensure)
(use-package hydra :ensure) 
(use-package avy :ensure)
(use-package which-key :ensure)
(use-package helm-xref :ensure)

;; for python DAP install "debugpy
;; $ pip install debugpy
(use-package python-mode
  :ensure
  :after dap-mode
  :config
  (setq dap-python-debugger 'debugpy)
  (require 'dap-python))

(use-package dap-mode
  :ensure
  :after lsp-mode
  :config
  (setq dap-auto-configure-mode t)
  (require 'dap-ui)
  (dap-tooltip-mode t)
  (tooltip-mode t)
  :init
  (dap-mode 1))

(use-package lsp-mode
  :ensure
  :config
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration))

(use-package lsp-ui :ensure)

;; Python LSP need npm installed
(use-package lsp-pyright
  :ensure
  :config
  (add-hook 'python-mode-hook #'yas-minor-mode)
  (add-hook 'python-mode-hook #'lsp-deferred))

;; LSP is using this
(use-package company
  :ensure
  :bind
  (:map company-active-map
        ("C-n". company-select-next)
        ("C-p". company-select-previous)
        ("M-<". company-select-first)
        ("M->". company-select-last))
  ;(:map company-mode-map
  ;      ("<tab>". tab-indent-or-complete)
  ;      ("TAB". tab-indent-or-complete))
  :config
  (setq company-idle-delay 0.3)
  (setq company-minimum-prefix-length 1)
  (global-company-mode t))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(company lsp-pyright lsp-ui dap-mode python-mode lsp-treemacs yasnippet-snippets yasnippet flycheck use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
